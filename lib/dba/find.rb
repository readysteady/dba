class DBA::Find < DBA::RowCommand
  def call(table, identifier)
    super

    printer.print(row)
    printer.print_line
  end
end
