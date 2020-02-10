# frozen_string_literal: true

require 'active_record'
require 'pathname'

ActiveSupport::Deprecation.silenced = true

class Config 
  class << self; attr_accessor :db_config, :root end
  @db_config = nil
  @root = Pathname.new(File.expand_path('../..', __FILE__))

  def self.environment
    ENV['ENVIRONMENT'] ||= 'production'
  end

  def self.load_database_yaml
    return unless File.exists?(root.join('db/database.yml').to_s)
    require 'yaml'
    require 'erb'

    yaml = File.read(root.join('db/database.yml').to_s)
    erb = ERB.new(yaml)
    YAML::load(erb.result)
  end

  def self.db_config
    @db_config ||= load_database_yaml
  end

  def self.current_db_config
    db_config[environment]
  end

  def self.current_database_name
    current_db_config['database']
  end

  def self.establish_db_connection
    return if ActiveRecord::Base.connected?

    ActiveRecord::Base.establish_connection(Config.current_db_config)
  end
end
