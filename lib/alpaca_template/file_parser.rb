module AlpacaTemplate
  class FileParser
    def self.copy(from, to, configuration = {})
      return if File.directory?(from)

      new_file = "#{to}/#{from}"

      unless File.directory?(File.dirname(new_file))
        FileUtils.mkdir_p(File.dirname(new_file))
      end

      # Parse file
      content = File.open(from, 'r') { |f| f.read }
      content = ERB.new(content).result(configuration.get_binding(from))

      File.open(new_file, 'w') { |f| f.puts(content) }
    end
  end
end
