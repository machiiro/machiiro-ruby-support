module MachiiroSupport
  module Enum
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :type, :enums, :enums_names

      def enums_ordinal(*enums)
        @type = :ordinal
        @enums = enums.map.with_index { |e, i| OpenStruct.new(key: i + 1, name: e, lower_name: e.downcase) }
        @enums_names = Hash[@enums.map { |e| [e.name, e] }]
      end

      def enums_string(*enums)
        @type = :string
        @enums = enums.map.with_index do |e, i|
          hash = { order: i }
          if e.is_a?(Array)
            hash[:name] = e.first
            hash.merge!(e.second || {})
          else
            hash[:name] = e
          end
          hash[:key] = hash[:name].to_s
          hash[:lower_name] = hash[:name].downcase

          OpenStruct.new(hash)
        end
        @enums_names = Hash[@enums.map { |e| [e.name, e] }]
      end

      def method_missing(name, *args)
        if !args.present? && enums_names[name.to_sym]
          enums_names[name.to_sym]
        else
          super
        end
      end

      def ordinal?
        @type == :ordinal
      end

      def string?
        @type == :string
      end

      def values
        enums
      end

      def value_of(key)
        key = key.to_i if ordinal?
        values.find do |v|
          v.key == key
        end
      end

      def index_of(key)
        values.index { |v| v.key == key }
      end
    end
  end
end