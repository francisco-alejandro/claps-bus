# frozen_string_literal: true

require_relative "bus/version"
require "concurrent/map"

# Pegasus module that includes Bus and Error definitions
module Claps
  class MultipleHandlerError < StandardError; end
  class UnregisteredHandlerError < StandardError; end

  # Bus to handle query or command events
  class Bus
    def initialize
      @handlers = Concurrent::Map.new
    end

    def register(command:, handler:)
      raise MultipleHandlerError, "#{command} has multiple handers registered" if handlers[command]

      handlers[command] = handler
    end

    def call(command, *args, **kwargs)
      handlers.fetch(command) do
        raise UnregisteredHandlerError, "Missing handler for #{command}"
      end.call(*args, **kwargs)
    end

    private

    attr_reader :handlers
  end
end
