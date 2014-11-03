class SuitesController < ApplicationController
  def index
    @suites = Suite.last(200)
  end
  
  def show
    @suite = Suite.find( params[:id] )
        
    @worlds = World.includes(:runs).joins( :runs =>
                                            {:results => [:test_definition]}
                                         ).where( :test_definitions =>
                                                   {:suite_id => @suite.id}
                                           ).distinct.order(:id => :desc).limit(200)
    
  end
end
