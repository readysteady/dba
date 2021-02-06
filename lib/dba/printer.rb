# frozen_string_literal: true

require 'pastel'
require 'bigdecimal'

class DBA::Printer
  def initialize(io = STDOUT)
    @io = io
  end

  attr_reader :io

  def print_line
    io.puts
  end

  def print_error(message)
    io.puts(pastel.red('ERROR: ' + message))
  end

  def print_row(hash)
    hash.each do |name, value|
      io.puts muted("#{name}: ") + format(value)
    end
  end

  alias_method :print, :print_row

  def print_usage(program_name, command_parameters)
    io.puts "Usage: #{program_name} COMMAND"
    io.puts

    command_parameters.each do |command_name, parameters|
      parameters = parameters.map { |type, name| format_parameter(type, name) }.compact.join(' ').upcase

      io.puts "  #{program_name} #{command_name} #{parameters}"
    end

    io.puts
  end

  def print_diff(before_lines, after_lines)
    removed = before_lines - after_lines
    removed.each { |line| io.puts pastel.red("- #{line}") }

    added = after_lines - before_lines
    added.each { |line| io.puts pastel.bright_black("+ #{line}") }
  end

  def print_table(name, row_count)
    rows = muted("#{row_count} rows")

    io.puts "#{name} #{rows}"
  end

  def print_schema(table_name, schema_hash)
    schema_hash.each do |column_name, info_hash|
      fields = []
      fields << "#{table_name}.#{column_name}"
      fields << muted(format_column_type(info_hash))
      fields << muted('{primary}') if info_hash[:primary_key]

      io.puts fields.join(' ')
    end

    io.puts
  end

  def print_indexes(indexes)
    indexes.each do |index_name, info_hash|
      fields = []
      fields << index_name
      fields << muted('(' + info_hash.fetch(:columns).map(&:to_s).join(', ') + ')')
      fields << muted('{unique}') if info_hash[:unique]

      io.puts fields.join(' ')
    end
  end

  private

  def format(value)
    case value
    when NilClass
      null
    when BigDecimal
      value.to_s('F')
    when Time
      value.strftime('%F %T')
    else
      value.to_s
    end
  end

  def format_parameter(type, name)
    case type
    when :req then name
    when :opt then "[#{name}]"
    end
  end

  def format_column_type(info_hash)
    return info_hash[:db_type] unless info_hash[:type]
    return info_hash[:type] unless info_hash[:db_type]&.end_with?('[]')
    info_hash[:type].to_s + '[]'
  end

  def null
    @null ||= muted('NULL')
  end

  def muted(text)
    return text unless io.isatty

    pastel.bright_black(text.to_s)
  end

  def pastel
    @pastel ||= Pastel.new
  end
end
