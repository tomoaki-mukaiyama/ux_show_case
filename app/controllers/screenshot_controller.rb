class ScreenshotController < ApplicationController
  def tag_index
    @screenshot_tags = ScreenShotTag.all
    @tags_array = []
    @screenshot_tags.each do |screenshot_tag|
      @tags_array << screenshot_tag.as_json(only:[:id, :screen_shot_id, :tag_id])
    end
    render json: {screenshot_tags: @tags_array}
  end
end
