module MachiiroSupport
  module Enum
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :type, :enums, :enums_names

      def enums_ordinal(*_enums)
        @type = :ordinal
        @enums = _enums.map.with_index do |e, i|
          hash = { key: i + 1, order: i }
          if e.is_a?(Array)
            hash[:name] = e.first
            hash.merge!(e.second || {})
          else
            hash[:name] = e
          end
          hash[:lower_name] = hash[:name].downcase
          hash = add_judgement_items(_enums, e, hash)

          OpenStruct.new(hash)
        end
        @enums_names = Hash[@enums.map { |e| [e.name, e] }]
      end

      def enums_string(*_enums)
        @type = :string
        @enums = _enums.map.with_index do |e, i|
          hash = { order: i }
          if e.is_a?(Array)
            hash[:name] = e.first
            hash.merge!(e.second || {})
          else
            hash[:name] = e
          end
          hash[:key] = hash[:name].to_s
          hash[:lower_name] = hash[:name].downcase
          hash = add_judgement_items(_enums, e, hash)

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
      ruby2_keywords(:method_missing) if respond_to?(:ruby2_keywords, true)

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

      private

      def add_judgement_items(_enums, e, hash)
        _enums.each do |_e|
          if _e.is_a?(Array)
            name = _e.first
          else
            name = _e
          end

          q_method = "#{name.downcase}?"
          q_method = "_#{q_method}" if OpenStruct.method_defined?(q_method)
          hash[q_method] = _e == e
        end

        hash
      end
    end
  end
end
