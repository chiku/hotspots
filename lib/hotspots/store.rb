class Hotspots
  class Store #:nodoc: all
    def initialize(lines, options = {})
      @lines  = lines
      @store  = Hash.new(0)
      @cutoff = options[:cutoff]      || 0
      @filter = options[:file_filter] || ""

      @lines.map   { |line| line.strip }.
             select{ |line| !line.empty? && line =~ Regexp.new(@filter) }.
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
      @sorted_array ||= @store.sort do |(_, value1), (_, value2)|
        value2 <=> value1
      end
    end
  end
end
