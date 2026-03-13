module MachiiroSupport
  module ModuleProvider
    def provider
      @provider = Provider.new if @provider.nil?
      @provider
    end

    def provide(name, *args, **kwargs)
      provider.provide(name, *args, **kwargs)
    end

    def repository(name, *args, **kwargs)
      provide("#{name}_repository".to_sym, *args, **kwargs)
    end

    def translator(name, *args, **kwargs)
      provide("#{name}_translator".to_sym, *args, **kwargs)
    end

    class Provider
      attr_accessor :observer

      def initialize
        @modules = {}
      end

      def provide(name, *args, **kwargs)
        return ModuleProxy.new(@modules[name], observer) if @modules[name].present?

        clazz = Object.const_get(name.to_s.split('__').map(&:camelize).join('::'))
        if clazz.present?
          ModuleProxy.new(clazz.new(*args, **kwargs), observer)
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

      def method_missing(name, *args, **kwargs, &block)
        value = @mod.send(name, *args, **kwargs, &block)
        @observer.observe(@mod, name, value) if @observer.present?
        value
      end
    end
  end
end