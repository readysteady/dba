# frozen_string_literal: true

class DBA::Load < DBA::Command
  ADAPTERS = {
    '.csv' => :CSV,
    '.ldjson' => :LDJSON,
    '.yml' => :YAML,
    '.yaml' => :YAML
  }

  def call(path)
    file_list(path).each do |file|
      extension = File.extname(file)

      adapter = ADAPTERS.fetch(extension) { raise DBA::Error, 'unsupported file extension' }

      adapter = DBA.const_get(adapter)

      table_name = File.basename(file, extension).to_sym

      adapter.load(file, database, table_name)
    end
  end

  private

  def file_list(path)
    if File.directory?(path)
      Dir.glob(File.join(path, '*.{csv,ldjson,yml,yaml}'))
    else
      [path]
    end
  end
end
