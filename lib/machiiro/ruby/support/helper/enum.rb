# frozen_string_literal: true

module MachiiroSupport
  module Enum
    def self.included(base)
      base.extend(ClassMethods)
    end

    module Helper
      private

      def generate_ivar_name(name)
        name = name.to_s.underscore

        if name.end_with?('?')
          # ex) admin? -> @__admin
          "@__#{name.delete_suffix('?')}"
        else
          "@#{name}"
        end
      end
    end

    private_constant :Helper

    module ClassMethods
      attr_reader :type

      def enums_ordinal(*enums)
        @type = :ordinal
        enums.each_with_index do |e, i|
          define_entry!(enums, e, key: i + 1, order: i)
        end
      end

      def enums_string(*enums)
        @type = :string
        enums.each_with_index do |e, i|
          define_entry!(enums, e, order: i)
        end
      end

      def ordinal?
        @type == :ordinal
      end

      def string?
        @type == :string
      end

      def values
        indexes.values
      end
      alias enums values

      def value_of(key)
        key = key.to_i if ordinal?
        indexes[key]
      end

      def index_of(key)
        values.index { |v| v.key == key }
      end

      def has?(name)
        names.include?(name.to_sym)
      end

      private

      def indexes
        @indexes ||= names.each_with_object({}) do |name, indexes|
          entry = public_send name
          indexes[entry.key] = entry
        end
      end

      def define_entry!(enums, e, order:, key: nil)
        hash = {}

        if e.is_a?(Array)
          name = e.first
          hash.merge!(e.second || {})
        else
          name = e
        end

        key ||= name.to_s

        # add inquirer method of enum such as `admin?`
        add_inquirer!(enums, e, hash)

        names << name.to_sym

        # ex) :CONST_NAME -> "ConstName"
        clazz_name = name.to_s.underscore.camelize

        clazz = Class.new(Entry) do
          extend Helper

          hash.each do |k, v|
            members << k # for Entry#to_h

            next if method_defined?(k)

            ivar = generate_ivar_name(k)

            define_method(k) do
              # set value to instance variable for Entry#to_h
              instance_variable_set(ivar, v.respond_to?(:call) ? v.call : v)
            end
          end
        end

        const_set(clazz_name, clazz)

        entry = clazz.new(key: key, order: order, name: name)

        # prohibit to create instance of Entry
        clazz.class_eval do
          private_class_method :new
        end

        # define method to access Entry instance
        define_singleton_method(name) do
          entry
        end
      end

      def names
        @names ||= Set.new
      end

      def add_inquirer!(enums, e, hash)
        enums.each do
          name = _1.is_a?(Array) ? _1.first : _1
          hash["#{name.downcase}?".to_sym] = _1 == e if name
        end
      end
    end

    class Entry
      include Helper

      class << self
        def members
          @members ||= [:key, :order, :name, :lower_name]
        end
      end

      attr_reader :key, :order, :name, :lower_name

      def initialize(key:, order:, name:)
        @key = key
        @order = order
        @name = name
        @lower_name = name.downcase
      end

      def [](key)
        send key
      end

      def ==(other)
        if other.is_a?(Entry)
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
        to_h.as_json
      end

      def to_json(*)
        as_json.to_json
      end

      def to_h
        self.class.members.each_with_object({}) do |member, h|
          ivar = generate_ivar_name(member)

          h[member] =
            if instance_variable_defined?(ivar)
              instance_variable_get(ivar)
            else
              send member
            end
        end
      end
    end

    private_constant :Entry
  end
end
