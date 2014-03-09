class World < ActiveRecord::Base
  before_create :generate_name
  
  has_many :runs

  private
    def generate_name
      begin
        url = URI.parse("http://www.buckhurst.org")
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.get("/randomtext")
        end
        self.name = res.body
      rescue
        self.name = "world_" + rand(100000)
      end
    end
end
