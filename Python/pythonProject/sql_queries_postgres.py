"""List of all queries for Postgres"""

sql_tables = """
    select coalesce(table_type || '_' || table_schema || '.' || table_name, 'n/a') "object_info"
    from information_schema.tables
    order by 1;
    """
sql_tables_count = """
    select count(table_name) 
    from information_schema.tables;"""

sql_functions = """
    --functions
    select routine_type || '_' || routine_schema || '.' || routine_name
    from information_schema.routines 
    where routine_schema = 'public'
    and routine_type = 'FUNCTION'
    order by 1;
    """
sql_functions_count = """
    select count(specific_name) 
    from information_schema.routines 
    where routine_schema = 'public'
    and routine_type = 'FUNCTION'
    """

sql_procedures = """
    --functions
    select routine_type || '_' || routine_schema || '.' || routine_name
    from information_schema.routines 
    where routine_schema = 'public'
    and routine_type = 'PROCEDURE'
    order by 1;
    """
sql_procedures_count = """
    select count(specific_name) 
    from information_schema.routines 
    where routine_schema = 'public'
    and routine_type = 'PROCEDURE'
    """

sql_db_triggers = """
select 'DB_TRIGGER_' || evtname from pg_catalog.pg_event_trigger;
"""
sql_db_triggers_count = """
select count(evtname) from pg_catalog.pg_event_trigger;
"""

sql_table_triggers = """
    select 'TABLE_TRIGGER_' || trigger_schema || '.' || event_object_table 
    || '.' || trigger_name || '.' || event_manipulation || '.' || action_statement 
    from information_schema.triggers;
"""
sql_table_triggers_count = """
    select count(trigger_name) from information_schema.triggers;
"""

sql_types = """
    select
    'TYPECATEGORY_' || typname || '.' ||
        CASE
            WHEN typcategory = 'E' THEN 'Enum'
            WHEN typcategory = 'X' THEN 'Unknown'
            WHEN typcategory = 'G' THEN 'Geometric'
            WHEN typcategory = 'D' THEN 'Date/Time'
            WHEN typcategory = 'R' THEN 'Range'
            WHEN typcategory = 'B' THEN 'Boolean'
            WHEN typcategory = 'P' THEN 'Pseudo'
            WHEN typcategory = 'C' THEN 'Composite'
            WHEN typcategory = 'S' THEN 'String'
            WHEN typcategory = 'Z' THEN 'Bit'
            WHEN typcategory = 'A' THEN 'Array'
            WHEN typcategory = 'V' THEN 'Numeric'
            WHEN typcategory = 'T' THEN 'Timespan'
            WHEN typcategory = 'U' THEN 'User-Defined'
            WHEN typcategory = 'I' THEN 'Network Address'
            WHEN typcategory = 'N' THEN 'Bit N'
        ELSE 'Unknown Category'
      END "type_info"
     from pg_type
"""

sql_types_count = """
    select count(typname) from pg_type
"""

sql_indexes_pk = """
    select 'INDEX_' || schemaname || '.' || tablename || '.' || indexname 
    from pg_catalog.pg_indexes
    where indexname like '%_pkey'
"""

sql_indexes_pk_count = """
    select count(indexname) 
    from pg_catalog.pg_indexes
    where indexname like '%_pkey'
"""

sql_indexes = """
    select 'INDEX_' || schemaname || '.' || tablename || '.' || indexname 
    from pg_catalog.pg_indexes
    where indexname not like '%_pkey'
"""

sql_indexes_count = """
    select count(indexname) 
    from pg_catalog.pg_indexes
    where indexname not like '%_pkey'
"""

sql_sequences = """
    select 'SEQUENCE_' || schemaname || '.' || sequencename || '.' 
    from pg_catalog.pg_sequences
"""

sql_sequences_count = """
    select count(sequencename) from pg_catalog.pg_sequences
"""

sql_tablespaces = """
    select 'TABLE_SPACE_' || spcname from pg_tablespace
"""

sql_tablespaces_count = """
    select count(spcname) from pg_tablespace
"""

sql_roles = """
    select 'ROLE_' || rolname from pg_catalog.pg_roles
"""

sql_roles_count = """
    select count(rolname) from pg_catalog.pg_roles
"""

sql_constraints = """
    select 'CONSTRAINT_' || n.nspname || '.' || c.relname || '.' || con.conname "constraint_info"
    from pg_constraint con
    join pg_class c on con.conrelid = c.oid
    join pg_namespace n on c.relnamespace = n.oid
"""

sql_constraints_count = """
    select count(c.relname)
    from pg_constraint con
    join pg_class c on con.conrelid = c.oid
    join pg_namespace n on c.relnamespace = n.oid
"""

sql_columns = """
    select
        'COLUMN_TYPE_' || table_schema || '.' || table_name || '.' || column_name || '.' || 
        data_type || '.NULLable:' || is_nullable
    from
        information_schema."columns"
"""

sql_columns_count = """
    select count(column_name) from information_schema."columns"
"""

sql_schemas = """
    select schema_name from information_schema.schemata
"""

sql_schemas_count = """
    select count(schema_name) from information_schema.schemata
"""
