class CreateColours < ActiveRecord::Migration
  def self.up
    create_table :colours do |t|
      t.references :palette
      t.integer :red
      t.integer :green
      t.integer :blue

      t.timestamps
    end
  end

  def self.down
    drop_table :colours
  end
end
