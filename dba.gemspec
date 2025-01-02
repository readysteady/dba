Gem::Specification.new do |s|
  s.name = 'dba'
  s.version = '2.3.0'
  s.license = 'GPL-3.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Tim Craft']
  s.email = ['mail@timcraft.com']
  s.homepage = 'https://github.com/readysteady/dba'
  s.description = 'Ruby command line tool for working with development databases'
  s.summary = 'See description'
  s.files = Dir.glob('lib/**/*.rb') + %w[CHANGES.md LICENSE.txt README.md dba.gemspec]
  s.required_ruby_version = '>= 2.5.0'
  s.add_dependency 'bigdecimal', '~> 3'
  s.add_dependency 'pastel', '~> 0'
  s.add_dependency 'sequel', '~> 5'
  s.add_dependency 'zeitwerk', '~> 2'
  s.require_path = 'lib'
  s.executables = ['dba']
end
