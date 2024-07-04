-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
DO $$ BEGIN
 CREATE TYPE "auth"."aal_level" AS ENUM('aal1', 'aal2', 'aal3');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "auth"."code_challenge_method" AS ENUM('s256', 'plain');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "auth"."factor_status" AS ENUM('unverified', 'verified');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "auth"."factor_type" AS ENUM('totp', 'webauthn');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "net"."request_status" AS ENUM('PENDING', 'SUCCESS', 'ERROR');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "pgsodium"."key_status" AS ENUM('default', 'valid', 'invalid', 'expired');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "pgsodium"."key_type" AS ENUM('aead-ietf', 'aead-det', 'hmacsha512', 'hmacsha256', 'auth', 'shorthash', 'generichash', 'kdf', 'secretbox', 'secretstream', 'stream_xchacha20');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "realtime"."action" AS ENUM('INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'ERROR');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "realtime"."equality_op" AS ENUM('eq', 'neq', 'lt', 'lte', 'gt', 'gte', 'in');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "folders" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"name" text NOT NULL,
	"description" text NOT NULL,
	"type" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "files" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"description" text NOT NULL,
	"file_path" text NOT NULL,
	"name" text NOT NULL,
	"size" integer NOT NULL,
	"tokens" integer NOT NULL,
	"type" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "file_items" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"file_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"content" text NOT NULL,
	"local_embedding" "vector",
	"openai_embedding" "vector",
	"tokens" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "profiles" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"bio" text NOT NULL,
	"has_onboarded" boolean DEFAULT false NOT NULL,
	"image_url" text NOT NULL,
	"image_path" text NOT NULL,
	"profile_context" text NOT NULL,
	"display_name" text NOT NULL,
	"use_azure_openai" boolean NOT NULL,
	"username" text NOT NULL,
	"anthropic_api_key" text,
	"azure_openai_35_turbo_id" text,
	"azure_openai_45_turbo_id" text,
	"azure_openai_45_vision_id" text,
	"azure_openai_api_key" text,
	"azure_openai_endpoint" text,
	"google_gemini_api_key" text,
	"mistral_api_key" text,
	"openai_api_key" text,
	"openai_organization_id" text,
	"perplexity_api_key" text,
	"openrouter_api_key" text,
	"azure_openai_embeddings_id" text,
	"groq_api_key" text,
	CONSTRAINT "profiles_user_id_key" UNIQUE("user_id"),
	CONSTRAINT "profiles_username_key" UNIQUE("username")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "workspaces" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"default_context_length" integer NOT NULL,
	"default_model" text NOT NULL,
	"default_prompt" text NOT NULL,
	"default_temperature" real NOT NULL,
	"description" text NOT NULL,
	"embeddings_provider" text NOT NULL,
	"include_profile_context" boolean NOT NULL,
	"include_workspace_instructions" boolean NOT NULL,
	"instructions" text NOT NULL,
	"is_home" boolean DEFAULT false NOT NULL,
	"name" text NOT NULL,
	"image_path" text DEFAULT '' NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "presets" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"context_length" integer NOT NULL,
	"description" text NOT NULL,
	"embeddings_provider" text NOT NULL,
	"include_profile_context" boolean NOT NULL,
	"include_workspace_instructions" boolean NOT NULL,
	"model" text NOT NULL,
	"name" text NOT NULL,
	"prompt" text NOT NULL,
	"temperature" real NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "assistants" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"context_length" integer NOT NULL,
	"description" text NOT NULL,
	"embeddings_provider" text NOT NULL,
	"include_profile_context" boolean NOT NULL,
	"include_workspace_instructions" boolean NOT NULL,
	"model" text NOT NULL,
	"name" text NOT NULL,
	"image_path" text NOT NULL,
	"prompt" text NOT NULL,
	"temperature" real NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chats" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"assistant_id" uuid,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"context_length" integer NOT NULL,
	"embeddings_provider" text NOT NULL,
	"include_profile_context" boolean NOT NULL,
	"include_workspace_instructions" boolean NOT NULL,
	"model" text NOT NULL,
	"name" text NOT NULL,
	"prompt" text NOT NULL,
	"temperature" real NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "tools" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"description" text NOT NULL,
	"name" text NOT NULL,
	"schema" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"url" text NOT NULL,
	"custom_headers" jsonb DEFAULT '{}'::jsonb NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "prompts" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"content" text NOT NULL,
	"name" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "messages" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"chat_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"content" text NOT NULL,
	"image_paths" text[] NOT NULL,
	"model" text NOT NULL,
	"role" text NOT NULL,
	"sequence_number" integer NOT NULL,
	"assistant_id" uuid
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "collections" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"description" text NOT NULL,
	"name" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "models" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"user_id" uuid NOT NULL,
	"folder_id" uuid,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	"sharing" text DEFAULT 'private' NOT NULL,
	"api_key" text NOT NULL,
	"base_url" text NOT NULL,
	"description" text NOT NULL,
	"model_id" text NOT NULL,
	"name" text NOT NULL,
	"context_length" integer DEFAULT 4096 NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "file_workspaces" (
	"user_id" uuid NOT NULL,
	"file_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "file_workspaces_pkey" PRIMARY KEY("file_id","workspace_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "preset_workspaces" (
	"user_id" uuid NOT NULL,
	"preset_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "preset_workspaces_pkey" PRIMARY KEY("preset_id","workspace_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "chat_files" (
	"user_id" uuid NOT NULL,
	"chat_id" uuid NOT NULL,
	"file_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "chat_files_pkey" PRIMARY KEY("chat_id","file_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "assistant_collections" (
	"user_id" uuid NOT NULL,
	"assistant_id" uuid NOT NULL,
	"collection_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "assistant_collections_pkey" PRIMARY KEY("assistant_id","collection_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "assistant_workspaces" (
	"user_id" uuid NOT NULL,
	"assistant_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "assistant_workspaces_pkey" PRIMARY KEY("assistant_id","workspace_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "message_file_items" (
	"user_id" uuid NOT NULL,
	"message_id" uuid NOT NULL,
	"file_item_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "message_file_items_pkey" PRIMARY KEY("message_id","file_item_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "collection_workspaces" (
	"user_id" uuid NOT NULL,
	"collection_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "collection_workspaces_pkey" PRIMARY KEY("collection_id","workspace_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "prompt_workspaces" (
	"user_id" uuid NOT NULL,
	"prompt_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "prompt_workspaces_pkey" PRIMARY KEY("prompt_id","workspace_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "collection_files" (
	"user_id" uuid NOT NULL,
	"collection_id" uuid NOT NULL,
	"file_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "collection_files_pkey" PRIMARY KEY("collection_id","file_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "assistant_files" (
	"user_id" uuid NOT NULL,
	"assistant_id" uuid NOT NULL,
	"file_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "assistant_files_pkey" PRIMARY KEY("assistant_id","file_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "tool_workspaces" (
	"user_id" uuid NOT NULL,
	"tool_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "tool_workspaces_pkey" PRIMARY KEY("tool_id","workspace_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "assistant_tools" (
	"user_id" uuid NOT NULL,
	"assistant_id" uuid NOT NULL,
	"tool_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "assistant_tools_pkey" PRIMARY KEY("assistant_id","tool_id")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "model_workspaces" (
	"user_id" uuid NOT NULL,
	"model_id" uuid NOT NULL,
	"workspace_id" uuid NOT NULL,
	"created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updated_at" timestamp with time zone,
	CONSTRAINT "model_workspaces_pkey" PRIMARY KEY("model_id","workspace_id")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "folders" ADD CONSTRAINT "folders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "folders" ADD CONSTRAINT "folders_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "files" ADD CONSTRAINT "files_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "files" ADD CONSTRAINT "files_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "file_items" ADD CONSTRAINT "file_items_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "file_items" ADD CONSTRAINT "file_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "profiles" ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "workspaces" ADD CONSTRAINT "workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "presets" ADD CONSTRAINT "presets_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "presets" ADD CONSTRAINT "presets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistants" ADD CONSTRAINT "assistants_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistants" ADD CONSTRAINT "assistants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_assistant_id_fkey" FOREIGN KEY ("assistant_id") REFERENCES "public"."assistants"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chats" ADD CONSTRAINT "chats_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tools" ADD CONSTRAINT "tools_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tools" ADD CONSTRAINT "tools_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "prompts" ADD CONSTRAINT "prompts_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "prompts" ADD CONSTRAINT "prompts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_assistant_id_fkey" FOREIGN KEY ("assistant_id") REFERENCES "public"."assistants"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "public"."chats"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "messages" ADD CONSTRAINT "messages_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collections" ADD CONSTRAINT "collections_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collections" ADD CONSTRAINT "collections_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "models" ADD CONSTRAINT "models_folder_id_fkey" FOREIGN KEY ("folder_id") REFERENCES "public"."folders"("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "models" ADD CONSTRAINT "models_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "file_workspaces" ADD CONSTRAINT "file_workspaces_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "file_workspaces" ADD CONSTRAINT "file_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "file_workspaces" ADD CONSTRAINT "file_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "preset_workspaces" ADD CONSTRAINT "preset_workspaces_preset_id_fkey" FOREIGN KEY ("preset_id") REFERENCES "public"."presets"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "preset_workspaces" ADD CONSTRAINT "preset_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "preset_workspaces" ADD CONSTRAINT "preset_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_files" ADD CONSTRAINT "chat_files_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "public"."chats"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_files" ADD CONSTRAINT "chat_files_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "chat_files" ADD CONSTRAINT "chat_files_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_collections" ADD CONSTRAINT "assistant_collections_assistant_id_fkey" FOREIGN KEY ("assistant_id") REFERENCES "public"."assistants"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_collections" ADD CONSTRAINT "assistant_collections_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "public"."collections"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_collections" ADD CONSTRAINT "assistant_collections_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_workspaces" ADD CONSTRAINT "assistant_workspaces_assistant_id_fkey" FOREIGN KEY ("assistant_id") REFERENCES "public"."assistants"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_workspaces" ADD CONSTRAINT "assistant_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_workspaces" ADD CONSTRAINT "assistant_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "message_file_items" ADD CONSTRAINT "message_file_items_file_item_id_fkey" FOREIGN KEY ("file_item_id") REFERENCES "public"."file_items"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "message_file_items" ADD CONSTRAINT "message_file_items_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "message_file_items" ADD CONSTRAINT "message_file_items_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collection_workspaces" ADD CONSTRAINT "collection_workspaces_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "public"."collections"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collection_workspaces" ADD CONSTRAINT "collection_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collection_workspaces" ADD CONSTRAINT "collection_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "prompt_workspaces" ADD CONSTRAINT "prompt_workspaces_prompt_id_fkey" FOREIGN KEY ("prompt_id") REFERENCES "public"."prompts"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "prompt_workspaces" ADD CONSTRAINT "prompt_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "prompt_workspaces" ADD CONSTRAINT "prompt_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collection_files" ADD CONSTRAINT "collection_files_collection_id_fkey" FOREIGN KEY ("collection_id") REFERENCES "public"."collections"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collection_files" ADD CONSTRAINT "collection_files_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "collection_files" ADD CONSTRAINT "collection_files_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_files" ADD CONSTRAINT "assistant_files_assistant_id_fkey" FOREIGN KEY ("assistant_id") REFERENCES "public"."assistants"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_files" ADD CONSTRAINT "assistant_files_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "public"."files"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_files" ADD CONSTRAINT "assistant_files_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tool_workspaces" ADD CONSTRAINT "tool_workspaces_tool_id_fkey" FOREIGN KEY ("tool_id") REFERENCES "public"."tools"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tool_workspaces" ADD CONSTRAINT "tool_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "tool_workspaces" ADD CONSTRAINT "tool_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_tools" ADD CONSTRAINT "assistant_tools_assistant_id_fkey" FOREIGN KEY ("assistant_id") REFERENCES "public"."assistants"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_tools" ADD CONSTRAINT "assistant_tools_tool_id_fkey" FOREIGN KEY ("tool_id") REFERENCES "public"."tools"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "assistant_tools" ADD CONSTRAINT "assistant_tools_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "model_workspaces" ADD CONSTRAINT "model_workspaces_model_id_fkey" FOREIGN KEY ("model_id") REFERENCES "public"."models"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "model_workspaces" ADD CONSTRAINT "model_workspaces_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "model_workspaces" ADD CONSTRAINT "model_workspaces_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "public"."workspaces"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "folders_user_id_idx" ON "folders" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "folders_workspace_id_idx" ON "folders" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "files_user_id_idx" ON "files" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "file_items_file_id_idx" ON "file_items" ("file_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "file_items_embedding_idx" ON "file_items" ("openai_embedding");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "file_items_local_embedding_idx" ON "file_items" ("local_embedding");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_profiles_user_id" ON "profiles" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_workspaces_user_id" ON "workspaces" ("user_id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "idx_unique_home_workspace_per_user" ON "workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "presets_user_id_idx" ON "presets" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistants_user_id_idx" ON "assistants" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_chats_user_id" ON "chats" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_chats_workspace_id" ON "chats" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "tools_user_id_idx" ON "tools" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "prompts_user_id_idx" ON "prompts" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_messages_chat_id" ON "messages" ("chat_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "collections_user_id_idx" ON "collections" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "models_user_id_idx" ON "models" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "file_workspaces_user_id_idx" ON "file_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "file_workspaces_file_id_idx" ON "file_workspaces" ("file_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "file_workspaces_workspace_id_idx" ON "file_workspaces" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "preset_workspaces_user_id_idx" ON "preset_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "preset_workspaces_preset_id_idx" ON "preset_workspaces" ("preset_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "preset_workspaces_workspace_id_idx" ON "preset_workspaces" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_chat_files_chat_id" ON "chat_files" ("chat_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_collections_user_id_idx" ON "assistant_collections" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_collections_assistant_id_idx" ON "assistant_collections" ("assistant_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_collections_collection_id_idx" ON "assistant_collections" ("collection_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_workspaces_user_id_idx" ON "assistant_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_workspaces_assistant_id_idx" ON "assistant_workspaces" ("assistant_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_workspaces_workspace_id_idx" ON "assistant_workspaces" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_message_file_items_message_id" ON "message_file_items" ("message_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "collection_workspaces_user_id_idx" ON "collection_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "collection_workspaces_collection_id_idx" ON "collection_workspaces" ("collection_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "collection_workspaces_workspace_id_idx" ON "collection_workspaces" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "prompt_workspaces_user_id_idx" ON "prompt_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "prompt_workspaces_prompt_id_idx" ON "prompt_workspaces" ("prompt_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "prompt_workspaces_workspace_id_idx" ON "prompt_workspaces" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_collection_files_collection_id" ON "collection_files" ("collection_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "idx_collection_files_file_id" ON "collection_files" ("file_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_files_user_id_idx" ON "assistant_files" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_files_assistant_id_idx" ON "assistant_files" ("assistant_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_files_file_id_idx" ON "assistant_files" ("file_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "tool_workspaces_user_id_idx" ON "tool_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "tool_workspaces_tool_id_idx" ON "tool_workspaces" ("tool_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "tool_workspaces_workspace_id_idx" ON "tool_workspaces" ("workspace_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_tools_user_id_idx" ON "assistant_tools" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_tools_assistant_id_idx" ON "assistant_tools" ("assistant_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "assistant_tools_tool_id_idx" ON "assistant_tools" ("tool_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "model_workspaces_user_id_idx" ON "model_workspaces" ("user_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "model_workspaces_model_id_idx" ON "model_workspaces" ("model_id");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "model_workspaces_workspace_id_idx" ON "model_workspaces" ("workspace_id");
*/