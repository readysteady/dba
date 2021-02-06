class DBA::Select < DBA::Command
  def call(table, column, value)
    self.table_name = table

    column_name = column.to_sym

    rows = database[table_name].where(column_name => value)

    rows.each do |row|
      printer.print(row)
      printer.print_line
    end
  end
end
