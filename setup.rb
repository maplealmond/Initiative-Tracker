Shoes.setup do
  gem "do_sqlite3"
  gem "dm-core"
end

require 'do_sqlite3'
require 'dm-core'

ROOT = File.dirname(__FILE__)
DataMapper.setup(:default, "sqlite3:init.db")
Dir[ROOT + "/models/*.rb"].each { |f| require f }