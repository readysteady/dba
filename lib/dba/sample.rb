class DBA::Sample < DBA::Command
  def call(table, column = nil)
    self.table_name = table

    column_name = column.to_sym if column

    random_rows = database[table_name].order(random_function)

    if column_name
      random_rows.distinct.select(column_name).limit(20).each do |row|
        puts row[column_name]
      end
    else
      random_rows.first(3).each do |row|
        printer.print(row)
        printer.print_line
      end
    end
  end

  private

  def random_function
    if defined?(Sequel::Mysql2) && database.is_a?(Sequel::Mysql2::Database)
      return Sequel.function(:rand)
    end

    Sequel.function(:random)
  end
end
