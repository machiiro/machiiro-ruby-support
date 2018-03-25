module MachiiroSupport
  module ModuleProvider
    def provider
      @provider = Provider.new if @provider.nil?
      @provider
    end

    def provide(name, *args)
      provider.provide(name, *args)
    end

    def repository(name, *args)
      provide("#{name}_repository".to_sym, *args)
    end

    def translator(name, *args)
      provide("#{name}_translator".to_sym, *args)
    end

    class Provider
      attr_accessor :observer

      def initialize
        @modules = {}
      end

      def provide(name, *args)
        return ModuleProxy.new(@modules[name], observer) if @modules[name].present?

        clazz = Object.const_get(name.to_s.split('__').map(&:camelize).join('::'))
        if clazz.present?
          ModuleProxy.new(clazz.new(*args), observer)
        else
          ModuleProxy.new(super, observer)
        end
      end

      def register(clazz, value)
        @modules[clazz.name.demodulize.underscore.to_sym] = value
      end
    end

    class ModuleProxy
      def initialize(mod, observer = nil)
        @mod = mod
        @observer = observer
      end

      def method_missing(name, *args, &block)
        value = @mod.send(name, *args, &block)
        @observer.observe(@mod, name, value) if @observer.present?
        value
      end
    end
  end
end