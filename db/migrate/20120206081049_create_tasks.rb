class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.references :task_list
      t.datetime :completed_at
    end
  end

  def self.down
    drop_table :tasks
  end
end
