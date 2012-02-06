require "sinatra"
require "sinatra/activerecord"

# Render the page once:
# Usage: partial :foo
# 
# foo will be rendered once for each element in the array, passing in a local variable named "foo"
# Usage: partial :foo, :collection => @my_foos
## Pulled from the Sinatra docs

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
  attr_accessible :name, :task_list_id, :completed_at
  
  belongs_to :task_list
  
  validates :name,  :presence => true,
            :uniqueness => { :case_sensitive => false }
  validates :task_list_id, :presence => true
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
  @tasks = Task.where(:task_list_id => params[:id])
  @title = "#{task_list.list_name} | Bitfyre's Todos"
  haml :'lists/list'
end

post '/tasks/?' do
  @task = Task.create(params['task'])
  redirect to("/lists/#{@task.task_list_id}")
end

put '/tasks/:id' do
  task = Task.find(params[:id])
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to("/lists/#{task.task_list_id}")
end

delete '/tasks/:id' do
  task = Task.find(params[:id])
  task.destroy
  redirect to("/lists/#{task.task_list_id}")
end
