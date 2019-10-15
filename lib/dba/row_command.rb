class DBA::RowCommand < DBA::Command
  def call(table, identifier)
    self.table_name = table

    self.table_schema = DBA::TableSchema.new(database, table_name)

    self.primary_key = table_schema.primary_key

    self.dataset = database[table_name].where(primary_key => identifier)

    self.row = dataset.first

    unless row
      raise DBA::Error, "could not find row #{primary_key}=#{identifier}"
    end
  end

  private

  attr_accessor :table_schema

  attr_reader :primary_key

  def primary_key=(primary_key)
    unless primary_key
      raise DBA::Error, "could not find primary key for #{table_name} table"
    end

    @primary_key = primary_key
  end

  attr_accessor :dataset

  attr_accessor :row
end
