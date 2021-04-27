class ScreenshotController < ApplicationController
  def tag_index
    @screenshot_tags = Tag.where(IsFlowTag: 0)
    @tags_array = []
    @screenshot_tags.each do |screenshot_tag|
      @tags_array << screenshot_tag.as_json(only:[:name])
    end
    render json: {screenshot_tags: @tags_array}
  end
end
