class DBA::TableCommand < DBA::Command
  def call(table = nil)
    if table
      self.table_name = table

      visit(table_name)
    else
      database.tables.sort.each { |name| visit(name) }
    end
  end
end
