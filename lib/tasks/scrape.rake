# scrape.rake - The Colour Of.
# Copyright 2009 Rob Myers <rob@robmyers.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygems'
require 'rio'
require 'RMagick'

# So we have access to RMagick constants
include Magick

# Cron task, set correct app path and database
# */1 0 * * * cd /path/to/rails_app/ && /usr/local/bin/rake RAILS_ENV=debug scrape:scrape


class SourceUpdater
  
  def initialize(source)
    @source = source
  end
  
  def url_from_page()
    html = rio(@source.page_url).binmode.read
    if not html
      raise "Couldn't get html for " + @source.name
    end
    groups = html.scan(Regexp.new(@source.image_regex))
    if ((groups.length == 0) or (groups[0].length == 0))
      raise "Couldn't get image url for " + @source.name
    end
    logger.debug groups[0][0]
    url = groups[0][0]
    # If it's a server absolute url, prepend the server url
    if url.starts_with? '/'
        url = @source.page_url + url[1..-1]
    end
    url
  end

  def image_from_url(image_url)
    url_stream = rio(image_url).binmode
    if not url_stream
      raise "Couldn't get image stream for " + image_url
    end
    Magick::Image.from_blob(url_stream.read).first
  end

  def palette_from_image(original_image, max_colours)
    # See http://www.imagemagick.org/Usage/quantize/
    quantized_image = original_image.quantize(max_colours, RGBColorspace, 1) # NoDitherMethod is 1, but undefined on Debian
    if not quantized_image
      raise "Couldn't quantize image " + @source.name
    end
    colour_row = quantized_image.unique_colors
    if ((not quantized_image) or (colour_row.columns == 0))
      raise "Couldn't get unique image colours for " + @source.name
    end
    colours = []
    colour_row.columns.times do |x|
      colours << colour_row.pixel_color(x, 0)
    end
    colours
  end

  def hash_changed?(hash)
    result = false
    if(hash != @source.last_palette_hash)
      result = true
      logger.debug "Changed"
    else
      logger.debug "Not changed"
    end
    return result
  end
  
  def update_hash(hash)
    if(hash != @source.last_palette_hash)
      @source.last_palette_hash = hash
      @source.save!
    end
  end

  def insert_colours(palette, colours)
    quantum = 255.0 / QuantumRange
    colours.each do |c|
      colour = Colour.new
      colour.palette = palette
      colour.red = c.red * quantum
      colour.green = c.green * quantum
      colour.blue = c.blue * quantum
      colour.save!
    end
  end

  def insert_palette(colours, hash)
    palette = Palette.new
      # Called on transaction but affects all db calls
        palette.source_id = @source.id
        palette.save!
        insert_colours(palette, colours)
  end

  def update()
    url = url_from_page
    image = image_from_url(url)
    colours = palette_from_image(image, 12)
    hash = url.hash
    if(hash_changed?(hash)) 
      insert_palette(colours, hash)
      update_hash(hash)
    end
  end
  
end
  
namespace :scrape do
  desc "Check web images and get palettes of any new ones."
  # => :environment gives us access to the rails environment, 
  #   including our ActiveRecord subclasses
  task(:scrape  => :environment) do
    Category.find(:all).each do |category|
      Source.find(:all, :conditions => "category_id = '#{category.id}'").each do |source|
        updater = SourceUpdater.new(source) 
        begin
          source.transaction do
            updater.update()
          end
        rescue ActiveRecord::RecordInvalid => invalid
          message = "Transaction failed" + invalid + "\n"
          # Write to error log file
          logger.error message
          # Write to stdout so cron emails the error
          print message
        end
      end
    end
  end
end
