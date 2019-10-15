class DBA::Pull < DBA::Command
  def call(table, url)
    self.table_name = table

    dataset = database[table_name]

    other_database = Sequel.connect(url)

    database.transaction do
      other_database[table_name].each { |row| dataset.insert(row) }
    end
  end
end
