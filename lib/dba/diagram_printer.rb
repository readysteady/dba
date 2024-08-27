class DBA::DiagramPrinter
  def initialize(io = STDOUT)
    @io = io
  end

  def print_diagram(database)
    print_start

    @primary_keys = {}

    table_names = database.tables

    table_names.each do |name|
      schema_hash = database.schema(name)

      print_table(name, schema_hash)
    end

    table_names.each do |table|
      database.foreign_key_list(table).each do |hash|
        column = hash.fetch(:columns).first

        other_table = hash.fetch(:table)

        other_column = @primary_keys.fetch(other_table)

        print_foreign_key(table, column, other_table, other_column)
      end
    end

    print_end
  end

  def print_start
  end

  def print_end
  end

  def print_table(name, schema_hash)
    print_table_start(name)

    schema_hash.each do |column_name, info_hash|
      column_type = info_hash[:type] || info_hash[:db_type]

      if info_hash[:primary_key]
        @primary_keys[name] = column_name
      end

      print_column(column_name, column_type)
    end

    print_table_end(name)
  end

  def print_table_start(name)
  end

  def print_table_end(name)
  end

  def print_column(name, type)
  end

  def print_foreign_key(table, column, other_table, other_column)
  end
end
