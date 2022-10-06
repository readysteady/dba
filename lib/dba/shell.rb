# frozen_string_literal: true

module DBA::Shell
  extend self

  def run(args=ARGV)
    print_usage if args.empty? || args == ['--help']

    command_name = args.shift

    command = commands[command_name]

    if command.nil?
      raise DBA::Error, "#{command_name} is not a valid command"
    end

    command = DBA.const_get(command)

    command.arity_check(args)

    database = DBA::Database.connect

    command = command.new(database)
    command.call(*args)
  rescue DBA::Error => exception
    print_error(exception.message)
  end

  private

  def commands
    {
      'diff' => :Diff,
      'dump' => :Dump,
      'edit' => :Edit,
      'find' => :Find,
      'indexes' => :Indexes,
      'load' => :Load,
      'pull' => :Pull,
      'sample' => :Sample,
      'schema' => :Schema,
      'select' => :Select,
      'tables' => :Tables
    }
  end

  def command_parameters
    commands.transform_values do |name|
      DBA.const_get(name).instance_method(:call).parameters
    end
  end

  def program_name
    'dba'
  end

  def print_usage
    printer = DBA::Printer.new(STDERR)
    printer.print_usage(program_name, command_parameters)

    Kernel::exit(1)
  end

  def print_error(message)
    printer = DBA::Printer.new(STDERR)
    printer.print_error(message)

    Kernel::exit(1)
  end
end
