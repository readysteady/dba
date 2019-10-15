class DBA::Schema < DBA::TableCommand
  def visit(table_name)
    printer.print_schema(table_name, database.schema(table_name))
  end
end
