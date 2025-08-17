-- V1__init_schema.sql
-- InvoFlow Database Initialization Script

-- Create schemas
CREATE SCHEMA IF NOT EXISTS app;

-- Create tables
-- Users table
CREATE TABLE app.users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(50) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Companies table (for both user companies and clients)
CREATE TABLE app.companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    tax_id VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(255),
    logo_url TEXT,
    is_client BOOLEAN DEFAULT FALSE,
    owner_id INTEGER REFERENCES app.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Payment methods reference table
CREATE TABLE app.payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Invoice status reference table
CREATE TABLE app.invoice_statuses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Invoices table
CREATE TABLE app.invoices (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    company_id INTEGER NOT NULL REFERENCES app.companies(id),
    client_id INTEGER NOT NULL REFERENCES app.companies(id),
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status_id INTEGER NOT NULL REFERENCES app.invoice_statuses(id),
    subtotal DECIMAL(12,2) NOT NULL,
    tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL,
    notes TEXT,
    terms TEXT,
    created_by INTEGER NOT NULL REFERENCES app.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Invoice items table
CREATE TABLE app.invoice_items (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES app.invoices(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    quantity DECIMAL(12,3) NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    tax_rate DECIMAL(5,2) DEFAULT 0,
    line_total DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Payments table
CREATE TABLE app.payments (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES app.invoices(id),
    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method_id INTEGER REFERENCES app.payment_methods(id),
    reference_number VARCHAR(100),
    notes TEXT,
    created_by INTEGER NOT NULL REFERENCES app.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert seed data
-- Populate reference tables
INSERT INTO app.invoice_statuses (name, description) VALUES
    ('DRAFT', 'Invoice has been created but not sent'),
    ('SENT', 'Invoice has been sent to the client'),
    ('VIEWED', 'Client has viewed the invoice'),
    ('PARTIAL', 'Invoice has been partially paid'),
    ('PAID', 'Invoice has been paid in full'),
    ('OVERDUE', 'Payment is past due date'),
    ('CANCELLED', 'Invoice has been cancelled');

INSERT INTO app.payment_methods (name, description) VALUES
    ('Bank Transfer', 'Payment made via bank transfer'),
    ('Credit Card', 'Payment made via credit card'),
    ('PayPal', 'Payment made via PayPal'),
    ('Cash', 'Payment made in cash'),
    ('Check', 'Payment made by check');

-- Create a default admin user (password: admin123)
INSERT INTO app.users (email, password_hash, first_name, last_name, role)
VALUES ('admin@invoflow.dev', '$2a$10$xVfzKHQ8G4UPVXBKYgGHU.DlXl.3UuiIePGS8/ySGR5VXtbTOcmZ6', 'Admin', 'User', 'ADMIN');

-- Create indexes
CREATE INDEX idx_invoices_company_id ON app.invoices(company_id);
CREATE INDEX idx_invoices_client_id ON app.invoices(client_id);
CREATE INDEX idx_invoices_status_id ON app.invoices(status_id);
CREATE INDEX idx_invoice_items_invoice_id ON app.invoice_items(invoice_id);
CREATE INDEX idx_payments_invoice_id ON app.payments(invoice_id);
CREATE INDEX idx_companies_owner_id ON app.companies(owner_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to all tables with updated_at
CREATE TRIGGER update_users_modtime
BEFORE UPDATE ON app.users
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_companies_modtime
BEFORE UPDATE ON app.companies
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_invoices_modtime
BEFORE UPDATE ON app.invoices
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_invoice_items_modtime
BEFORE UPDATE ON app.invoice_items
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_payments_modtime
BEFORE UPDATE ON app.payments
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA app TO invoflow;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app TO invoflow;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA app TO invoflow;
