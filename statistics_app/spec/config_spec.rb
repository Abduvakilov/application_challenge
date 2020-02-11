# frozen_string_literal: true

require_relative '../db/config'

describe Config do
  it 'loads database.yml' do
    Config.load_database_yaml
  end
  it 'gets current database name' do
    expect(Config.current_database_name).to eq(ENV['TEST_DB'])
  end
  it 'establishes connection' do
    Config.establish_db_connection
  end
end
