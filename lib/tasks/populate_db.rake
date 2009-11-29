# populate_db.rake - The Colour Of.
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

def ensure_category(name)
  category = Category.find_by_name(name)
  if not category
    category = Category.new
    category.name = name
    category.save!
  end
  category
end

def ensure_source(category, name, url, prefix, regex)
  source = Source.find_by_name(name) 
  if not source
    source = Source.new
  end
  source.category = category
  source.name = name
  source.page_url = url
  source.image_regex = regex
  source.image_url_prefix = prefix
  # Keep the hash if updating
  #source.last_palette_hash = 0
  source.save!
  source
end

namespace :db do
  desc "Insert categories and sources."
  task(:populate  => :environment) do
    
    # News
    
    news = ensure_category("News")
    
    ensure_source(news,
                  "BBC News",
                  "http://news.bbc.co.uk/",
                  "",
                  "src\s*=\s*[\"'](http://newsimg.bbc.co.uk/media/images/[^\"']+.jpe?g)[\"']")
    
    ensure_source(news,
                  "Al Jazeera",
                  "http://english.aljazeera.net/",
                  "http://english.aljazeera.net/",
                  "src\s*=\s*[\"'](/mritems/Images/[^\"']+.jpe?g)[\"']")
                  
    ensure_source(news,
                  "CNN", "http://www.cnn.com/",
                  "",
                  "src\s*=\s*[\"']([^\"']*/photo/[^\"']+.cms)[\"']\s+id=\s*\"showcaseimg1\"")
    
    ensure_source(news, 
                  "Indiatimes",
                  "http://www.indiatimes.com/",
                  "",
                  "style=[\"']display:none[\"']\s+src\s*=\s*[\"'](/photo/[^\"']+.cms)[\"']")
    
    ensure_source(news,
                  "ITAR-TASS", "http://www.itar-tass.com/",
                  "",
                  "hspace[^>]+vspace[^>]+src\s*=\s*[\"'](http://www.itar-tass.com/img/[^\"']+.jpe?g)[\"']")
    
    # Xinhua's front page is too hard to parse
    ensure_source(news,
                  "China News Service",
                  "http://www.chinanews.com.cn/",
                  "http://www.chinanews.com.cn/",
                  "pics\s*=\s*[\"']([^\"']+?.jpe?g)")

    # Art
    
    art = ensure_category("Art")

# Weird, we seem to be blocked when using the Ruby url lib    
#    ensure_source(art,
#                  "NewsGrist",
#                  "http://newsgrist.typepad.com/",
#                  "",
#                  "<div class=\"entry-body\">.*?src="[^]"")
    
    ensure_source(art,
                  "Art Fag City",
                  "http://www.artfagcity.com/",
                  "",
                  "src=\"(http://www.artfagcity.com/wordpress_core/wp-content/uploads/[^/]+/[^\"]+)\"")
    
    ensure_source(art,
                  "Furtherfield",
                  "http://www.furtherfield.org/",
                  "",
                  "<div\s+id\s*=\s*['\"]review_image['\"]><img[^>]+src=['\"]([^'\"]+)\['\"]")
    
    ensure_source(art,
                  "Frieze",
                  "http://frieze.com/",
                  "",
                  "<a href=\"/magazine/\"><img src=\"http://www.frieze.com/images/middle/[^\"]+\"")
    
    ensure_source(art,
                  "We Make Money Not Art",
                  "http://www.we-make-money-not-art.com/",
                  "http://www.we-make-money-not-art.com/",
                  "src=\"(wow/[^\"]+)\"")
    
    # No non-js images
    ensure_source(art,
                  "The Tate",
                  "http://tate.org.uk/homepage/tateonlinehomepageannouncement.xml", 
                  "http://tate.org.uk/",
                  ">/([^<]+\.(jpg|png))<")

    # Only gallery in London we can scrape. Tate, ica, saatchi all fail
    ensure_source(art,
                  "Whitechapel Gallery",
                  "http://www.whitechapelgallery.org/home",
                  "http://www.whitechapelgallery.org/",
                  "url\\(['\"](/images/plinth_advert/[^'\"]+)['\"']\\)")
    # Technology
    
    technology = ensure_category("Technology")
    
    ensure_source(technology,
                  "Wired",
                  "http://www.wired.com/",
                  "http://www.wired.com/",
                  "src=\"/(images/index/..../../[^\"]+)\"")
    
    ensure_source(technology,
                  "Apple",
                  "http://www.apple.com/",
                  "",
                  "#billboard[^\\(]+url\\(([^)]+)\\)")
    
    ensure_source(technology,
                  "Microsoft",
                  # We won't get here automatically as the redirect is in html
                  "http://www.microsoft.com/en/us/default.aspx",
                  "",
                  "(http://i.microsoft.com/global/En/us/PublishingImages/SLWindowPane/[^\"]+\.jpg)")
   
    ensure_source(technology, 
                  "Gizmodo", 
                  "http://gizmodo.com/", 
                  "", 
                  "src=\"([^\"]+/images/[^\"]+\.jpg)\"")
    
    ensure_source(technology, 
                  "TechCrunch", 
                  "http://www.techcrunch.com/", 
                  "", 
                  "src=\"(http://[^\"]+/wp-content/uploads/[^\"]+)\"")

    # Use the rss feed    
    ensure_source(technology, 
                  "Make Magazine", 
                  "http://blog.makezine.com/index.xml",
                  "", 
                  "img[^>]+src=\"([^\"]+)\"")
    
    # Music
    
    music = ensure_category("Music")
    
    ensure_source(music,
                  "The NME",
                  "http://www.nme.com/home",
                  "",
                  "src=\"([^\"]+/images/thumbnail/[^\"]+)\"")
    
    ensure_source(music,
                  "The Quietus",
                  "http://thequietus.com/",
                  "",
                  "src=\"(http://new.assets.thequietus.com/images/articles/[^\"]+)\"")
    
    ensure_source(music,
                  "Pitchfork Media",
                  "http://pitchfork.com/",
                  "",
                  "src=\"(http://cdn\.pitchfork\.com/media/[^\"]+.jpg)\"")
    
    ensure_source(music,
                  "Billboard 200",
                  "http://www.billboard.com/charts/billboard-200",
                  "",
                  "src=\"(http://www\.billboard\.com/images/[^\"]+)\"")
    
    ensure_source(music,
                  "iTunes",
                  "http://www.apple.com/itunes/charts/songs/",
                  "",
                  "src=\"([^\"]+/Music/[^\"]+\.jpg)\"")
    
    ensure_source(music,
                  "The Wire",
                  "http://www.thewire.co.uk/articles/web_exclusive/",
                  "http://www.thewire.co.uk/",
                  "src=\"/(images/the_wire/[^\"]+)\"")
    
    # Dot Coms
    
    dotcoms = ensure_category("Dot Coms")
    
    ensure_source(dotcoms,
                  "Google",
                  "http://www.google.co.uk/",
                  "http://www.google.com/",
                  "img alt=\"Google\".+?src=\"/([^\"]+)\"")
    
    ensure_source(dotcoms,
                  "Yahoo!",
                  "http://m.uk.yahoo.com/?p=us",
                  "",
                  "src=\"([^\"]+yimg[^\"]+\.jpg)\" alt=")
    
    ensure_source(dotcoms,
                  "MySpace",
                  "http://www.myspace.com/",
                  "",
                  "img[^>]+src=\"([^\"]+)\"")
    
    # Use the bestsellers, as they are easier to grab and change more often
    ensure_source(dotcoms,
                  "Amazon",
                  "http://www.amazon.com/bestsellers",
                  "",
                  "img\s+class\s*=\s*\"prodImage\"\s+src\s*=\s*\"([^\"]+)\"")
    
    # The deals page is easier to scrape
    ensure_source(dotcoms,
                  "eBay",
                  "http://deals.ebay.com/",
                  "",
                  "src=\"([^\"]+ebayimg[^\"]+)\"")
        
  end
end
