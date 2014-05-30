require 'fileutils'
require 'erb'

module AlpacaTemplate
  class Template
    def initialize(path, configuration = Configuration.new)
      @template_path = path
      @configuration = configuration
    end

    def expand_template_to(path)
      FileUtils.cd("#{@template_path}/resources") do
        Dir["**/{*,.*}"].each do |from_path|
          copy(from_path, path)
        end
      end

      FileUtils.cd(path) do
        @configuration.nest('renaming_pattern').each do |from, to|
          rename(from, to)
        end
      end
    end

    private

    def rename(from, to)
      unless File.directory?(File.dirname(to))
        FileUtils.mkdir_p(File.dirname(to))
      end

      if File.exists?(from)
        FileUtils.mv(from, to, force: true)
      else
        p 'file_not fond'
      end
    end

    def copy(from, to)
      return if File.directory?(from)

      new_file = "#{to}/#{from}"

      unless File.directory?(File.dirname(new_file))
        FileUtils.mkdir_p(File.dirname(new_file))
      end

      content = FileParser.parse(from, @configuration)
      File.open(new_file, 'w') { |f| f.puts(content) }
    end
  end
end
