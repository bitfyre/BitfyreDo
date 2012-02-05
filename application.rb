require "sinatra"
require "sinatra/activerecord"

class TaskList < ActiveRecord::Base
  validates_uniqueness_of :list_name
  validates_presence_of   :list_name
end

get '/' do
  "Bitfyre's Todos"
end
