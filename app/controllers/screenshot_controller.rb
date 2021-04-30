class ScreenshotController < ApplicationController
  #------------スクショのタグ一覧取得--------------------------#-----------------------------------------------------------
  def tag_index

    @screenshot_tags = Tag.where(tag_type: 0)
    @tags_array = []
    @screenshot_tags.each do |screenshot_tag|
      @tags_array << screenshot_tag.as_json(only:[:name])
    end
    render json: {screenshot_tags: @tags_array}
  end
  #------------最新のscreenshot取得----------------------------#-----------------------------------------------------------
  def latest
    if params[:limit] == 0.to_s       #limit=0を1として扱う
      page_size = params[:limit].to_i + 1
    else
      page_size = params[:limit].to_i
    end

    if params[:page] == 0.to_s        #page=0を1として扱う
      page_num  = params[:page].to_i
     else
      page_num  = params[:page].to_i - 1
    end

    if params[:page].to_s.empty? || params[:limit].to_s.empty? #pageとlimitのリクエスト不備の場合エラーを返す
      response_bad_request  #エラーメソッド(application_controller.rb)
    else
    # byebug

        #全スクショ最新順取得＆limit&page指定 => @screenshotsに代入
        @screenshots = ScreenShot.includes(:tags)
                                .order(created_at: :desc)
                                .limit(page_size)
                                .offset(page_num * page_size)
        
        @screenshots_array = []

        if params[:tag] #タグ指定あり
        @screenshots = @screenshots.where(tags:{id:params[:tag]}) #指定タグで絞る
          @screenshots.each do|s|
            @screenshots_array << s.as_json(only:[:path],include:{tags: {only: :name}}) #配列に入れる
          end
        else            #タグ指定なし
          @screenshots.each do|s|
            @screenshots_array << s.as_json(only:[:path],include:{tags: {only: :name}}) #配列に入れる
          end
        end
        
        render json: {screenshots: @screenshots_array} 

    end
  end
  #-----------------------------------------------------------#-----------------------------------------------------------


end
