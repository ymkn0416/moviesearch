class ShowallController < ApplicationController
    def show
        @tdata = Theater.all
        @mdata = Movie.all
    end

    def tst
        @data = Movie.joins(:theaters)
    end
end
