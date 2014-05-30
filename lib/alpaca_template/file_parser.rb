require 'json'

module AlpacaTemplate
  class FileParser
    class << self
      def parse(from, configuration = {})
        content = File.open(from, 'r') { |f| f.read }
        content = ERB.new(content).result(configuration.get_binding(from))
        content
      end
    end
  end
end
