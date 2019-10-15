# frozen_string_literal: true

require 'bigdecimal'
require 'time'

class DBA::RowParser
  def initialize(table_schema)
    @table_schema = table_schema
  end

  def parse(string)
    string.strip.split("\n").each_with_object({}) do |line, hash|
      key, value = line.split(/:\s*/, 2)

      column_name = key.to_sym

      hash[column_name] = value_parse(column_name, value)
    end
  end

  private

  PARSERS = {
    :integer => method(:Integer),
    :date => Date.method(:parse),
    :datetime => Time.method(:parse),
    :decimal => method(:BigDecimal)
  }

  def value_parse(column_name, value)
    if value == 'NULL'
      nil
    elsif parser = PARSERS[@table_schema.column_type(column_name)]
      parser.call(value)
    else
      value
    end
  end
end
