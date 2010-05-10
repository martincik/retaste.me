class CreateEmailHistory < ActiveRecord::Migration
  def self.up
    create_table :email_histories do |t|
      t.string :from, :to
      t.integer :last_send_attempt, :default => 0
      t.text :mail
      t.datetime :sent_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :email_histories
  end
end
