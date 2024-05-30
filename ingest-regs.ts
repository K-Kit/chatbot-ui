import { createClient } from "@supabase/supabase-js"
import { Database } from "@/supabase/types"
import OpenAI from "openai"
import { processCSV, processJSON, processMarkdown, processPdf, processTxt } from "./lib/retrieval/processing"
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

const files: any[] = []
process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
const embeddingsProvider: any = "openai"
const supabase = createClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
)
async function loadFiles() {
    const stateRegsDir = 'state-regs'

    async function readFilesRecursively(directory: string) {
        const items = fs.readdirSync(directory, { withFileTypes: true });
        console.log(items)
        for (const item of items) {
            const fullPath = path.join(directory, item.name);
            if (item.isDirectory()) {
                await readFilesRecursively(fullPath);
            } else {
                const content = fs.readFileSync(fullPath)
                const tokens = content.length

                await createFile(item as any, {

                    name: item.name,
                    tokens,
                    file_path: fullPath,
                    type: "text",
                    size: fs.statSync(fullPath).size,
                    description: "",
                }, "openai").then(file => {
                    files.push(file)
                })

            }
        }
    }



    await readFilesRecursively(stateRegsDir);

}
async function generateAndStoreEmbeddings() {
    const openai = new OpenAI({
        apiKey: process.env.OPENAI_API_KEY || "",
    });
    console.log(files)

    for (const file of files) {
        const fileExtension = file.name.split(".").pop()?.toLowerCase()
        const blob = new Blob([fs.readFileSync(file.file_path)], { type: "text/plain" })



        let chunks: FileItemChunk[] = []

        switch (fileExtension) {
            case "csv":
                chunks = await processCSV(blob)
                break
            case "json":
                chunks = await processJSON(blob)
                break
            case "md":
                chunks = await processMarkdown(blob)
                break
            case "pdf":
                chunks = await processPdf(blob)
                break
            case "txt":
                chunks = await processTxt(blob)
                break
            default:
                console.log(`Unsupported file type: ${fileExtension}`)
        }

        let embeddings: any = []



        if (embeddingsProvider === "openai") {
            const response = await openai.embeddings.create({
                model: "text-embedding-3-small",
                input: chunks.map(chunk => chunk.content)
            })

            embeddings = response.data.map((item: any) => {
                return item.embedding
            })
        }
        const file_items = chunks.map((chunk, index) => ({
            file_id: file.id,
            user_id: "77908180-3057-4c8b-9dee-559465a903d1",
            content: chunk.content,
            tokens: chunk.tokens,
            openai_embedding:
                embeddingsProvider === "openai"
                    ? ((embeddings[index] || null) as any)
                    : null,
            local_embedding:
                embeddingsProvider === "local"
                    ? ((embeddings[index] || null) as any)
                    : null
        }))

        await supabase.from("file_items").upsert(file_items)

        const totalTokens = file_items.reduce((acc, item) => acc + item.tokens, 0)

        await supabase
            .from("files")
            .update({ tokens: totalTokens })
            .eq("id", file.id)
    }
}

const uploadFile = async (
    file: File,
    payload: {
        path: string
    }
) => {
    const SIZE_LIMIT = parseInt(
        process.env.NEXT_PUBLIC_USER_FILE_SIZE_LIMIT || "10000000"
    )

    if (file.size > SIZE_LIMIT) {
        throw new Error(
            `File must be less than ${Math.floor(SIZE_LIMIT / 1000000)}MB`
        )
    }

    const filePath = payload.path.replace(/[^a-z0-9/.]/gi, "_").toLowerCase()

    const { error } = await supabase.storage
        .from("files")
        .upload(filePath, file, {
            upsert: true
        })

    if (error) {
        throw new Error(error.message)
    }

    return filePath
}


const updateFile = async (
    fileId: string,
    file: TablesUpdate<"files">
) => {
    const { data: updatedFile, error } = await supabase
        .from("files")
        .update(file)
        .eq("id", fileId)
        .select("*")
        .single()

    if (error) {
        throw new Error(error.message)
    }

    return updatedFile
}

// For non-docx files
const createFile = async (
    file: File,
    fileRecord: TablesInsert<"files">,
    // workspace_id: string,
    embeddingsProvider: "openai" | "local"
) => {
    let validFilename = fileRecord.name.replace(/[^a-z0-9.]/gi, "_").toLowerCase()
    const extension = file.name.split(".").pop()
    const baseName = validFilename.substring(0, validFilename.lastIndexOf("."))
    const maxBaseNameLength = 100 - (extension?.length || 0) - 1
    if (baseName.length > maxBaseNameLength) {
        fileRecord.name = baseName.substring(0, maxBaseNameLength) + "." + extension
    } else {
        fileRecord.name = baseName + "." + extension
    }
    fileRecord.user_id = "77908180-3057-4c8b-9dee-559465a903d1"
    const { data: createdFile, error } = await supabase
        .from("files")
        .insert([fileRecord])
        .select("*")
        .single()

    if (error) {
        throw new Error(error.message)
    }

    const filePath = await uploadFile(file, {
        path: fileRecord.file_path
    })

    await updateFile(createdFile.id, {
        file_path: filePath
    })
    return createdFile

}

// After loading files, generate embeddings
loadFiles().then(() => {
    console.log("Files loaded, generating embeddings...");
    generateAndStoreEmbeddings(files).then(() => {
        console.log("Embeddings generated and stored successfully.");
    }).catch(error => {
        console.error("Failed to generate or store embeddings:", error);
    });
});


