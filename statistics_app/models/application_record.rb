require_relative '../db/config'

Config.establish_db_connection
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
