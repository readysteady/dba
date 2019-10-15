class DBA::Tables < DBA::Command
  def call
    database.tables.sort.each do |name|
      row_count = database[name].count

      printer.print_table(name, row_count)
    end
  end
end
