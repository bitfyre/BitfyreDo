class CreateTaskList < ActiveRecord::Migration
  def self.up
    create_table :task_list do |t|
      t.string :list_name
    end
    add_index :task_list, :list_name
  end

  def self.down
    drop_table :task_list
  end
end
