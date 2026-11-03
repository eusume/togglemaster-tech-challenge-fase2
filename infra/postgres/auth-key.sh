#!/bin/sh
set -eu
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set=service_key="$SERVICE_API_KEY" <<'SQL'
INSERT INTO api_keys (name, key_hash)
VALUES ('evaluation-service-local', encode(sha256(convert_to(:'service_key', 'UTF8')), 'hex'))
ON CONFLICT (key_hash) DO NOTHING;
SQL
