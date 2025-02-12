DROP TABLE IF EXISTS inventory_instance_types;

CREATE TABLE inventory_instance_types AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.instance_type;

ALTER TABLE inventory_instance_types ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_instance_types (code);

CREATE INDEX ON inventory_instance_types (name);

CREATE INDEX ON inventory_instance_types (source);

VACUUM ANALYZE inventory_instance_types;
