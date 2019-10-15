# frozen_string_literal: true

require 'sequel'
require 'yaml'
require 'erb'

module DBA::Database
  extend self

  def connect
    args = find_connection_args

    Sequel.connect(args)
  rescue Sequel::DatabaseConnectionError => exception
    raise DBA::Error, connection_error_message(args)
  end

  private

  def find_connection_args
    if dotenv?
      File.readlines('.env').each do |line|
        if line.strip =~ /\ADATABASE_URL=/
          return $'
        end
      end
    end

    if database_config?
      return development_database_args
    end

    if postgres_running?
      return "postgres://localhost:5432/#{postgres_database_name}"
    end

    if path = Dir['*.sqlite3'].first
      return 'sqlite://' + path
    end

    raise DBA::Error, 'could not find database'
  end

  def connection_error_message(args)
    if args.is_a?(Hash)
      adapter, host, port = args.values_at('adapter', 'host', 'port')

      host ||= 'localhost'

      if port
        "could not connect to #{adapter} database at #{host}:#{port}"
      else
        "could not connect to #{adapter} database at #{host}"
      end
    else
      uri = URI(args)

      "could not connect to #{uri.scheme} database at #{uri.host}"
    end
  end

  def dotenv?
    File.exist?('.env')
  end

  def database_config?
    File.exist?('config/database.yml')
  end

  def database_config
    YAML.load(ERB.new(File.read('config/database.yml')).result)
  end

  def development_database_args
    args = database_config['development']
    args['adapter'] = 'postgres' if args['adapter'] == 'postgresql'
    args['adapter'] = 'sqlite' if args['adapter'] == 'sqlite3'
    args
  end

  def postgres_database_name
    heroku_app_name || working_directory_name
  end

  def heroku_app_name
    if `git config --get remote.heroku.url`.chomp =~ %r{(?<=[:/])([^:/]+)\.git\z}
      $1
    end
  end

  def working_directory_name
    File.basename(Dir.pwd)
  end

  def postgres_running?
    !`lsof -i:5432`.strip.empty?
  end
end
