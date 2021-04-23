class UserFlowController < ApplicationController
  def index
    render json: {title: 'uxshowcase'}
  end
end
