DROP TABLE IF EXISTS folio_derived.finance_transaction_invoices;

-- Create a derived table that joins invoice and invoice_lines fields to transactions for expenditure reports in system currency
--
-- NOTE: effective_fund_id, effective_fund_name, effective_fund_code were derived from the set from_fund or to_fund as a convenient 
-- 		 way to get the effective fund
--
-- Tables included:
--   folio_finance.transaction
--   folio_invoice.invoices
--   folio_invoice.invoice_lines
--   folio_finance.fund
--   folio_finance.budget
CREATE TABLE folio_derived.finance_transaction_invoices AS
SELECT
    ft.id AS transaction_id,
    jsonb_extract_path_text(ft.jsonb, 'amount') AS transaction_amount,
    jsonb_extract_path_text(ft.jsonb, 'currency') AS transaction_currency,
    jsonb_extract_path_text(ft.jsonb, 'metadata', 'createdDate')::DATE AS transaction_created_date,
    jsonb_extract_path_text(ft.jsonb, 'metadata', 'updatedDate')::DATE AS transaction_updated_date,
	jsonb_extract_path_text(ft.jsonb, 'description') AS transaction_description,
    ft.expenseclassid AS transaction_expense_class_id,
    ft.fiscalyearid AS transaction_fiscal_year_id,
    ft.fromfundid AS transaction_from_fund_id,
    jsonb_extract_path_text(ff.jsonb, 'name') AS transaction_from_fund_name,
    jsonb_extract_path_text(ff.jsonb, 'code') AS transaction_from_fund_code,
    ft.tofundid AS transaction_to_fund_id,
    jsonb_extract_path_text(tf.jsonb, 'name') AS transaction_to_fund_name,
    jsonb_extract_path_text(tf.jsonb, 'code') AS transaction_to_fund_code,
    CASE WHEN ft.tofundid IS NULL THEN ft.fromfundid ELSE ft.tofundid END AS effective_fund_id,
    CASE WHEN jsonb_extract_path_text(ff.jsonb, 'name') IS NULL THEN jsonb_extract_path_text(tf.jsonb, 'name') ELSE jsonb_extract_path_text(ff.jsonb, 'name') END AS effective_fund_name,
    CASE WHEN jsonb_extract_path_text(ff.jsonb, 'code') IS NULL THEN jsonb_extract_path_text(tf.jsonb, 'code') ELSE jsonb_extract_path_text(ff.jsonb, 'code') END AS effective_fund_code,
    fb.id AS transaction_from_budget_id,
    jsonb_extract_path_text(fb.jsonb, 'name') AS transaction_from_budget_name,
    jsonb_extract_path_text(ft.jsonb, 'sourceInvoiceId') AS invoice_id,
    jsonb_extract_path_text(ft.jsonb, 'sourceInvoiceLineId') AS invoice_line_id,
    jsonb_extract_path_text(ft.jsonb, 'transactionType') AS transaction_type,
    jsonb_extract_path_text(ii.jsonb, 'invoiceDate') AS invoice_date,
    jsonb_extract_path_text(ii.jsonb, 'paymentDate') AS invoice_payment_date,
    jsonb_extract_path_text(ii.jsonb, 'exchangeRate') AS invoice_exchange_rate,
    jsonb_extract_path_text(il.jsonb, 'total') AS invoice_line_total,
    jsonb_extract_path_text(ii.jsonb, 'currency') AS invoice_currency,
    jsonb_extract_path_text(il.jsonb, 'poLineId') AS po_line_id,
    jsonb_extract_path_text(ii.jsonb, 'vendorId') AS invoice_vendor_id,
    jsonb_extract_path_text(oo.jsonb, 'name') AS invoice_vendor_name
FROM
    folio_finance.transaction AS ft
    LEFT JOIN folio_invoice.invoices AS ii ON jsonb_extract_path_text(ft.jsonb, 'sourceInvoiceId') = ii.id
    LEFT JOIN folio_invoice.invoice_lines AS il ON jsonb_extract_path_text(ft.jsonb, 'sourceInvoiceLineId') = il.id
    LEFT JOIN folio_finance.fund AS ff ON ft.fromfundid = ff.id
    LEFT JOIN folio_finance.fund AS tf ON ft.tofundid = tf.id
    LEFT JOIN folio_finance.budget AS fb ON ft.fromfundid = fb.fundid AND ft.fiscalyearid = fb.fiscalyearid
    LEFT JOIN folio_organizations. organizations AS oo ON jsonb_extract_path_text(ii.jsonb, 'vendorId') = oo.id
WHERE (jsonb_extract_path_text(ft.jsonb, 'transactionType') = 'Pending payment'
    OR jsonb_extract_path_text(ft.jsonb, 'transactionType') = 'Payment'
    OR jsonb_extract_path_text(ft.jsonb, 'transactionType') = 'Credit');

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_amount);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_currency);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_created_date);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_updated_date);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_description);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_expense_class_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_fiscal_year_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_fund_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_fund_name);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_fund_code);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_to_fund_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_to_fund_name);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_to_fund_code);

CREATE INDEX ON folio_derived.finance_transaction_invoices (effective_fund_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (effective_fund_name);

CREATE INDEX ON folio_derived.finance_transaction_invoices (effective_fund_code);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_budget_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_from_budget_name);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_line_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (transaction_type);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_date);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_payment_date);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_exchange_rate);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_line_total);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_currency);

CREATE INDEX ON folio_derived.finance_transaction_invoices (po_line_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_vendor_id);

CREATE INDEX ON folio_derived.finance_transaction_invoices (invoice_vendor_name);
