DROP TABLE IF EXISTS circulation_request_policies;

CREATE TABLE circulation_request_policies AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.request_policy;

ALTER TABLE circulation_request_policies ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_patron_notice_policies (description);

CREATE INDEX ON circulation_patron_notice_policies (name);

VACUUM ANALYZE circulation_request_policies;
