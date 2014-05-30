require 'fileutils'
require 'erb'

module AlpacaTemplate
  class Template
    def initialize(path, configuration = Configuration.new)
      @template_path = path
      @configuration = configuration
    end

    def copy(to)
      FileUtils.cd("#{@template_path}/resources") do
        Dir["**/*"].each do |file|
          FileParser.copy(file, to, @configuration)
        end
      end
    end
  end
end
