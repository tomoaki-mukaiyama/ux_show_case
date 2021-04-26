class UserFlowController < ApplicationController
  def title
    render json: {title: 'uxshowcase'}
  end

  def tag_index
    @tags = Tag.all
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
    end

  render json: { tags: @tags_array }
  end

end