class CreateTaskLists < ActiveRecord::Migration
  def self.up
    create_table :task_lists do |t|
      t.string :list_name
    end
    add_index :task_lists, :list_name
  end

  def self.down
    drop_table :task_lists
  end
end
