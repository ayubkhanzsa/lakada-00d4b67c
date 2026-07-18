-- uc_packages
ALTER TABLE public.uc_packages ADD COLUMN IF NOT EXISTS uc_amount INTEGER;

-- customer_inquiries
ALTER TABLE public.customer_inquiries ADD COLUMN IF NOT EXISTS is_read BOOLEAN NOT NULL DEFAULT false;

-- customer_inquiries_archive extras
ALTER TABLE public.customer_inquiries_archive
  ADD COLUMN IF NOT EXISTS original_id UUID,
  ADD COLUMN IF NOT EXISTS original_created_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS original_updated_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT now(),
  ADD COLUMN IF NOT EXISTS archived_by UUID,
  ADD COLUMN IF NOT EXISTS is_read BOOLEAN DEFAULT false;

-- site_banners extras
ALTER TABLE public.site_banners
  ADD COLUMN IF NOT EXISTS zoom_level INTEGER DEFAULT 100,
  ADD COLUMN IF NOT EXISTS light_intensity INTEGER DEFAULT 45,
  ADD COLUMN IF NOT EXISTS light_color TEXT DEFAULT '#003C78',
  ADD COLUMN IF NOT EXISTS light_spread INTEGER DEFAULT 70,
  ADD COLUMN IF NOT EXISTS light_enabled BOOLEAN DEFAULT true;

-- orders_archive extras
ALTER TABLE public.orders_archive
  ADD COLUMN IF NOT EXISTS original_id UUID,
  ADD COLUMN IF NOT EXISTS currency_code TEXT,
  ADD COLUMN IF NOT EXISTS product_type TEXT,
  ADD COLUMN IF NOT EXISTS product_name TEXT,
  ADD COLUMN IF NOT EXISTS product_amount TEXT,
  ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ DEFAULT now(),
  ADD COLUMN IF NOT EXISTS archived_by UUID,
  ADD COLUMN IF NOT EXISTS original_created_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS original_updated_at TIMESTAMPTZ;

-- inquiry_email_log
ALTER TABLE public.inquiry_email_log ADD COLUMN IF NOT EXISTS customer_email TEXT;

-- chat_history messages jsonb (session grouped)
ALTER TABLE public.chat_history
  ADD COLUMN IF NOT EXISTS messages JSONB DEFAULT '[]'::jsonb,
  ALTER COLUMN role DROP NOT NULL,
  ALTER COLUMN content DROP NOT NULL;