# frozen_string_literal: true

class DBA::DBMLPrinter < DBA::DiagramPrinter
  def print_table_start(name)
    @io.puts "Table #{name} {"
  end

  def print_table_end(name)
    @io.puts '}'
  end

  def print_column(name, type)
    @io.puts "  #{name} #{type}"
  end

  def print_foreign_key(table, column, other_table, other_column)
    @io.puts %{Ref: #{table}.#{column} > #{other_table}.#{other_column}}
  end
end
