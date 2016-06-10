module Bootscale
  class Railtie < ::Rails::Railtie
    module ActiveSupportDependenciesCache
      def search_for_file(path_suffix)
        Bootscale::Railtie[path_suffix]
      end
    end

    class << self
      def [](path)
        @cache[path]
      end

      def regenerate_cache
        @cache = Bootscale.generate_cache(ActiveSupport::Dependencies.autoload_paths)
      end

      def activate_active_support_dependencies_cache
        regenerate_cache
        ActiveSupport::Dependencies.singleton_class.prepend(ActiveSupportDependenciesCache)
      end
    end

    initializer :regenerate_require_cache, before: :load_environment_config do
      Bootscale.regenerate
    end

    initializer :activate_active_support_dependencies_cache, after: :set_autoload_paths do
      ::Bootscale::Railtie.activate_active_support_dependencies_cache
    end
  end
end
