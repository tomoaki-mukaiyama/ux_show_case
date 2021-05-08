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
    
    if params[:limit] == 0.to_s       #page,limit=0を1として扱う
      page_size = params[:limit].to_i + 1
    else
      page_size = params[:limit].to_i
    end
    
    if params[:page] == 0.to_s        
      page_num  = params[:page].to_i
    else
      page_num  = params[:page].to_i - 1
    end
    
    if params[:page].to_s.empty? || params[:limit].to_s.empty? #リクエスト不備の時エラーを返す
      response_bad_request  #(application_controller.rb)
    else
      
      
      
      @screenshots_array = []
      if params[:tag] #タグ指定ありーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
        @screenshots = ScreenShot.eager_load(:tags)   #タグ絞り込み　＆　全件取得
        .where(tags: {id: params[:tag]})
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @screenshots.each do|screenshot| 
          screenshot_with_tag = ScreenShot.preload(:tags).find(screenshot.id).as_json(only:[:path],include: :tags)     #hash1 所有タグ一覧    #eager_load & whereで絞ったスクショは所有タグ一覧の取得が不可な為、再呼び出し不可避
          main_tag = screenshot.tags.find_by(id: screenshot.main_tag).as_json(root: "main_tag") #hash2 メインタグ
          hash = main_tag.merge!(screenshot_with_tag)      #ふたつのハッシュをmerge
          
          if @screenshots.count != 1 #screenshotが複数ある場合、配列に入れる
            @screenshots_array << hash
          else
            @screenshots_array = hash #無い場合、そのままレンダー
          end
        end
        
      else            #タグ指定なしーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        @screenshots = ScreenShot.preload(:tags)     #全件取得
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @screenshots.each do|screenshot|
          main_tag = screenshot.tags.find(screenshot.main_tag).as_json(root: "main_tag")  #hash1
          screenshot_with_tag = screenshot.as_json(only:[:path],include: :tags) #hash2
          hash = main_tag.merge!(screenshot_with_tag)  #ふたつのハッシュをmerge
          
          if @screenshots.count != 1 #screenshotが複数ある場合、配列に入れる
            @screenshots_array << hash
          else
            @screenshots_array = hash #無い場合、そのままレンダー
          end
        end
      end             #ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
      
      render json: {screenshots: @screenshots_array} 
      
    end
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
  
  
end

# byebug