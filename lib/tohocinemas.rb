class Tohocinemas
    def self.gettc()
        #TOHOcinemas から 劇場URLを抜いて開く

        require 'open-uri'
        require 'nokogiri'
        require 'rexml/document'

        require 'date'
        today = Date.today.to_time.to_s.delete("-").slice(0..7)

        adb = AccessDatabase.new

        url = 'https://www.tohotheater.jp/theater/find.html'
        
        begin
            charset = nil
            html = open(url) do |f|
            charset = f.charset # 文字種別を取得
            f.read # htmlを読み込んで変数htmlに渡す
            end
            doc = Nokogiri::HTML.parse(html, nil, charset)
            s = doc.css('.item > a')
        rescue
            p "TOHOcinemas theaterList error"
            return
        end
        
        theaterIds = []
        urls = []
        for i in 0..38
            turl = ""
            tname = ""
            begin
                urll = "https://hlo.tohotheater.jp"
                urll << (s.css("a")[i][:href]).to_s #"/net/schedule/049/TNPI2000J01.do"
                turl = urll
                theaterCode = urll.slice(40..42) #049
                urll = urll.slice(0..43) #"https://hlo.tohotheater.jp/net/schedule/049/"
                urll << "TNPI2160J01.do"
                urll << "?site_cd=#{theaterCode}&show_day=#{today}"
                
                
                name = (s.css("a > span")[i].text)
                name = name.split("C")
                mozisu = name[0].length
                name = name[0]
                name.slice!(mozisu-5,40) #劇場名から余計な部分を消去
                tname = name
                urls.push(urll)
            rescue
                next
            end
            tid = adb.addTheater(tname,turl)
            theaterIds.push(tid)
        end
        #URL "https://hlo.tohotheater.jp/net/schedule/049/TNPI2160J01.do?site_cd=049&show_day=20180529"
        j = -1;
        for url in urls
            begin
            j+=1;
            html = open(url) do |f|
                f.read # htmlを読み込んで変数htmlに渡す
            end
                doc = Nokogiri::HTML.parse(html, nil, charset)
            for i in 0..50
                title = doc.css('.movie-box > h4')[i].inner_text
                dub =  title.include?("字幕") ? "true":"false"
                imax =  title.include?("ＩＭＡＸ") ? "true":"false"
                td =  title.include?("３Ｄ") ? "true":"false"
                fd =  title.include?("ＭＸ４Ｄ") ? "true":"false"
                p "#{theaterIds[j]},#{title},#{dub},#{imax},#{td},#{fd}"
                adb.addMovie(theaterIds[j],title,dub,imax,td,fd)
            end
            rescue => e
                p e.message
                next
            end
        end
    end
end