----------------------------------------------------------------------------------------------------
/* FTS */
----------------------------------------------------------------------------------------------------
-- data type for document optimized for search
SELECT to_tsvector('english', 'A fat cat sat on a mat and ate a fat rat the bible strange melee');
-- Results in: 'ate':9 'cat':3 'fat':2,11 'mat':7 'rat':12 'sat':4

-- textual data type for query with boolean ops &|!()
select to_tsquery('english', 'cats & dogs'); 
-- 'cat' & 'dog'

-- FTS operator: tsvector @@ tsquery


-- =========================
-- 0) Setup (do this once)
-- =========================
-- Create a dedicated schema for experiments (optional).
CREATE SCHEMA IF NOT EXISTS fts_demo;

-- We'll work inside it.
SET search_path = fts_demo, public;

-- ===========================================
-- 1) Table with text you'd like to search in
-- ===========================================
-- "docs" mimics blog posts, product pages, etc.
CREATE TABLE IF NOT EXISTS docs (
  doc_id      SERIAL PRIMARY KEY,         -- unique id
  title       TEXT,                       -- searchable title
  body        TEXT,                       -- searchable content
  lang        REGCONFIG DEFAULT 'english',-- per-row config (optional)
  sv          TSVECTOR                    -- materialized search vector
);

-- Sample data (purposely varied wording to show stemming & stopwords):
INSERT INTO docs (title, body) VALUES
('Comedy Adventure', 'A funny adventurous tale about a cat who runs across town.'),
('Adventurer''s Guide', 'How to run, running fast, and adventure safely.'),
('Cats & Dogs', 'Cats are running around; dogs ran away; runners unite!'),
('Database Basics', 'PostgreSQL full text search with GIN index and ranking.'),
('Cooking with Mushrooms', 'Learn to sauté mushrooms; adventurous flavors await.');

-- ===========================================
-- 2) Build a TSVECTOR (weighted) and inspect
-- ===========================================
-- Compute an initial search vector that prefers title over body.
-- setweight labels: 'A' (highest) .. 'D' (lowest).
UPDATE docs
SET sv =
  setweight( to_tsvector(lang, coalesce(title,'')), 'A') ||
  setweight( to_tsvector(lang, coalesce(body ,'')), 'B');

-- Peek at how text became lexemes (stemming, stopwords removed)
SELECT doc_id, title, sv FROM docs ORDER BY doc_id;

-- Try the raw function to feel it:
SELECT to_tsvector('english', 'A fat cat sat on a mat and ate a fat rat');
-- (shows normalized lexemes with positions; see docs).  -- :contentReference[oaicite:2]{index=2}

-- ===========================================
-- 3) Indexing: GIN (read-optimized) and GiST
-- ===========================================
-- Create a GIN index: great for search-heavy workloads.  -- :contentReference[oaicite:3]{index=3}
CREATE INDEX IF NOT EXISTS idx_docs_sv_gin  ON docs USING gin(sv);

-- (Optional) A GiST index too, to compare behavior on updates vs reads. -- :contentReference[oaicite:4]{index=4}
CREATE INDEX IF NOT EXISTS idx_docs_sv_gist ON docs USING gist(sv);

-- ===========================================
-- 4) Querying with tsquery + the @@ operator
-- ===========================================
-- Exact boolean syntax: AND (&), OR (|), NOT (!)
-- Example: must contain BOTH “comedy” AND “adventure”
SELECT doc_id, title
FROM   docs
WHERE  sv @@ to_tsquery('english', 'comedy & adventure');  -- :contentReference[oaicite:5]{index=5}

-- "Plain text" parsing: splits text into required terms (ANDed)
SELECT doc_id, title
FROM   docs
WHERE  sv @@ plainto_tsquery('english', 'running cats');   -- :contentReference[oaicite:6]{index=6}

-- Web-style search syntax: supports quotes, -, OR, etc., never errors on raw input.
-- e.g. words OR phrase, exclude a word:
SELECT doc_id, title
FROM   docs
WHERE  sv @@ websearch_to_tsquery('english', '"full text" OR ranking -mushrooms');  -- :contentReference[oaicite:7]{index=7}

-- ===========================================
-- 5) Ranking results (relevance scoring)
-- ===========================================
-- Use ts_rank / ts_rank_cd to order by relevance:
WITH q AS (
  SELECT websearch_to_tsquery('english', 'adventure OR running') AS tsq   -- :contentReference[oaicite:8]{index=8}
)
SELECT d.doc_id, d.title,
       ts_rank(d.sv, q.tsq) AS rank
FROM   docs d, q
WHERE  d.sv @@ q.tsq
ORDER  BY rank DESC, d.doc_id;

-- ===========================================
-- 6) Highlighting matches for UX snippets
-- ===========================================
-- ts_headline builds snippets with <b> or other markers:
WITH q AS (
  SELECT plainto_tsquery('english','adventure running') AS tsq             -- :contentReference[oaicite:9]{index=9}
)
SELECT doc_id,
       title,
       ts_headline('english', body, q.tsq, 'StartSel=<mark>,StopSel=</mark>,MaxFragments=2,MinWords=5,MaxWords=12') AS snippet
FROM   docs, q
WHERE  sv @@ q.tsq
ORDER  BY ts_rank(sv, q.tsq) DESC;
-- (Heads-up: ts_headline can add noticeable cost in big result sets.)  -- :contentReference[oaicite:10]{index=10}

-- ===========================================
-- 7) Keep sv fresh automatically (trigger)
-- ===========================================
-- This trigger updates "sv" whenever title/body change using given config.
-- The configuration name must be schema-qualified, per docs.               -- :contentReference[oaicite:11]{index=11}
DROP TRIGGER IF EXISTS docs_tsv_update ON docs;
CREATE TRIGGER docs_tsv_update
BEFORE INSERT OR UPDATE ON docs
FOR EACH ROW EXECUTE FUNCTION
  tsvector_update_trigger(
    'sv',                    -- tsvector column to maintain
    'pg_catalog.english',    -- text search config (schema-qualified)
    'title', 'body'          -- source text columns
  );                                                                -- :contentReference[oaicite:12]{index=12}

-- Test that the trigger works:
UPDATE docs SET body = body || ' Indexes like GIN help search.' WHERE doc_id = 1;
SELECT doc_id, sv FROM docs WHERE doc_id = 1;

-- ===========================================
-- 8) Prefix searching (careful!)
-- ===========================================
-- You can do prefix queries with :*
SELECT doc_id, title
FROM   docs
WHERE  sv @@ to_tsquery('english', 'run:* & adventur:*');              -- :contentReference[oaicite:13]{index=13}

-- ===========================================
-- 9) Compare GIN vs GiST (quick feel)
-- ===========================================
-- Run the same query twice (once "cold", once "warm") after ANALYZE.
ANALYZE docs;

EXPLAIN ANALYZE
SELECT doc_id FROM docs
WHERE sv @@ websearch_to_tsquery('english','running OR adventure');    -- uses index; compare plans.  -- :contentReference[oaicite:14]{index=14}

-- ===========================================
-- 10) Maintenance & cleanup tips
-- ===========================================
-- If bulk-loading lots of rows, you can:
--   1) drop indexes/triggers, 2) load, 3) recompute sv, 4) recreate indexes.
-- Consider VACUUM/REINDEX as with any heavy-write table.

-- Optional cleanup:
-- DROP INDEX IF EXISTS idx_docs_sv_gist;
-- DROP INDEX IF EXISTS idx_docs_sv_gin;
-- DROP TABLE IF EXISTS docs;
-- DROP SCHEMA IF EXISTS fts_demo CASCADE;
