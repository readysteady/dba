# frozen_string_literal: true

class DBA::PlantUMLPrinter < DBA::DiagramPrinter
  def print_start
    @io.puts '@startuml'
    @io.puts 'left to right direction'
  end

  def print_end
    @io.puts '@enduml'
  end

  def print_table_start(name)
    @io.puts "map #{name} {"
  end

  def print_table_end(name)
    @io.puts '}'
  end

  def print_column(name, type)
    @io.puts "  #{name} => #{type}"
  end

  def print_foreign_key(table, column, other_table, other_column)
    @io.puts %{#{table}::#{column} *-> #{other_table}::#{other_column}}
  end
end
