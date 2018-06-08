class Stock < ApplicationRecord
  def self.list_all_records_find_by_sql
    sql = <<-SQL
      SELECT * FROM stocks;
    SQL

    find_by_sql(sql)
  end

  def self.list_all_records_by_exec_query
    sql = <<-SQL
      SELECT * FROM stocks;
    SQL

    ActiveRecord::Base.connection.exec_query(sql)
  end

  def self.list_all_records_by_connection_execute
    sql = <<-SQL
      SELECT * FROM stocks;
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end

  def self.join_historic_price_find_by_sql
    sql = <<-SQL
      SELECT symbol, market_close_date, close, volume
      FROM stocks
      INNER JOIN historic_prices
      ON stocks.id = stock_id
    SQL
    find_by_sql(sql)
  end

  def self.join_historic_price_exec_query
    sql = <<-SQL
      SELECT symbol, market_close_date, close, volume
      FROM stocks
      INNER JOIN historic_prices
      ON stocks.id = stock_id
    SQL
    ActiveRecord::Base.connection.exec_query(sql)
  end
end
