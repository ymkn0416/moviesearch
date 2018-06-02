class IndexController < ApplicationController
    def index
    end
  
    def serch
      if params[:title].nil?
        redirect_to :action => "index"
      else
        title = params[:title]
        dub = params[:dub][:type] =="1" ? true : false
        imax = params[:imax][:type] =="1" ? true : false
        td = params[:td][:type] =="1" ? true : false
        fd = params[:fd][:type] =="1" ? true : false
        p "#{title},#{dub},#{imax},#{td},#{fd}"
        @movies = Movie.where('title LIKE ?', "%" + title + "%").where('dub = ?',dub).where('imax = ?',imax).where('threeD = ?',td).where('fourDx = ?',fd).limit(50)
        p @movies
        @url
      end
    end
  end
  