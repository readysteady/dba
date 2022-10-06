class DBA::Command
  def self.arity_check(args)
    parameters = instance_method(:call).parameters

    required, optional = parameters.partition { |(type, name)| type == :req }

    expected = optional.empty? ? required.size : (required.size .. required.size + optional.size)

    unless expected === args.size
      raise DBA::Error, "incorrect number of arguments (given #{args.size}, expected #{expected})"
    end
  end

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
