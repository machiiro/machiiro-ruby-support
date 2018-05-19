module MachiiroSupport
  module AttrExtender
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def json_fields
        @json_fields
      end

      def json_field?(name)
        @json_fields.include?(name)
      end

      def attr_json_fields(*names)
        @json_fields ||= []

        names.each do |name|
          json_fields.push(name)

          define_method(name) do
            v = read_attribute(name)
    
            if v.is_a?(Hash)
              return HashWithIndifferentAccess.new(v)
            elsif v.is_a?(Array)
              return v.map { |e| e.is_a?(Hash) ? HashWithIndifferentAccess.new(e) : e }
            end
    
            v
          end
        end
      end

      def enum_fields
        @enum_fields
      end

      def enum_class(name)
        @enum_fields[name]
      end

      def attr_enum_fields(*fields)
        define_enum_methods(fields)
      end

      def attr_enum_fields_with_validator(*fields)
        define_enum_methods(fields) do |name, enum_class|
          validates(name, enums: { enum_class: enum_class })
        end
      end

      def define_enum_methods(fields)
        @enum_fields ||= {}

        fields.each do |e|
          name = e.first
          enum_class = e.last

          @enum_fields[name] = enum_class

          yield(name, enum_class) if block_given?

          define_enum_method(name, enum_class)
        end
      end

      def define_enum_method(name, enum_class)
        define_method("#{name}_enum") do
          enum_class.value_of(read_attribute(name))
        end

        define_method("#{name}_enum=") do |value|
          write_attribute(name, value.key)
        end
      end
    end
  end
end