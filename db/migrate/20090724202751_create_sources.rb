class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :name
      t.references :category
      t.string :page_url
      t.string :image_regex
      t.integer :last_palette_hash

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
