# frozen_string_literal: true

require 'mysql2'

class DBDataSource
  private_class_method :new
  @instance_mutex = Mutex.new

  def initialize
    db_config = YAML.load_file('./LabStudents/db_config/config.yaml').transform_keys(&:to_sym)
    @client = Mysql2::Client.new(db_config)
    @client.query_options.merge!(symbolize_keys: true)
  end

  def self.instance
    return @instance if @instance

    @instance_mutex.synchronize do
      @instance ||= new
    end

    @instance
  end

  def prepare_exec(statement, *params)
    @client.prepare(statement).execute(*params)
  end

  def query(statement)
    @client.query(statement)
  end
end
