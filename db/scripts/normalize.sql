DROP TABLE IF EXISTS stocks cascade;
DROP TABLE IF EXISTS sectors cascade;
DROP TABLE IF EXISTS industries cascade;
DROP TABLE IF EXISTS historic_prices cascade;

-- SELECT DISTINCT symbol, company_name
-- INTO stocks
-- FROM imported_data_master;


-- ALTER TABLE stocks
-- add id serial primary key,
-- add sector_id int,
-- add industry_id int,
-- add created_at timestamp without time zone DEFAULT NOW(),
-- add updated_at timestamp without time zone DEFAULT NOW();

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

CREATE TABLE stocks(
  id serial primary key,
  symbol text,
  company_name text,
  sector_id int,
  industry_id int,
  created_at timestamp without time zone DEFAULT NOW(),
  updated_at timestamp without time zone DEFAULT NOW()
);

INSERT INTO stocks (
  symbol,
  company_name,
  sector_id,
  industry_id
)

SELECT
DISTINCT symbol,
company_name,
sectors.id as sector_id,
industries.id as industry_id
FROM
imported_data_master
INNER JOIN sectors
on sectors.name = split_part(industry, '-', 1)
INNER JOIN industries
on industries.name = split_part(industry, '-', 2)
;


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
