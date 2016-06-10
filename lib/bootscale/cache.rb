require_relative 'entry'

module Bootscale
  class Cache
    LEADING_SLASH = '/'.freeze

    class << self
      # generate the requireables cache from all current load-path entries
      # each load-path is cached individually, so new ones can be added or removed
      # but added/removed files will not be discovered
      def build(load_path, entries = {})
        requireables = load_path.reverse_each.flat_map do |path|
          path = path.to_s
          entries[path] ||= Entry.new(path).requireables
        end
        new(load_path, Hash[requireables])
      end
    end

    attr_reader :load_path

    def initialize(load_path, requireables)
      @load_path = load_path
      @requireables = requireables
    end

    def [](path)
      path = path.to_s
      return if path.start_with?(LEADING_SLASH)
      if path.end_with?(DOT_RB, DOT_SO)
        @requireables[path]
      else
        @requireables["#{path}#{DOT_RB}"] || @requireables["#{path}#{DOT_SO}"]
      end
    end

    def to_h
      @requireables
    end
  end
end
