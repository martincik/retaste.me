class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :type
      t.string :user_id
      
      t.string :login
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
