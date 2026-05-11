-- =============================================================================
-- Migration 004 – Soft Delete Support
-- Run in Supabase SQL editor AFTER 003_admin_trial.sql
-- =============================================================================

ALTER TABLE children
    ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;

-- Index for admin queries filtering on deleted accounts
CREATE INDEX IF NOT EXISTS idx_children_deleted_at ON children (deleted_at)
    WHERE deleted_at IS NOT NULL;

-- To reactivate a soft-deleted user from admin panel:
-- UPDATE children SET is_active = true, deleted_at = NULL WHERE email = 'user@example.com';
