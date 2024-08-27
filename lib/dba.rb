# Copyright (c) 2019-2024 TIMCRAFT
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

require 'zeitwerk'

module DBA
  Error = Class.new(StandardError)

  loader = Zeitwerk::Loader.new
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector.inflect({
    'csv' => 'CSV',
    'dba' => 'DBA',
    'dbml_printer' => 'DBMLPrinter',
    'dot_printer' => 'DOTPrinter',
    'ldjson' => 'LDJSON',
    'plant_uml_printer' => 'PlantUMLPrinter',
    'yaml' => 'YAML'
  })
  loader.push_dir(__dir__)
  loader.setup
end
