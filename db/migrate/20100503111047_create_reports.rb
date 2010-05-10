class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :user_id
      t.integer :service_id
      t.integer :week
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
