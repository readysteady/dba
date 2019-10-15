class DBA::Command
  def initialize(database)
    self.database = database
  end

  attr_accessor :database

  attr_reader :table_name

  def table_name=(table_name)
    @table_name = table_name.to_sym

    unless database.tables.include?(@table_name)
      raise DBA::Error, "could not find table #{table_name}"
    end
  end

  private

  def printer
    @printer ||= DBA::Printer.new
  end
end
