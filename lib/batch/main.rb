class Batch::Main
    def self.main
        require 'benchmark'

        result = Benchmark.realtime do
            p Theater.where("id > 0").delete_all ? "theater deleted" : "theater dont delete"
            p Movie.where("id > 0").delete_all ? "movie deleted" : "movie dont delete"
    
            Unitedcinemas.getuc()
            Tohocinemas.gettc()
            Aeoncinemas.getac()
            #Actest.tst()
        
        end
        puts "#{result}s"
    end
end