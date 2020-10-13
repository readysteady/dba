# frozen_string_literal: true
require 'yaml'

module DBA::YAML
  def self.dump(database, table_name, path)
    File.open(path, 'w+') do |io|
      io.write ::YAML.dump(database[table_name].all.map(&:compact))
    end
  end
end
