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
        Dir["**/*"].each do |from_path|
          copy(from_path, path)
        end
      end
    end

    private

    def rename_target_filepath(from)
      path = from.split('/')
      keys = ['filenames'] + path
      filename = @configuration.nest(*keys)
      if filename.is_a?(String)
        path[-1] = filename
        path.join('/')
      else
        from
      end
    end

    def copy(from, to)
      return if File.directory?(from)

      new_file = "#{to}/#{rename_target_filepath(from)}"

      unless File.directory?(File.dirname(new_file))
        FileUtils.mkdir_p(File.dirname(new_file))
      end

      content = FileParser.parse(from, @configuration)
      File.open(new_file, 'w') { |f| f.puts(content) }
    end
  end
end
