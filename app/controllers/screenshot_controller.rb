class ScreenshotController < ApplicationController
  #------------スクショのタグ一覧取得----------------
  def tag_index

    @screenshot_tags = Tag.where(tag_type: 0)
    @tags_array = []
    @screenshot_tags.each do |screenshot_tag|
      @tags_array << screenshot_tag.as_json(only:[:name])
    end
    render json: {screenshot_tags: @tags_array}
  end
  
  #------------最新のscreenshotを取得----------------
  def latest
    @screenshots_array = []
    @screenshots = ScreenShot.includes(:tags).order(created_at: :desc)
    @screenshots.each{|s|@screenshots_array << s.as_json(only:[:path],include:{tags: {only: :name}})}
    
    # byebug
    
    # s.as_json(only:[:path],include:{tags: {only: :name}})
    #↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    # {"path"=>"test/path1", "tags"=>[{"name"=>"test_name_1"}]}
    
    render json: {screenshots: @screenshots_array}
    
  end
end
