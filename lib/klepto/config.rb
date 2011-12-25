module Klepto

  class MissingConfigurationOption < Exception; end
  class Config; end

  class << self
    attr_accessor :configuration_options

    def options(*args)
      Klepto.configuration_options = args

      args.each do |option|
        define_singleton_method(option) do
          instance_variable_get("@#{option}")
        end

        define_singleton_method("#{option}=".to_sym) do |value|
          instance_variable_set("@#{option}", value)
        end

        Config.send(:define_method, option) do |value|
          Klepto.send("#{option}=".to_sym, value)
        end
      end
    end

    def configure(options = {})
      config = Config.new

      yml_file = options.delete(:file) { nil }
      environment = options.delete(:environment) { nil }

      options.merge! options_from_file(yml_file, environment)
      options.each do |key, value|
        option = key.to_sym
        config.send(option, value) if configuration_options.include?(option)
      end
      yield(config) if block_given?
    end

    def options_from_file(yml_file, environment = nil)
      if yml_file
        yaml = YAML::load(File.open(yml_file))
        environment ? yaml[environment] : yaml
      else
        {}
      end
    end
  end

  options :archive, :source_path, :trove_api_key, :trove_server, :tootsie_server, :s3_bucket
end
