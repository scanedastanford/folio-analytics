DROP TABLE IF EXISTS course_processingstatuses;

CREATE TABLE course_processingstatuses AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_processingstates;

ALTER TABLE course_processingstatuses ADD PRIMARY KEY (id);

CREATE INDEX ON course_processingstatuses (description);

CREATE INDEX ON course_processingstatuses (name);

VACUUM ANALYZE course_processingstatuses;
