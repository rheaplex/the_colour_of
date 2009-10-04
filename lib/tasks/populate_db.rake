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
                  "src\s*=\s*[\"']([^\"']+cnn[^\"']+.jpe?g)[\"']")
    
    ensure_source(news, 
                  "The Times Of India",
                  "http://timesofindia.indiatimes.com/",
                  "http://timesofindia.indiatimes.com/",
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
    
    ensure_source(art,
                  "NewsGrist",
                  "http://newsgrist.typepad.com/",
                  "",
                  "src=\"(http://newsgrist.typepad.com/.a/[^\"]+)\"")
    
    ensure_source(art,
                  "Art Fag City",
                  "http://www.artfagcity.com/",
                  "",
                  "src=\"(http://www.artfagcity.com/wordpress_core/wp-content/uploads/[^/]+/[^\"]+)\"")
    
    ensure_source(art,
                  "Furtherfield",
                  "http://www.furtherfield.org/",
                  "",
                  "src=['\"](http://www.furtherfield.org/pics/[^'\"]+)['\"]")
    
    ensure_source(art,
                  "Frieze",
                  "http://frieze.com/magazine/",
                  "http://frieze.com/",
                  "src=\"/(images/front/[^\"]+)\"")
    
    ensure_source(art,
                  "We Make Money Not Art",
                  "http://www.we-make-money-not-art.com/",
                  "http://www.we-make-money-not-art.com/",
                  "src=\"(wow/[^\"]+)\"")
    
    # Grab images from the feed, not the page
    ensure_source(art,
                  "The Tate",
                  "http://tate.org.uk/homepage/tateonlinehomepageannouncement.xml", 
                  "http://tate.org.uk/",
                  ">/([^<]+\.(jpg|png))<")

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
                  "src=\"(http://images.apple.com/home/images/[^\"]+)\"")
    
    ensure_source(technology,
                  "Microsoft",
                  # We won't get here automatically as the redirect is in html
                  "http://www.microsoft.com/en/us/default.aspx",
                  "",
                  "(http://i.microsoft.com/global/En/us/PublishingImages/SLWindowPane/[^\"]+)")
    
    #ensure_source(technology, "", "", "")
    
    #ensure_source(technology, "", "", "")
    
    #ensure_source(technology, "", "", "")
    
  end
end
