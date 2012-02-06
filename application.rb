require "sinatra"
require "sinatra/activerecord"

class TaskList < ActiveRecord::Base
  attr_accessible :list_name

  validates :list_name,  :presence => true,
            :uniqueness => { :case_sensitive => false }
end

get '/' do
  @title = "Bitfyre's Todos"
  haml :index
end

