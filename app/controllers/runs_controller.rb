class RunsController < ApplicationController
  def show
    @run = Run.includes(:top_level_results => [
                          :test_definition,
                          :children => [
                            :test_definition,
                            :children => [
                              :test_definition,
                              :children => [
                                :children
                                ]]]]).find(params[:id])
  end
end
