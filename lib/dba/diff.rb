require 'sequel'

class DBA::Diff < DBA::Command
  def call(url)
    other_database = Sequel.connect(url)

    tables = database.tables

    other_tables = other_database.tables

    diff tables, other_tables

    tables &= other_tables # only diff columns/indexes for tables that exist in both databases

    printer.print_diff list_columns(database, tables), list_columns(other_database, tables)

    printer.print_diff list_indexes(database, tables), list_indexes(other_database, tables)
  end

  private

  def list_columns(database, tables)
    tables.inject([]) do |columns, table_name|
      columns + database.schema(table_name).map { |name, info| format_column(name, info) }
    end
  end

  def list_indexes(database, tables)
    tables.inject([]) do |indexes, table_name|
      indexes + database.indexes(table_name).map { |name, info| format_index(name, info) }
    end
  end

  def format_column(name, info_hash)
    "#{table_name}.#{name} (#{info_hash.fetch(:type)})"
  end

  def format_index(name, info_hash)
    columns = info_hash.fetch(:columns).map(&:to_s).join(', ')

    "#{name} (#{columns})"
  end
end
