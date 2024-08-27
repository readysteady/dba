# frozen_string_literal: true

class DBA::Diagram < DBA::Command
  PRINTERS = {
    '.dbml' => :DBMLPrinter,
    '.dot' => :DOTPrinter,
    '.gv' => :DOTPrinter,
    '.pu' => :PlantUMLPrinter,
    '.puml' => :PlantUMLPrinter,
  }

  def call(path = nil)
    if path.nil?
      printer = DBA::DOTPrinter.new
      printer.print_diagram(database)
    else
      extension = File.extname(path)

      printer = PRINTERS.fetch(extension) { raise DBA::Error, 'unsupported file extension' }
      printer = DBA.const_get(printer)

      File.open(path, 'w+') do |file|
        printer = printer.new(file)
        printer.print_diagram(database)
      end
    end
  end
end
