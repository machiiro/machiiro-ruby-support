module MachiiroSupport
  module AttrExtender
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attr_enum_fields(*fields)
        fields.each do |e|
          name = e.first
          enum_class = e.last

          define_enum_methods(name, enum_class)
        end
      end

      def attr_enum_fields_with_validator(*fields)
        fields.each do |e|
          name = e.first
          enum_class = e.last

          define_enum_methods(name, enum_class)
          validates(name, enums: { enum_class: enum_class })
        end
      end

      def define_enum_methods(name, enum_class)
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