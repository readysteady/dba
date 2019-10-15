require 'zeitwerk'

module DBA
  Error = Class.new(StandardError)

  loader = Zeitwerk::Loader.new
  loader.tag = File.basename(__FILE__, '.rb')
  loader.inflector.inflect('dba' => 'DBA')
  loader.push_dir(__dir__)
  loader.setup
end
