module AlpacaTemplate
  class FileParser
    def self.parse(from, configuration = {})
      content = File.open(from, 'r') { |f| f.read }
      content = ERB.new(content).result(configuration.get_binding(from))
      content
    end
  end
end
