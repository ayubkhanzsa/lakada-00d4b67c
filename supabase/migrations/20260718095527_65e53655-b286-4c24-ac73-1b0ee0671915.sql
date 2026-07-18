ALTER TABLE public.chat_history ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT now();
ALTER TABLE public.inquiry_email_log ALTER COLUMN email_to DROP NOT NULL;