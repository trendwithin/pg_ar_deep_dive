DROP TABLE IF EXISTS imported_data_master;

CREATE TABLE imported_data_master (
  market_close_date date,
  company_name text,
  symbol text,
  open text,
  high text,
  low text,
  close text,
  volume text,
  net_change text,
  industry text
);
COPY imported_data_master FROM '/Users/Strawman/2018-Dev/proper-projects/pg_ar_deep_dive/db/make_files/../seed_data/import_data.csv' WITH DELIMITER ',' HEADER CSV;
DROP TABLE IF EXISTS stocks cascade;
DROP TABLE IF EXISTS sectors cascade;
DROP TABLE IF EXISTS industries cascade;
DROP TABLE IF EXISTS historic_prices cascade;

SELECT DISTINCT symbol, company_name
INTO stocks
FROM imported_data_master;


ALTER TABLE stocks
add id serial primary key,
add sector_id int,
add industry_id int,
add created_at timestamp without time zone DEFAULT NOW(),
add updated_at timestamp without time zone DEFAULT NOW();

SELECT DISTINCT split_part(industry, '-', 1) AS name
INTO sectors
FROM imported_data_master;

ALTER TABLE sectors
add id serial primary key,
add created_at timestamp without time zone DEFAULT NOW(),
add updated_at timestamp without time zone DEFAULT NOW();

SELECT DISTINCT split_part(industry, '-', 2) AS name
INTO industries
FROM imported_data_master;

ALTER TABLE industries
add id serial primary key,
add created_at timestamp without time zone DEFAULT NOW(),
add updated_at timestamp without time zone DEFAULT NOW();


CREATE TABLE historic_prices(
  id serial primary key,
  market_close_date date,
  open decimal,
  high decimal,
  low decimal,
  close decimal,
  volume int,
  net_change decimal,
  created_at timestamp without time zone DEFAULT NOW(),
  updated_at timestamp without time zone DEFAULT NOW(),
  stock_id int
);
INSERT INTO historic_prices (
  market_close_date,
  open,
  high,
  low,
  close,
  volume,
  net_change,
  stock_id
)
SELECT
  market_close_date,
  open::decimal,
  high::decimal,
  low::decimal,
  close::decimal,
  volume::int,
  net_change::decimal,
  stocks.id as stock_id
FROM imported_data_master
INNER JOIN stocks
on stocks.symbol = imported_data_master.symbol
;
INSERT INTO stocks (
  sector_id,
  industry_id
)

-- split_part(sector, '-', 2) as sector_name,
-- sectors.name,
-- split_part(industry, '-', 1) as industry_name,
SELECT
-- DISTINCT symbol,
sectors.id as sector_id,
industries.id as industry_id
FROM
imported_data_master
INNER JOIN sectors
on sectors.name = split_part(industry, '-', 1)
INNER JOIN industries
on industries.name = split_part(industry, '-', 2)
;


-- SELECT
--   distinct symbol,
--   split_part(industry, '-', 1) as name,
--   sectors.name,
--   sectors.id as sector_id
-- FROM
--   imported_data_master
--   left join sectors
--   on sectors.name
--   = name;
