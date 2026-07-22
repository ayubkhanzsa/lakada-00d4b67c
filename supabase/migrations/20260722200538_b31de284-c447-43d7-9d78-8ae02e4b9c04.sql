
-- Enable pg_cron for scheduled cleanup
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Remove any previous version of this job
DO $$
BEGIN
  PERFORM cron.unschedule('purge-stale-pending-orders');
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- Every 5 minutes, permanently delete pending/failed card orders older than 30 minutes
SELECT cron.schedule(
  'purge-stale-pending-orders',
  '*/5 * * * *',
  $$
    DELETE FROM public.orders
    WHERE status IN ('pending', 'failed')
      AND created_at < now() - interval '30 minutes'
      AND (
        payment_method ILIKE '%xpay%'
        OR payment_method ILIKE '%card%'
        OR payment_method IS NULL
      );
  $$
);
