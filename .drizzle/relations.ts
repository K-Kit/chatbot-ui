import { relations } from "drizzle-orm/relations";
import { usersInAuth, folders, workspaces, files, file_items, profiles, presets, assistants, chats, tools, prompts, messages, collections, models, file_workspaces, preset_workspaces, chat_files, assistant_collections, assistant_workspaces, message_file_items, collection_workspaces, prompt_workspaces, collection_files, assistant_files, tool_workspaces, assistant_tools, model_workspaces } from "./schema";

export const foldersRelations = relations(folders, ({one, many}) => ({
	usersInAuth: one(usersInAuth, {
		fields: [folders.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [folders.workspace_id],
		references: [workspaces.id]
	}),
	files: many(files),
	presets: many(presets),
	assistants: many(assistants),
	chats: many(chats),
	tools: many(tools),
	prompts: many(prompts),
	collections: many(collections),
	models: many(models),
}));

export const usersInAuthRelations = relations(usersInAuth, ({many}) => ({
	folders: many(folders),
	files: many(files),
	file_items: many(file_items),
	profiles: many(profiles),
	workspaces: many(workspaces),
	presets: many(presets),
	assistants: many(assistants),
	chats: many(chats),
	tools: many(tools),
	prompts: many(prompts),
	messages: many(messages),
	collections: many(collections),
	models: many(models),
	file_workspaces: many(file_workspaces),
	preset_workspaces: many(preset_workspaces),
	chat_files: many(chat_files),
	assistant_collections: many(assistant_collections),
	assistant_workspaces: many(assistant_workspaces),
	message_file_items: many(message_file_items),
	collection_workspaces: many(collection_workspaces),
	prompt_workspaces: many(prompt_workspaces),
	collection_files: many(collection_files),
	assistant_files: many(assistant_files),
	tool_workspaces: many(tool_workspaces),
	assistant_tools: many(assistant_tools),
	model_workspaces: many(model_workspaces),
}));

export const workspacesRelations = relations(workspaces, ({one, many}) => ({
	folders: many(folders),
	usersInAuth: one(usersInAuth, {
		fields: [workspaces.user_id],
		references: [usersInAuth.id]
	}),
	chats: many(chats),
	file_workspaces: many(file_workspaces),
	preset_workspaces: many(preset_workspaces),
	assistant_workspaces: many(assistant_workspaces),
	collection_workspaces: many(collection_workspaces),
	prompt_workspaces: many(prompt_workspaces),
	tool_workspaces: many(tool_workspaces),
	model_workspaces: many(model_workspaces),
}));

export const filesRelations = relations(files, ({one, many}) => ({
	folder: one(folders, {
		fields: [files.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [files.user_id],
		references: [usersInAuth.id]
	}),
	file_items: many(file_items),
	file_workspaces: many(file_workspaces),
	chat_files: many(chat_files),
	collection_files: many(collection_files),
	assistant_files: many(assistant_files),
}));

export const file_itemsRelations = relations(file_items, ({one, many}) => ({
	file: one(files, {
		fields: [file_items.file_id],
		references: [files.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [file_items.user_id],
		references: [usersInAuth.id]
	}),
	message_file_items: many(message_file_items),
}));

export const profilesRelations = relations(profiles, ({one}) => ({
	usersInAuth: one(usersInAuth, {
		fields: [profiles.user_id],
		references: [usersInAuth.id]
	}),
}));

export const presetsRelations = relations(presets, ({one, many}) => ({
	folder: one(folders, {
		fields: [presets.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [presets.user_id],
		references: [usersInAuth.id]
	}),
	preset_workspaces: many(preset_workspaces),
}));

export const assistantsRelations = relations(assistants, ({one, many}) => ({
	folder: one(folders, {
		fields: [assistants.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [assistants.user_id],
		references: [usersInAuth.id]
	}),
	chats: many(chats),
	messages: many(messages),
	assistant_collections: many(assistant_collections),
	assistant_workspaces: many(assistant_workspaces),
	assistant_files: many(assistant_files),
	assistant_tools: many(assistant_tools),
}));

export const chatsRelations = relations(chats, ({one, many}) => ({
	assistant: one(assistants, {
		fields: [chats.assistant_id],
		references: [assistants.id]
	}),
	folder: one(folders, {
		fields: [chats.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [chats.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [chats.workspace_id],
		references: [workspaces.id]
	}),
	messages: many(messages),
	chat_files: many(chat_files),
}));

export const toolsRelations = relations(tools, ({one, many}) => ({
	folder: one(folders, {
		fields: [tools.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [tools.user_id],
		references: [usersInAuth.id]
	}),
	tool_workspaces: many(tool_workspaces),
	assistant_tools: many(assistant_tools),
}));

export const promptsRelations = relations(prompts, ({one, many}) => ({
	folder: one(folders, {
		fields: [prompts.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [prompts.user_id],
		references: [usersInAuth.id]
	}),
	prompt_workspaces: many(prompt_workspaces),
}));

export const messagesRelations = relations(messages, ({one, many}) => ({
	assistant: one(assistants, {
		fields: [messages.assistant_id],
		references: [assistants.id]
	}),
	chat: one(chats, {
		fields: [messages.chat_id],
		references: [chats.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [messages.user_id],
		references: [usersInAuth.id]
	}),
	message_file_items: many(message_file_items),
}));

export const collectionsRelations = relations(collections, ({one, many}) => ({
	folder: one(folders, {
		fields: [collections.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [collections.user_id],
		references: [usersInAuth.id]
	}),
	assistant_collections: many(assistant_collections),
	collection_workspaces: many(collection_workspaces),
	collection_files: many(collection_files),
}));

export const modelsRelations = relations(models, ({one, many}) => ({
	folder: one(folders, {
		fields: [models.folder_id],
		references: [folders.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [models.user_id],
		references: [usersInAuth.id]
	}),
	model_workspaces: many(model_workspaces),
}));

export const file_workspacesRelations = relations(file_workspaces, ({one}) => ({
	file: one(files, {
		fields: [file_workspaces.file_id],
		references: [files.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [file_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [file_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));

export const preset_workspacesRelations = relations(preset_workspaces, ({one}) => ({
	preset: one(presets, {
		fields: [preset_workspaces.preset_id],
		references: [presets.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [preset_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [preset_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));

export const chat_filesRelations = relations(chat_files, ({one}) => ({
	chat: one(chats, {
		fields: [chat_files.chat_id],
		references: [chats.id]
	}),
	file: one(files, {
		fields: [chat_files.file_id],
		references: [files.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [chat_files.user_id],
		references: [usersInAuth.id]
	}),
}));

export const assistant_collectionsRelations = relations(assistant_collections, ({one}) => ({
	assistant: one(assistants, {
		fields: [assistant_collections.assistant_id],
		references: [assistants.id]
	}),
	collection: one(collections, {
		fields: [assistant_collections.collection_id],
		references: [collections.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [assistant_collections.user_id],
		references: [usersInAuth.id]
	}),
}));

export const assistant_workspacesRelations = relations(assistant_workspaces, ({one}) => ({
	assistant: one(assistants, {
		fields: [assistant_workspaces.assistant_id],
		references: [assistants.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [assistant_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [assistant_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));

export const message_file_itemsRelations = relations(message_file_items, ({one}) => ({
	file_item: one(file_items, {
		fields: [message_file_items.file_item_id],
		references: [file_items.id]
	}),
	message: one(messages, {
		fields: [message_file_items.message_id],
		references: [messages.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [message_file_items.user_id],
		references: [usersInAuth.id]
	}),
}));

export const collection_workspacesRelations = relations(collection_workspaces, ({one}) => ({
	collection: one(collections, {
		fields: [collection_workspaces.collection_id],
		references: [collections.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [collection_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [collection_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));

export const prompt_workspacesRelations = relations(prompt_workspaces, ({one}) => ({
	prompt: one(prompts, {
		fields: [prompt_workspaces.prompt_id],
		references: [prompts.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [prompt_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [prompt_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));

export const collection_filesRelations = relations(collection_files, ({one}) => ({
	collection: one(collections, {
		fields: [collection_files.collection_id],
		references: [collections.id]
	}),
	file: one(files, {
		fields: [collection_files.file_id],
		references: [files.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [collection_files.user_id],
		references: [usersInAuth.id]
	}),
}));

export const assistant_filesRelations = relations(assistant_files, ({one}) => ({
	assistant: one(assistants, {
		fields: [assistant_files.assistant_id],
		references: [assistants.id]
	}),
	file: one(files, {
		fields: [assistant_files.file_id],
		references: [files.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [assistant_files.user_id],
		references: [usersInAuth.id]
	}),
}));

export const tool_workspacesRelations = relations(tool_workspaces, ({one}) => ({
	tool: one(tools, {
		fields: [tool_workspaces.tool_id],
		references: [tools.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [tool_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [tool_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));

export const assistant_toolsRelations = relations(assistant_tools, ({one}) => ({
	assistant: one(assistants, {
		fields: [assistant_tools.assistant_id],
		references: [assistants.id]
	}),
	tool: one(tools, {
		fields: [assistant_tools.tool_id],
		references: [tools.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [assistant_tools.user_id],
		references: [usersInAuth.id]
	}),
}));

export const model_workspacesRelations = relations(model_workspaces, ({one}) => ({
	model: one(models, {
		fields: [model_workspaces.model_id],
		references: [models.id]
	}),
	usersInAuth: one(usersInAuth, {
		fields: [model_workspaces.user_id],
		references: [usersInAuth.id]
	}),
	workspace: one(workspaces, {
		fields: [model_workspaces.workspace_id],
		references: [workspaces.id]
	}),
}));