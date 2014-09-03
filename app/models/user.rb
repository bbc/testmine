class User
  attr_accessor :name
  attr_accessor :email

  def initialize(args)
    @name = args[:name]
    @email = args[:email]
  end

  def self.find_or_create( args )
    User.new( args )
  end
end
