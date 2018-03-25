module MachiiroSupport
  module Settable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def get(key)
        @settings = {} if @settings.nil?
        @settings[key]
      end

      def set(key, value)
        @settings = {} if @settings.nil?
        @settings[key] = value
      end
    end
  end
end