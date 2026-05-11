-- =============================================================================
-- Migration 003 – Admin Role, Account Status, Trial Management
-- Run in Supabase SQL editor AFTER 002_auth_writing.sql
-- =============================================================================

ALTER TABLE children
    ADD COLUMN IF NOT EXISTS is_active        BOOLEAN     NOT NULL DEFAULT TRUE,
    ADD COLUMN IF NOT EXISTS role             VARCHAR(20) NOT NULL DEFAULT 'student',
    ADD COLUMN IF NOT EXISTS account_type     VARCHAR(20) NOT NULL DEFAULT 'trial',
    ADD COLUMN IF NOT EXISTS trial_expires_at TIMESTAMPTZ;

-- role: 'student' | 'admin'
-- account_type: 'trial' | 'standard'
-- trial_expires_at: NULL means no expiry (standard accounts or manually removed)

CREATE INDEX IF NOT EXISTS idx_children_role    ON children (role);
CREATE INDEX IF NOT EXISTS idx_children_active  ON children (is_active);

-- To promote a user to admin, run:
-- UPDATE children SET role = 'admin' WHERE email = 'your@email.com';
