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

get '/lists/?' do
  @title = "Lists | Bitfyre's Todos"
  @lists = TaskList.all
  haml :'lists/index'
end

post '/lists/?' do
  @list = TaskList.create(:list_name => params["list-name"])
  if @list.valid?
    haml :'lists/success'
  else
    haml :index
  end
end

get '/lists/:id' do
  task_list = TaskList.find(params[:id])
  @title = "#{task_list.list_name} | Bitfyre's Todos"
  haml :'lists/list'
end
