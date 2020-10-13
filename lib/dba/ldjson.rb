# frozen_string_literal: true
require 'json'

module DBA::LDJSON
  def self.dump(database, table_name, path)
    File.open(path, 'w+') do |io|
      database[table_name].each do |row|
        io.puts ::JSON.generate(row.compact)
      end
    end
  end
end
