class Aeoncinemas
    def hankakuToZenkaku (str)
        require 'nkf' 
        zenkakuTitle = NKF.nkf("-Xw",str)
        return zenkakuTitle
    end
    def self.getac()
        #イオンシネマ
        require 'open-uri'
        require 'nokogiri'
        require 'rexml/document'
        require 'nkf' 
        adb = AccessDatabase.new


        url = 'http://www.aeoncinema.com/theater/'

        charset = "utf8"
            html = open(url) do |f|
            f.read # htmlを読み込んで変数htmlに渡す
        end

        # htmlをパース(解析)してオブジェクトを生成
        doc = Nokogiri::HTML.parse(html, nil, charset)
        s = doc.css('dl > dd')
        urls = []
        theaterIds = []
        for i in 0..100
                begin
                turl = "http://cinema.aeoncinema.com/wm/" 
                tname = "イオンシネマ #{s.css("a")[i].inner_text}"
                aaa  = (s.css("a")[i][:href].to_s).slice(8..50)
                turl << aaa.to_s
                
                p tname
                p turl
                tid = adb.addTheater(tname,turl)
                theaterIds.push(tid)
                urls.push(turl)
            rescue => e
                p e.message
                next
            end
        end

        for url in urls
            begin
                charset = "utf8"
                html = open(url) do |f|
                    #charset = f.charset
                    f.read # htmlを読み込んで変数htmlに渡す
                end

                doc = Nokogiri::HTML.parse(html, nil, charset)

                j = -1
                for i in 4..50
                    j+=1

                    s = doc.xpath("//*[@id=\"SCHEDULE\"]/div[#{i}]").inner_text.delete("\n").delete("\t").delete("_").delete(",").delete(" ").split("\r")
                    s.delete("")
                    s = s[0]
                    if s.nil?
                        p "nil"
                        break
                    end
                    require 'nkf' 
                    title = NKF.nkf("-Xw --katakana",s)
                    dub =  title.include?("字幕") ? "true":"false"
                    imax =  title.include?("IMAX") ? "true":"false"
                    td =  title.include?("3Ｄ") ? "true":"false"
                    fd =  title.include?("MX4D") ? "true":"false"
                    p "#{theaterIds[j]},#{title},#{dub},#{imax},#{td},#{fd}"
                    adb.addMovie(theaterIds[j],title,dub,imax,td,fd)
                end
            rescue => e
                p "error : #{e.message}"
                next
            end
        end
    end
end
