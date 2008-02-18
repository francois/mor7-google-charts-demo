class PresentationController < ApplicationController
  before_filter :set_prev_next, :except => %w(index)

  def index
    redirect_to :action => "p1"
  end

  def set_prev_next
    n = params[:action].scan(/\d+/).first.to_i
    @next = {:action => "p#{n+1}"}
    @prev = {:action => "p#{n-1}"} unless n == 1
  end
end
