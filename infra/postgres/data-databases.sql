CREATE DATABASE flags_db;
CREATE DATABASE targeting_db;
\connect flags_db
\i /opt/sql/flags.sql
\connect targeting_db
\i /opt/sql/targeting.sql
