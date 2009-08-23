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

namespace :db do
  desc "Insert categories and sources."
  task(:populate  => :environment) do
    news_name = "News"
    news = Category.find_by_name(news_name)
    if not news
      news = Category.new
      news.name = news_name
      news.save!
    end
    
    bbc_name = "BBC News"
    if not Source.find_by_name(bbc_name)
      bbc = Source.new
      bbc.category = news
      bbc.name = bbc_name
      bbc.page_url = "http://news.bbc.co.uk/"
      bbc.image_regex = "src\s*=\s*[\"'](http://newsimg.bbc.co.uk/media/images/[^\"']+.jpe?g)[\"']"
      bbc.last_palette_hash = 0
      bbc.save!
    end
    
    aljazeera_name = "Al Jazeera"
    if not Source.find_by_name(aljazeera_name)
      aljazeera = Source.new
      aljazeera.category = news
      aljazeera.name = aljazeera_name
      aljazeera.page_url = "http://english.aljazeera.net/"
      aljazeera.image_regex = "src\s*=\s*[\"'](/mritems/Images/[^\"']+.jpe?g)[\"']"
      aljazeera.last_palette_hash = 0
      aljazeera.save!
    end
    
    cnn_name = "CNN"
    if not Source.find_by_name(cnn_name)
      cnn = Source.new
      cnn.category = news
      cnn.name = cnn_name
      cnn.page_url = "http://www.cnn.com/"
      cnn.image_regex = "src\s*=\s*[\"']([^\"']+cnn[^\"']+.jpe?g)[\"']"
      cnn.last_palette_hash = 0
      cnn.save!
    end
    
    times_name = "The Times Of India"
    if not Source.find_by_name(times_name)
      times = Source.new
      times.category = news
      times.name = times_name
      times.page_url = "http://timesofindia.indiatimes.com/"
      times.image_regex = "style=[\"']display:none[\"']\s+src\s*=\s*[\"'](/photo/[^\"']+.cms)[\"']"
        times.last_palette_hash = 0
      times.save!
    end
    
    tass_name = "ITAR-TASS"
    if not Source.find_by_name(tass_name)
      tass = Source.new
      tass.category = news
      tass.name = tass_name
      tass.page_url = "http://www.itar-tass.com/"
      tass.image_regex = "hspace[^>]+vspace[^>]+src\s*=\s*[\"'](http://www.itar-tass.com/img/[^\"']+.jpe?g)[\"']"
      tass.last_palette_hash = 0
      tass.save!
    end
    
    # Xinhua's front page is too hard to parse
    xinhua_name = "China News Service"
    if not Source.find_by_name(xinhua_name)
      xinhua = Source.new
      xinhua.category = news
      xinhua.name = xinhua_name 
      xinhua.page_url = "http://www.chinanews.com.cn/"
      xinhua.image_regex = "pics\s*=\s*[\"']([^\"']+?.jpe?g)"
      xinhua.last_palette_hash = 0
      xinhua.save!
    end
  end
end
