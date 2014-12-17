xml.rss :version => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
  	xml.title @podcast.title
  	xml.description @podcast.description
  	xml.lastBuildDate @podcast.date

  	xml.itunes :summary, @podcast.description
    xml.itunes :explicit, "clean"

    @podcast.documents.each do |document|
      cast = document.casts.first
      next if cast.nil?

      xml.item do
        xml.title document.title
        xml.author document.author.name

        unless document.tags.empty?
          xml.itunes :keywords, document.tags.join(",")
          document.tags.each do |category|
            xml.category category
          end
        end

        xml.description document.description

        xml.itunes :summary, document.description
        xml.itunes :duration, document.length
        xml.itunes :explicit, "no"

        cast_url = url_for(:controller => 'casts', :action => 'play', :name => cast.name, :only_path => false) + ".mp3"
        xml.enclosure :url => cast_url, :length => cast.size, :type => "audio/mpeg"
        xml.guid cast_url
        xml.pubDate document.updated_at.to_formatted_s(:rfc822)
      end
    end
  end
end
