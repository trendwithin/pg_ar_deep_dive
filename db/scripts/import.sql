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
