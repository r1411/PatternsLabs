# frozen_string_literal: true

require 'logger'

class LoggerHolder
  private_class_method :new
  @instance_mutex = Mutex.new

  attr_reader :logger

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def self.instance
    return @instance.logger if @instance

    @instance_mutex.synchronize do
      @instance ||= new
    end

    @instance.logger
  end
end
