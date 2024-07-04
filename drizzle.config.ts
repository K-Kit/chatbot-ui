import { defineConfig } from "drizzle-kit";
import dotenv from "dotenv"
dotenv.config({
    path: process.env.NODE_ENV === "development" ? ".env.local" : ".env"
})

export default defineConfig({
    dialect: "postgresql",
    schema: "./db/schema.ts",
    out: "./drizzle",
    dbCredentials: {
        url: process.env.DB_URL as string
    }
});