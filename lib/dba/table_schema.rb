class DBA::TableSchema
  def initialize(database, table_name)
    @schema = database.schema(table_name)

    @column_type_hash = @schema.each_with_object({}) do |(column_name, column_info), hash|
      hash[column_name] = column_info[:type]
    end
  end

  def primary_key
    @schema.each do |column_name, column_info|
      return column_name if column_info[:primary_key]
    end

    return nil
  end

  def column_type(column_name)
    @column_type_hash.fetch(column_name)
  end
end
