import { pgTable, index, foreignKey, pgEnum, uuid, timestamp, text, integer, unique, boolean, uniqueIndex, real, jsonb, primaryKey } from "drizzle-orm/pg-core"
  import { sql } from "drizzle-orm"

export const aal_level = pgEnum("aal_level", ['aal1', 'aal2', 'aal3'])
export const code_challenge_method = pgEnum("code_challenge_method", ['s256', 'plain'])
export const factor_status = pgEnum("factor_status", ['unverified', 'verified'])
export const factor_type = pgEnum("factor_type", ['totp', 'webauthn'])
export const request_status = pgEnum("request_status", ['PENDING', 'SUCCESS', 'ERROR'])
export const key_status = pgEnum("key_status", ['default', 'valid', 'invalid', 'expired'])
export const key_type = pgEnum("key_type", ['aead-ietf', 'aead-det', 'hmacsha512', 'hmacsha256', 'auth', 'shorthash', 'generichash', 'kdf', 'secretbox', 'secretstream', 'stream_xchacha20'])
export const action = pgEnum("action", ['INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'ERROR'])
export const equality_op = pgEnum("equality_op", ['eq', 'neq', 'lt', 'lte', 'gt', 'gte', 'in'])


export const folders = pgTable("folders", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	name: text("name").notNull(),
	description: text("description").notNull(),
	type: text("type").notNull(),
},
(table) => {
	return {
		user_id_idx: index("folders_user_id_idx").on(table.user_id),
		workspace_id_idx: index("folders_workspace_id_idx").on(table.workspace_id),
	}
});

export const files = pgTable("files", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	description: text("description").notNull(),
	file_path: text("file_path").notNull(),
	name: text("name").notNull(),
	size: integer("size").notNull(),
	tokens: integer("tokens").notNull(),
	type: text("type").notNull(),
},
(table) => {
	return {
		user_id_idx: index("files_user_id_idx").on(table.user_id),
	}
});

export const file_items = pgTable("file_items", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	file_id: uuid("file_id").notNull().references(() => files.id, { onDelete: "cascade" } ),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	content: text("content").notNull(),
	// TODO: failed to parse database type 'vector'
	local_embedding: unknown("local_embedding"),
	// TODO: failed to parse database type 'vector'
	openai_embedding: unknown("openai_embedding"),
	tokens: integer("tokens").notNull(),
},
(table) => {
	return {
		file_id_idx: index("file_items_file_id_idx").on(table.file_id),
		embedding_idx: index("file_items_embedding_idx").on(table.openai_embedding),
		local_embedding_idx: index("file_items_local_embedding_idx").on(table.local_embedding),
	}
});

export const profiles = pgTable("profiles", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	bio: text("bio").notNull(),
	has_onboarded: boolean("has_onboarded").default(false).notNull(),
	image_url: text("image_url").notNull(),
	image_path: text("image_path").notNull(),
	profile_context: text("profile_context").notNull(),
	display_name: text("display_name").notNull(),
	use_azure_openai: boolean("use_azure_openai").notNull(),
	username: text("username").notNull(),
	anthropic_api_key: text("anthropic_api_key"),
	azure_openai_35_turbo_id: text("azure_openai_35_turbo_id"),
	azure_openai_45_turbo_id: text("azure_openai_45_turbo_id"),
	azure_openai_45_vision_id: text("azure_openai_45_vision_id"),
	azure_openai_api_key: text("azure_openai_api_key"),
	azure_openai_endpoint: text("azure_openai_endpoint"),
	google_gemini_api_key: text("google_gemini_api_key"),
	mistral_api_key: text("mistral_api_key"),
	openai_api_key: text("openai_api_key"),
	openai_organization_id: text("openai_organization_id"),
	perplexity_api_key: text("perplexity_api_key"),
	openrouter_api_key: text("openrouter_api_key"),
	azure_openai_embeddings_id: text("azure_openai_embeddings_id"),
	groq_api_key: text("groq_api_key"),
},
(table) => {
	return {
		idx_profiles_user_id: index("idx_profiles_user_id").on(table.user_id),
		profiles_user_id_key: unique("profiles_user_id_key").on(table.user_id),
		profiles_username_key: unique("profiles_username_key").on(table.username),
	}
});

export const workspaces = pgTable("workspaces", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	default_context_length: integer("default_context_length").notNull(),
	default_model: text("default_model").notNull(),
	default_prompt: text("default_prompt").notNull(),
	default_temperature: real("default_temperature").notNull(),
	description: text("description").notNull(),
	embeddings_provider: text("embeddings_provider").notNull(),
	include_profile_context: boolean("include_profile_context").notNull(),
	include_workspace_instructions: boolean("include_workspace_instructions").notNull(),
	instructions: text("instructions").notNull(),
	is_home: boolean("is_home").default(false).notNull(),
	name: text("name").notNull(),
	image_path: text("image_path").default('').notNull(),
},
(table) => {
	return {
		idx_workspaces_user_id: index("idx_workspaces_user_id").on(table.user_id),
		idx_unique_home_workspace_per_user: uniqueIndex("idx_unique_home_workspace_per_user").on(table.user_id),
	}
});

export const presets = pgTable("presets", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	context_length: integer("context_length").notNull(),
	description: text("description").notNull(),
	embeddings_provider: text("embeddings_provider").notNull(),
	include_profile_context: boolean("include_profile_context").notNull(),
	include_workspace_instructions: boolean("include_workspace_instructions").notNull(),
	model: text("model").notNull(),
	name: text("name").notNull(),
	prompt: text("prompt").notNull(),
	temperature: real("temperature").notNull(),
},
(table) => {
	return {
		user_id_idx: index("presets_user_id_idx").on(table.user_id),
	}
});

export const assistants = pgTable("assistants", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	context_length: integer("context_length").notNull(),
	description: text("description").notNull(),
	embeddings_provider: text("embeddings_provider").notNull(),
	include_profile_context: boolean("include_profile_context").notNull(),
	include_workspace_instructions: boolean("include_workspace_instructions").notNull(),
	model: text("model").notNull(),
	name: text("name").notNull(),
	image_path: text("image_path").notNull(),
	prompt: text("prompt").notNull(),
	temperature: real("temperature").notNull(),
},
(table) => {
	return {
		user_id_idx: index("assistants_user_id_idx").on(table.user_id),
	}
});

export const chats = pgTable("chats", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	assistant_id: uuid("assistant_id").references(() => assistants.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	context_length: integer("context_length").notNull(),
	embeddings_provider: text("embeddings_provider").notNull(),
	include_profile_context: boolean("include_profile_context").notNull(),
	include_workspace_instructions: boolean("include_workspace_instructions").notNull(),
	model: text("model").notNull(),
	name: text("name").notNull(),
	prompt: text("prompt").notNull(),
	temperature: real("temperature").notNull(),
},
(table) => {
	return {
		idx_chats_user_id: index("idx_chats_user_id").on(table.user_id),
		idx_chats_workspace_id: index("idx_chats_workspace_id").on(table.workspace_id),
	}
});

export const tools = pgTable("tools", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	description: text("description").notNull(),
	name: text("name").notNull(),
	schema: jsonb("schema").default({}).notNull(),
	url: text("url").notNull(),
	custom_headers: jsonb("custom_headers").default({}).notNull(),
},
(table) => {
	return {
		user_id_idx: index("tools_user_id_idx").on(table.user_id),
	}
});

export const prompts = pgTable("prompts", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	content: text("content").notNull(),
	name: text("name").notNull(),
},
(table) => {
	return {
		user_id_idx: index("prompts_user_id_idx").on(table.user_id),
	}
});

export const messages = pgTable("messages", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	chat_id: uuid("chat_id").notNull().references(() => chats.id, { onDelete: "cascade" } ),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	content: text("content").notNull(),
	image_paths: text("image_paths").array().notNull(),
	model: text("model").notNull(),
	role: text("role").notNull(),
	sequence_number: integer("sequence_number").notNull(),
	assistant_id: uuid("assistant_id").references(() => assistants.id, { onDelete: "cascade" } ),
},
(table) => {
	return {
		idx_messages_chat_id: index("idx_messages_chat_id").on(table.chat_id),
	}
});

export const collections = pgTable("collections", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	description: text("description").notNull(),
	name: text("name").notNull(),
},
(table) => {
	return {
		user_id_idx: index("collections_user_id_idx").on(table.user_id),
	}
});

export const models = pgTable("models", {
	id: uuid("id").default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	folder_id: uuid("folder_id").references(() => folders.id, { onDelete: "set null" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
	sharing: text("sharing").default('private').notNull(),
	api_key: text("api_key").notNull(),
	base_url: text("base_url").notNull(),
	description: text("description").notNull(),
	model_id: text("model_id").notNull(),
	name: text("name").notNull(),
	context_length: integer("context_length").default(4096).notNull(),
},
(table) => {
	return {
		user_id_idx: index("models_user_id_idx").on(table.user_id),
	}
});

export const file_workspaces = pgTable("file_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	file_id: uuid("file_id").notNull().references(() => files.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("file_workspaces_user_id_idx").on(table.user_id),
		file_id_idx: index("file_workspaces_file_id_idx").on(table.file_id),
		workspace_id_idx: index("file_workspaces_workspace_id_idx").on(table.workspace_id),
		file_workspaces_pkey: primaryKey({ columns: [table.file_id, table.workspace_id], name: "file_workspaces_pkey"}),
	}
});

export const preset_workspaces = pgTable("preset_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	preset_id: uuid("preset_id").notNull().references(() => presets.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("preset_workspaces_user_id_idx").on(table.user_id),
		preset_id_idx: index("preset_workspaces_preset_id_idx").on(table.preset_id),
		workspace_id_idx: index("preset_workspaces_workspace_id_idx").on(table.workspace_id),
		preset_workspaces_pkey: primaryKey({ columns: [table.preset_id, table.workspace_id], name: "preset_workspaces_pkey"}),
	}
});

export const chat_files = pgTable("chat_files", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	chat_id: uuid("chat_id").notNull().references(() => chats.id, { onDelete: "cascade" } ),
	file_id: uuid("file_id").notNull().references(() => files.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		idx_chat_files_chat_id: index("idx_chat_files_chat_id").on(table.chat_id),
		chat_files_pkey: primaryKey({ columns: [table.chat_id, table.file_id], name: "chat_files_pkey"}),
	}
});

export const assistant_collections = pgTable("assistant_collections", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	assistant_id: uuid("assistant_id").notNull().references(() => assistants.id, { onDelete: "cascade" } ),
	collection_id: uuid("collection_id").notNull().references(() => collections.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("assistant_collections_user_id_idx").on(table.user_id),
		assistant_id_idx: index("assistant_collections_assistant_id_idx").on(table.assistant_id),
		collection_id_idx: index("assistant_collections_collection_id_idx").on(table.collection_id),
		assistant_collections_pkey: primaryKey({ columns: [table.assistant_id, table.collection_id], name: "assistant_collections_pkey"}),
	}
});

export const assistant_workspaces = pgTable("assistant_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	assistant_id: uuid("assistant_id").notNull().references(() => assistants.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("assistant_workspaces_user_id_idx").on(table.user_id),
		assistant_id_idx: index("assistant_workspaces_assistant_id_idx").on(table.assistant_id),
		workspace_id_idx: index("assistant_workspaces_workspace_id_idx").on(table.workspace_id),
		assistant_workspaces_pkey: primaryKey({ columns: [table.assistant_id, table.workspace_id], name: "assistant_workspaces_pkey"}),
	}
});

export const message_file_items = pgTable("message_file_items", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	message_id: uuid("message_id").notNull().references(() => messages.id, { onDelete: "cascade" } ),
	file_item_id: uuid("file_item_id").notNull().references(() => file_items.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		idx_message_file_items_message_id: index("idx_message_file_items_message_id").on(table.message_id),
		message_file_items_pkey: primaryKey({ columns: [table.message_id, table.file_item_id], name: "message_file_items_pkey"}),
	}
});

export const collection_workspaces = pgTable("collection_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	collection_id: uuid("collection_id").notNull().references(() => collections.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("collection_workspaces_user_id_idx").on(table.user_id),
		collection_id_idx: index("collection_workspaces_collection_id_idx").on(table.collection_id),
		workspace_id_idx: index("collection_workspaces_workspace_id_idx").on(table.workspace_id),
		collection_workspaces_pkey: primaryKey({ columns: [table.collection_id, table.workspace_id], name: "collection_workspaces_pkey"}),
	}
});

export const prompt_workspaces = pgTable("prompt_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	prompt_id: uuid("prompt_id").notNull().references(() => prompts.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("prompt_workspaces_user_id_idx").on(table.user_id),
		prompt_id_idx: index("prompt_workspaces_prompt_id_idx").on(table.prompt_id),
		workspace_id_idx: index("prompt_workspaces_workspace_id_idx").on(table.workspace_id),
		prompt_workspaces_pkey: primaryKey({ columns: [table.prompt_id, table.workspace_id], name: "prompt_workspaces_pkey"}),
	}
});

export const collection_files = pgTable("collection_files", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	collection_id: uuid("collection_id").notNull().references(() => collections.id, { onDelete: "cascade" } ),
	file_id: uuid("file_id").notNull().references(() => files.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		idx_collection_files_collection_id: index("idx_collection_files_collection_id").on(table.collection_id),
		idx_collection_files_file_id: index("idx_collection_files_file_id").on(table.file_id),
		collection_files_pkey: primaryKey({ columns: [table.collection_id, table.file_id], name: "collection_files_pkey"}),
	}
});

export const assistant_files = pgTable("assistant_files", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	assistant_id: uuid("assistant_id").notNull().references(() => assistants.id, { onDelete: "cascade" } ),
	file_id: uuid("file_id").notNull().references(() => files.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("assistant_files_user_id_idx").on(table.user_id),
		assistant_id_idx: index("assistant_files_assistant_id_idx").on(table.assistant_id),
		file_id_idx: index("assistant_files_file_id_idx").on(table.file_id),
		assistant_files_pkey: primaryKey({ columns: [table.assistant_id, table.file_id], name: "assistant_files_pkey"}),
	}
});

export const tool_workspaces = pgTable("tool_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	tool_id: uuid("tool_id").notNull().references(() => tools.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("tool_workspaces_user_id_idx").on(table.user_id),
		tool_id_idx: index("tool_workspaces_tool_id_idx").on(table.tool_id),
		workspace_id_idx: index("tool_workspaces_workspace_id_idx").on(table.workspace_id),
		tool_workspaces_pkey: primaryKey({ columns: [table.tool_id, table.workspace_id], name: "tool_workspaces_pkey"}),
	}
});

export const assistant_tools = pgTable("assistant_tools", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	assistant_id: uuid("assistant_id").notNull().references(() => assistants.id, { onDelete: "cascade" } ),
	tool_id: uuid("tool_id").notNull().references(() => tools.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("assistant_tools_user_id_idx").on(table.user_id),
		assistant_id_idx: index("assistant_tools_assistant_id_idx").on(table.assistant_id),
		tool_id_idx: index("assistant_tools_tool_id_idx").on(table.tool_id),
		assistant_tools_pkey: primaryKey({ columns: [table.assistant_id, table.tool_id], name: "assistant_tools_pkey"}),
	}
});

export const model_workspaces = pgTable("model_workspaces", {
	user_id: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" } ),
	model_id: uuid("model_id").notNull().references(() => models.id, { onDelete: "cascade" } ),
	workspace_id: uuid("workspace_id").notNull().references(() => workspaces.id, { onDelete: "cascade" } ),
	created_at: timestamp("created_at", { withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updated_at: timestamp("updated_at", { withTimezone: true, mode: 'string' }),
},
(table) => {
	return {
		user_id_idx: index("model_workspaces_user_id_idx").on(table.user_id),
		model_id_idx: index("model_workspaces_model_id_idx").on(table.model_id),
		workspace_id_idx: index("model_workspaces_workspace_id_idx").on(table.workspace_id),
		model_workspaces_pkey: primaryKey({ columns: [table.model_id, table.workspace_id], name: "model_workspaces_pkey"}),
	}
});