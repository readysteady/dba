require 'logger'
require 'time'

class DBA::Edit < DBA::RowCommand
  def call(table, identifier)
    super

    row_parser = DBA::RowParser.new(table_schema)

    row_editor = DBA::RowEditor.new(row_parser)

    attributes = row_editor.edit(row)

    attributes.each do |key, value|
      attributes.delete(key) if equal?(value, row[key])
    end

    return if attributes.empty?

    database.loggers << Logger.new(STDOUT)

    dataset.update(attributes)
  end

  private

  def equal?(a, b)
    # A parsed Time and a database stored Time might be different if
    # the database stored Time has a non-zero millisecond component.
    return a.to_s == b.to_s if a.is_a?(Time) && b.is_a?(Time)

    a == b
  end
end
