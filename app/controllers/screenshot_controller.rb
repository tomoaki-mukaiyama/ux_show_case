class ScreenshotController < ApplicationController
  def tag_index
    #IsFlowTagの値が０のやつを全取得、json形式で配列に入れる
    @screenshot_tags = Tag.where(tag_type: 0)
    @tags_array = []
    @screenshot_tags.each do |screenshot_tag|
      @tags_array << screenshot_tag.as_json(only:[:name])
    end
    render json: {screenshot_tags: @tags_array}
  end
end
