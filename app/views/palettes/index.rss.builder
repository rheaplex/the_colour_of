xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Colour Of"
    xml.description "My Fantastic Blog"
    xml.link posts_url

    for palette in @palettes
      xml.item do
        xml.title palette.id
        xml.description "Palette" + palette.id
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link palette_url(palette)
      end
    end
  end
end
