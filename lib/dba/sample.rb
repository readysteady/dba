class DBA::Sample < DBA::Command
  def call(table, column = nil)
    self.table_name = table

    column_name = column.to_sym if column

    if column_name
      dataset = database[table_name].exclude(column_name => nil).distinct.select(column_name)
      dataset.from_self.order(random_function).limit(20).each do |row|
        puts row[column_name]
      end
    else
      database[table_name].order(random_function).first(3).each do |row|
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
