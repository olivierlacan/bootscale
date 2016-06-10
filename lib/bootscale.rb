require_relative 'bootscale/version'

module Bootscale
  DOT_SO = '.so'.freeze
  DOT_RB = '.rb'.freeze

  class << self
    def [](path)
      @cache[path]
    end

    def setup(options = {})
      self.cache_directory = options[:cache_directory]
      require_relative 'bootscale/core_ext'
      regenerate
    end

    def regenerate
      @cache = generate_cache($LOAD_PATH)
    end

    def generate_cache(load_path)
      load_cache(load_path) || save_cache(Cache.build(load_path, entries))
    end

    private

    def entries
      @entries ||= {}
    end

    def load_cache(load_path)
      return unless storage
      storage.load(load_path)
    end

    def save_cache(cache)
      return cache unless storage
      storage.dump(cache.load_path, cache)
      cache
    end

    attr_accessor :storage

    def cache_directory=(directory)
      if directory
        require_relative 'bootscale/file_storage'
        self.storage = FileStorage.new(directory)
      else
        self.storage = nil
      end
    end
  end
end

require_relative 'bootscale/cache'
