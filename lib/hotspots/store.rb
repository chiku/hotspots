module Hotspots
  class Store #:nodoc: all
    def initialize(lines, options = {})
      @lines  = lines
      @store  = Hash.new(0)
      @cutoff = options[:cutoff]      || 0
      @filter = options[:file_filter] || ""

      @lines.map   { |line| line.strip }.
             select{ |line| not line.empty? and line =~ Regexp.new(@filter) }.
             each  { |line| @store[line] += 1 }
    end

    def on(line)
      @store[line]
    end

    def to_s
      sorted_array.select     { |key, value| value >= @cutoff }.
                   reduce("") { |acc, (key, value)| acc << "#{key},#{value}\n" }
    end

    private

    def sorted_array
      @sorted_array ||= @store.sort do |(key1, value1), (key2, value2)|
        value2 <=> value1
      end
    end
  end
end
