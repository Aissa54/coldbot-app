export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          created_at: string
          updated_at: string
          subscription_status: 'active' | 'inactive' | 'cancelled'
          subscription_id: string | null
        }
        Insert: {
          email: string
          subscription_status?: 'active' | 'inactive' | 'cancelled'
          subscription_id?: string | null
        }
        Update: {
          email?: string
          subscription_status?: 'active' | 'inactive' | 'cancelled'
          subscription_id?: string | null
        }
      }
      documents: {
        Row: {
          id: string
          title: string
          content: string
          embedding: Json | null
          created_at: string
          updated_at: string
          type: 'pdf' | 'word' | 'excel' | 'json' | 'xml'
        }
        Insert: {
          title: string
          content: string
          embedding?: Json | null
          type: 'pdf' | 'word' | 'excel' | 'json' | 'xml'
        }
        Update: {
          title?: string
          content?: string
          embedding?: Json | null
          type?: 'pdf' | 'word' | 'excel' | 'json' | 'xml'
        }
      }
      conversations: {
        Row: {
          id: string
          user_id: string
          created_at: string
          updated_at: string
        }
        Insert: {
          user_id: string
        }
        Update: {
          user_id?: string
        }
      }
      messages: {
        Row: {
          id: string
          conversation_id: string
          content: string
          role: 'user' | 'assistant'
          created_at: string
        }
        Insert: {
          conversation_id: string
          content: string
          role: 'user' | 'assistant'
        }
        Update: {
          content?: string
          role?: 'user' | 'assistant'
        }
      }
    }
  }
}