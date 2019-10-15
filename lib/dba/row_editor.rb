# frozen_string_literal: true

class DBA::RowEditor
  def initialize(row_parser)
    @row_parser = row_parser

    @editor = ENV['EDITOR']
  end

  def edit(hash)
    io = IO.popen(@editor, 'w+')

    printer = DBA::Printer.new(io)
    printer.print_row(hash)

    io.close_write

    output = io.read

    io.close

    @row_parser.parse(output)
  end
end
