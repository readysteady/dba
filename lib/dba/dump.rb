# frozen_string_literal: true

class DBA::Dump < DBA::Command
  ADAPTERS = {
    'csv' => :CSV,
    'jsonl' => :LDJSON,
    'ldjson' => :LDJSON,
    'ndjson' => :LDJSON,
    'yml' => :YAML,
    'yaml' => :YAML
  }

  def call(table, extension)
    self.table_name = table

    output_path = "#{table_name}.#{extension}"

    adapter = ADAPTERS.fetch(extension) { raise DBA::Error, 'unsupported file extension' }

    adapter = DBA.const_get(adapter)

    rows = database[table_name].count

    return if rows.zero?

    adapter.dump(database, table_name, output_path)
  end
end
