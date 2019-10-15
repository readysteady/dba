class DBA::Indexes < DBA::TableCommand
  def visit(table_name)
    printer.print_indexes(database.indexes(table_name))
  end
end
