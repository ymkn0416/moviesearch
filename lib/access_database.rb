class AccessDatabase
    def addTheater(tname,turl)
        begin
            data = Theater.create(name:tname,url:turl)
            p "#{tname},#{turl}"
            return data.id
        rescue
            p "addTheaterError"
            return
        end
    end

    def addMovie(tid,t,d,i,td,fd)
        begin
            data = Movie.create(theater_Id:tid,title:t,dub:d,imax:i,threeD:td,fourDx:fd)
            p "#{data.id},#{tid},#{t},#{d},#{i},#{td},#{fd}"
        rescue
            p "addMovieError"
            return
        end
    end
end