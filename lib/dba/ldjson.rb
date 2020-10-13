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

  def self.load(path, database, table_name)
    dataset = database[table_name]

    database.transaction do
      File.readlines(path).each do |line|
        dataset.insert(::JSON.parse(line))
      end
    end
  end
end
