require "sinatra"
require "sinatra/activerecord"

# Render the page once:
# Usage: partial :foo
# 
# foo will be rendered once for each element in the array, passing in a local variable named "foo"
# Usage: partial :foo, :collection => @my_foos    

helpers do
  def partial(template, *args)
    options = args.extract_options!
    options.merge!(:layout => false)
    if collection = options.delete(:collection) then
      collection.inject([]) do |buffer, member|
        buffer << haml(template, options.merge(
                                  :layout => false, 
                                  :locals => {template.to_sym => member}
                                )
                     )
      end.join("\n")
    else
      haml(template, options)
    end
  end
end

class TaskList < ActiveRecord::Base
  attr_accessible :list_name

  has_many :tasks, :dependent => :destroy

  validates :list_name,  :presence => true,
            :uniqueness => { :case_sensitive => false }
end

class Task < ActiveRecord::Base
  attr_accessible :task

  belongs_to :task_list

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
