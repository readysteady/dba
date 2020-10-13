# frozen_string_literal: true
require 'csv'

module DBA::CSV
  def self.dump(database, table_name, path)
    columns = nil

    ::CSV.open(path, 'wb') do |csv|
      database[table_name].each_with_index do |row, index|
        if index.zero?
          columns = row.keys

          csv << columns
        end

        csv << row.values_at(*columns)
      end
    end
  end
end
