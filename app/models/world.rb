class World < ActiveRecord::Base
  before_create :generate_name
  
  has_many :runs

  private
    def generate_name
      begin
        raise "No internet"
        url = URI.parse("http://www.buckhurst.org")
        res = Net::HTTP.start(url.host, url.port) do |http|
          http.get("/randomtext")
        end
        self.name = res.body
      rescue
        self.name = "world_" + rand(100000).to_s
      end
    end
end
