# frozen_string_literal: true

class DBA::DOTPrinter < DBA::DiagramPrinter
  def print_start
    @io.puts 'digraph database {'
    @io.puts '  graph[rankdir="LR",ranksep=1.5,nodesep=0.5];'
    @io.puts '  node[shape="Mrecord",fontname="Helvetica,Arial,sans-serif"];'
  end

  def print_end
    @io.puts '}'
  end

  def print_table(name, schema_hash)
    label = [name]

    schema_hash.each do |column_name, info_hash|
      column_type = info_hash[:type] || info_hash[:db_type]

      if info_hash[:primary_key]
        @primary_keys[name] = column_name

        label << "{<#{column_name}>#{column_name}|#{column_type}}"
      else
        label << "{#{column_name}|<#{column_name}>#{column_type}}"
      end
    end

    label = label.join('|')

    @io.puts %{  #{name}[label="#{label}"];}
  end

  def print_foreign_key(table, column, other_table, other_column)
    @io.puts %{  #{table}:#{column} -> #{other_table}:#{other_column};}
  end
end
