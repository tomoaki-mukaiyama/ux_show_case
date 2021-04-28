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
    @tags_array = []#空の配列セット

    if params[:tag] #タグ指定ある場合

      #指定タグが付いたスクショを全件、最新順で取得
      @screenshots = ScreenShot.includes(:tags)
                               .where(tags:{id: params[:tag]})
                               .order(created_at: :desc)
    else
      @screenshots = ScreenShot.order(created_at: :desc)
    end
    
    #取得したスクショを、カラム指定してJSONとして配列に入れる
    @screenshots.each {|screenshot| @tags_array << screenshot.as_json(only:[:path])}
    
    render json: {screenshots: @tags_array}

   end
end

#byebug