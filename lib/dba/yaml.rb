# frozen_string_literal: true
require 'yaml'

module DBA::YAML
  def self.dump(database, table_name, path)
    File.open(path, 'w+') do |io|
      io.write ::YAML.dump(database[table_name].all.map(&:compact))
    end
  end

  def self.load(path, database, table_name)
    dataset = database[table_name]

    database.transaction do
      ::YAML.load_file(path).each do |row|
        dataset.insert(row)
      end
    end
  end
end
