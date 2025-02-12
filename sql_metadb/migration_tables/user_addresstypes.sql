DROP TABLE IF EXISTS user_addresstypes;

CREATE TABLE user_addresstypes AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'addressType')::varchar(65535) AS address_type,
    jsonb_extract_path_text(jsonb, 'desc')::varchar(65535) AS desc,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_users.addresstype;

ALTER TABLE user_addresstypes ADD PRIMARY KEY (id);

CREATE INDEX ON user_addresstypes (address_type);

CREATE INDEX ON user_addresstypes ("desc");

VACUUM ANALYZE user_addresstypes;
