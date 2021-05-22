class ScreenshotController < ApplicationController
  #------------スクショのタグ一覧取得--------------------------#-----------------------------------------------------------
  def tag_index
    
    @screenshot_tags = Tag.where(tag_type: 1)
    @tags_array = []
    @screenshot_tags.each do |screenshot_tag|
      @tags_array << screenshot_tag.as_json 
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
      response_bad_request  #application_controller.rb
    else
      
      
      
      @screenshots_array = []
      if params[:tag] #ーーーーーータグ指定ありーーーーーーー
        # byebug
        
        #タグ絞り込み　＆　全件取得　このidとmain_tagを下で使う
        @screenshots = ScreenShot.eager_load(:tags)   
        .where(tags: {slug: params[:tag]})
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @screenshots.each do|screenshot|
          tags_with_userflow = ScreenShot
          .preload(:tags, :user_flow)
          .find_by(id: screenshot.id)     #hash1 所有タグ一覧
          
          @main_tag = tags_with_userflow.tags.find_by(id: screenshot.maintag_id).as_json(root: "main_tag") 
          @userflow = screenshot.user_flow.as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}],root:"userflow")
          screenshot_with_userflow = screenshot.as_json.merge(@userflow)      #hash merge
          screenshot_with_userflow_and_main_tag = screenshot_with_userflow.as_json(root:"screenshot").merge(@main_tag.as_json)      #hash merge
          
          
          all_tags = tags_with_userflow.tags.as_json #hash2
          tags_hash = {tags: all_tags}
          hash = screenshot_with_userflow_and_main_tag.merge(tags_hash)
          
          if @screenshots.count != 1 #screenshotが複数ある場合、配列に入れる
            @screenshots_array << hash
          else
            @screenshots_array = hash #一つの場合一つだけ出力
          end
        end
        
      else            #ーーーーーータグ指定なしーーーーーーー
        @screenshots = ScreenShot.preload(:tags,:user_flow)     #全件取得
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @screenshots.each do|screenshot|
          @main_tag = screenshot.tags.find_by(id: screenshot.maintag_id).as_json(root: "main_tag")
          @userflow = screenshot.user_flow.as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}],root:"userflow")
          screenshot_with_userflow = screenshot.as_json.merge(@userflow)
          screenshot_with_userflow_and_main_tag = screenshot_with_userflow.as_json.merge(@main_tag.as_json)  #hash1
          
          all_tags = screenshot.tags.as_json #hash2
          tags_hash = {tags: all_tags}
          hash = screenshot_with_userflow_and_main_tag.merge(tags_hash)  #ふたつのハッシュをmerge
          
          # byebug
          
          if @screenshots.count != 1 #screenshotが複数ある場合、配列に入れる
            @screenshots_array << hash
          else
            @screenshots_array = hash #一つの場合一つだけ出力
          end
        end
      end
      
      render json: {screenshots: @screenshots_array} 
      # render json: {screenshots: @screenshots_with_tags,userflow:@userflow_product_platform}
      
    end
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
  
  
end
