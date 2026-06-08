-- Migration 012: Create credit and payment tables

CREATE TABLE credit_packages (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  credits    INT NOT NULL,
  is_active  BOOLEAN NOT NULL DEFAULT true,
  sort_order SMALLINT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_packages_active ON credit_packages(is_active) WHERE is_active = true;

-- Price per package per country
CREATE TABLE credit_package_prices (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  package_id    UUID NOT NULL REFERENCES credit_packages(id) ON DELETE CASCADE,
  country_id    UUID NOT NULL REFERENCES countries(id),
  price         NUMERIC(10,2) NOT NULL,
  currency_code VARCHAR(3) NOT NULL,
  UNIQUE(package_id, country_id)
);

-- Immutable credit ledger
CREATE TABLE credit_transactions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id      UUID NOT NULL REFERENCES workers(id) ON DELETE CASCADE,
  type           credit_txn_type NOT NULL,
  amount         INT NOT NULL,
  balance_after  INT NOT NULL,
  reference_id   UUID,
  reference_type VARCHAR(50),
  description    TEXT,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_credit_txn_worker ON credit_transactions(worker_id, created_at DESC);
CREATE INDEX idx_credit_txn_type ON credit_transactions(type, created_at DESC);

-- Stripe payments
CREATE TABLE payments (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id                UUID NOT NULL REFERENCES workers(id),
  package_id               UUID NOT NULL REFERENCES credit_packages(id),
  stripe_payment_intent_id VARCHAR(255) UNIQUE,
  stripe_session_id        VARCHAR(255),
  amount                   NUMERIC(10,2) NOT NULL,
  currency_code            VARCHAR(3) NOT NULL,
  credits_purchased        INT NOT NULL,
  status                   payment_status NOT NULL DEFAULT 'pending',
  webhook_received_at      TIMESTAMPTZ,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_worker ON payments(worker_id, created_at DESC);
CREATE INDEX idx_payments_stripe ON payments(stripe_payment_intent_id);
CREATE INDEX idx_payments_status ON payments(status);
