# frozen_string_literal: true

require 'sequel'
require 'yaml'
require 'erb'
require 'socket'

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
      return 'postgres://localhost:5432/postgres'
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

  def database_config_path
    File.join('config', 'database.yml')
  end

  def database_config?
    File.exist?(database_config_path)
  end

  def database_config
    source = ERB.new(File.read(database_config_path)).result

    if YAML.respond_to?(:unsafe_load)
      YAML.unsafe_load(source)
    else
      YAML.load(source)
    end
  end

  def development_database_args
    args = database_config['development']
    args['adapter'] = 'postgres' if args['adapter'] == 'postgresql'
    args['adapter'] = 'sqlite' if args['adapter'] == 'sqlite3'
    args
  end

  def postgres_running?
    Socket.tcp('localhost', 5432) { :connected }
  rescue Errno::ECONNREFUSED
  end
end
