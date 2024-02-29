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
          hash = add_inquirer(_enums, e, hash)

          Entry.new self, hash
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
          hash = add_inquirer(_enums, e, hash)

          Entry.new self, hash
        end
        @enums_names = Hash[@enums.map { |e| [e.name, e] }]
      end

      def method_missing(name, *args)
        if !args.present? && enums_names[name]
          enums_names[name]
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        enums_names.key?(name) || super
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

      private

      def add_inquirer(_enums, e, hash)
        _enums.each do |_e|
          name = _e.is_a?(Array) ? _e.first : _e
          hash["#{name.downcase}?".to_sym] = _e == e if name
        end

        hash
      end
    end

    class Entry
      def initialize(namespace, hash)
        @namespace = namespace
        @hash = hash
      end

      def ==(other)
        if other.is_a?(self.class)
          key == other.key && order == other.order && name == other.name
        else
          false
        end
      end
      alias eql? ==
      alias equal? ==
      alias === ==

      def hash
        "#{key}:#{order}:#{name}".hash
      end

      def as_json(*)
        @hash.as_json(only: %i[key name order lower_name])
      end

      def to_json(*)
        as_json.to_json
      end

      def to_h
        @hash
      end

      def method_missing(name, *args)
        if @hash.key?(name)
          @hash[name]
        else
          super
        end
      end

      def respond_to_missing?(name, include_private = false)
        @hash.key?(name) || super
      end
    end
  end
end
