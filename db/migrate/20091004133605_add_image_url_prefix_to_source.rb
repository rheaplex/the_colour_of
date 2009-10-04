class AddImageUrlPrefixToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :image_url_prefix, :string
  end

  def self.down
    remove_column :sources, :image_url_prefix
  end
end
