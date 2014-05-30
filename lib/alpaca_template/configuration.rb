require 'yaml'

module AlpacaTemplate
  class Configuration < Hash
    def parse!(content, parser = YAML)
      self.replace parser.load(content)['template']
      self
    end

    def get_binding(path = nil)
      configuration = self
      variables = nest(*%w[variables global]).clone

      if path
        keys = %w[variables local] + path.split('/')
        variables.merge!(nest(*keys))
      end

      binding
    end

    def nest(*keys)
      keys.reduce(self) {|m,k| m && m[k] } || {}
    end
  end
end
