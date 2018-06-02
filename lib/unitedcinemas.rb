class Unitedcinemas
    def self.getuc()
        #unitedcinemas から 劇場URLを抜いて開く
        require 'open-uri'
        require 'nokogiri'
        require 'rexml/document'

        adb = AccessDatabase.new

        #unitedCinemas一覧
        url = 'http://www.unitedcinemas.jp/index.html'
        
        begin
            charset = nil
            html = open(url) do |f|
                charset = f.charset
                f.read
            end
            #Nokogiri::HTML::Documentを取得
            doc = Nokogiri::HTML.parse(html, nil, charset)
            s = doc.css('#theaterList > li') 
        rescue
            p "unitedcinemas theaterList error"
            return
        end
        unitedcinemas = []
        #シアターリストからURLを取得して各劇場の上映スケジュールURLに変換したうえでunitedcinemas[]に追加
        for i in 0..50
            begin
                urll = "http://www.unitedcinemas.jp"
                urll << (s.css("a")[i][:href]).to_s
                urll << "daily.php"
                urll.slice!(/index.html/)
                unitedcinemas.push(urll)
            rescue
                next
            end
        end

        for url in unitedcinemas
            begin
                charset = nil
                html = open(url) do |f|
                    charset = f.charset
                    f.read
                end
                doc = Nokogiri::HTML.parse(html, nil, charset)
                theaterName = doc.xpath("//*[@id=\"top\"]/header/h1/a/img")
            p theaterName[0].get_attribute("alt")
            p url
                
                #映画館の情報をデータベースに追加
                #tid is theaterid
                tid = adb.addTheater(theaterName[0].get_attribute("alt"),url)
                p "tid:#{tid}"
                #上映される映画の情報を取得
                s = doc.css('.movieTitle').text
                s.strip!
                s.gsub!(/\u{C2A0}/)
                s = s.delete("\t").delete(" ").strip.chomp.split("\n")
                s.delete("")
                s.each do |str|
                    dub =  str.include?("字幕") ? "true":"false"
                    imax =  str.include?("IMAX") ? "true":"false"
                    td =  str.include?("3D") ? "true":"false"
                    fd =  str.include?("4DX") ? "true":"false"
                    adb.addMovie(tid,str,dub,imax,td,fd)
                end
            rescue => e
                p e.message
                next
            end
        end
    end
end