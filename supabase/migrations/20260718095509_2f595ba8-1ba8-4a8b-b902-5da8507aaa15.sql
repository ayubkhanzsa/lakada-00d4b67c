ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS product_code TEXT,
  ADD COLUMN IF NOT EXISTS exchange_rate NUMERIC,
  ADD COLUMN IF NOT EXISTS pkr_amount NUMERIC;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS phone TEXT;
ALTER TABLE public.pubg_accounts ADD COLUMN IF NOT EXISTS discount NUMERIC;
ALTER TABLE public.inquiry_email_log ADD COLUMN IF NOT EXISTS sent_by UUID;
ALTER TABLE public.uc_packages ALTER COLUMN amount DROP NOT NULL;

DROP FUNCTION IF EXISTS public.log_admin_action(uuid, text, text, text, jsonb);
CREATE OR REPLACE FUNCTION public.log_admin_action(
  p_admin_id UUID,
  p_action_type TEXT,
  p_target_type TEXT DEFAULT NULL,
  p_target_id TEXT DEFAULT NULL,
  p_details JSONB DEFAULT NULL
) RETURNS void LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.admin_logs (admin_id, action, target_type, target_id, details)
  VALUES (p_admin_id, p_action_type, p_target_type, p_target_id, p_details);
END; $$;

CREATE OR REPLACE FUNCTION public.list_users_with_admin_status()
RETURNS TABLE(user_id uuid, email text, is_admin boolean)
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT p.user_id, p.email, EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = p.user_id AND ur.role = 'admin')
  FROM public.profiles p ORDER BY p.created_at DESC;
$$;