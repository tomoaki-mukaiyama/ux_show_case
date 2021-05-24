class UserFlowController < ApplicationController

  #------------tag_typeの値が1のタグ一覧--------------------------#-----------------------------------------------------------
  
  def tag_index
    
    @tags = Tag.where(tag_type: 0)
    @tags_array = []
    @tags.each do |tag|
        @tags_array << tag.as_json
    end
    render json: { tags: @tags_array }
  end
  #------------isTopが１のタグ一覧--------------------------#-----------------------------------------------------------
  
  def tag_top
    @tags = Tag.where(isTop: 1,tag_type: 0)
    @tags_array = []
    @tags.each do |tag|
        @tags_array << tag.as_json
    end
    render json: { tags: @tags_array }
  end
  
  #------------isRecommendが１のタグ一覧--------------------------#-----------------------------------------------------------
  
  def tag_recommend
    @tags = Tag.where(isRecommend: 1,tag_type: 0)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json
    end
    render json: { tags: @tags_array }
  end
  #------------指定したタグ一件--------------------------#-----------------------------------------------------------
  def flowtag

    @tag = Tag.where(slug: params[:flowtag])[0]
    render json: { tag: @tag }
  end
  
  #------------最新のuserflow(動画)取得----------------#-----------------------------------------------------------
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
      response_bad_request #(application_controller.rb)
    else
      
      #全動画を最新順取得＆limit&page指定 => @userflowsに代入
      
      
      @userflows_array = []
      if params[:tag] #ーーーーーータグ指定ありーーーーーーー
        
        @userflows = UserFlow.eager_load(:tags)   #タグ絞り込み　＆　全件取得
        .where(tags: {slug: params[:tag]})
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        # byebug
        @userflows.each do|userflow|
          hash = UserFlow
          .preload(:tags, :product, :platform)
          .find_by(id: userflow.id)
          .as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags])     #hash1 所有タグ一覧
          maintag = userflow.tags.find_by(id: userflow.maintag_id).as_json(root:"maintag")
          hash = hash.merge(maintag)

          if @userflows.count != 1 #userflowが複数ある場合、配列に入れる
            @userflows_array <<  hash
          else
            @userflows_array =  hash #一つの場合一つだけ出力
          end
        end
      else            #ーーーーーータグ指定なしーーーーーーー
        @userflows = UserFlow.preload(:tags, :product, :platform)
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @userflows.each do|userflow|
          hash = userflow.as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags])
          maintag = userflow.tags.find_by(id: userflow.maintag_id).as_json(root:"maintag")
          hash = hash.merge(maintag)

          if @userflows.count != 1 #userflowが複数ある場合、配列に入れる
            @userflows_array << hash
          else
            @userflows_array = hash #一つの場合一つだけ出力
          end
        end
        
      end
      
      render json: {userflows: @userflows_array}
      
    end
    
  end
  
  #------------動画詳細ページ取得----------------------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag] userflow動画の詳細ページ 最新の１件
  
  def detail
    @target_userflow = UserFlow
    .eager_load(:tags,:product,:platform)
    .where(products:{name: params[:product]},platforms:{name:params[:platform]},tags: {slug: params[:flowtag]}) 
    .order(local_version: :desc)
    .first

    if @target_userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else

      userflow_main_tag = @target_userflow.tags.find_by(id: @target_userflow.maintag_id).as_json(root:"maintag_id")

      @userflow_product_platform_flowtag = UserFlow
      .preload(:tags, :product, :platform)
      .find_by(id: @target_userflow.id)
      .as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags]) 
      
      userflow_maintag_product_platform_tags = @userflow_product_platform_flowtag.merge(userflow_main_tag)

      render json: {userflow: userflow_maintag_product_platform_tags}
      
    end
  end
  
  #------------動画のスクショ一覧取得----------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag]/screen_shot 
  def screenshot

    #絞り込みでターゲットのidを取得 #eager_loadではスクショのタグを芋づる取得できない為、そのidでpreloadでfind_byする
    @target_userflow = UserFlow
    .eager_load(:tags,:product,:platform)
    .where(products:{name: params[:product]},platforms:{name:params[:platform]},tags: {slug: params[:flowtag]}) 
    .order(local_version: :desc)
    .first

    if @target_userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else
      @userflow = UserFlow
      .preload(:screen_shots, :product, :platform)
      .find_by(id: @target_userflow.id)
      
      userflow_main_tag = @target_userflow.tags.find_by(id: @target_userflow.maintag_id).as_json(root:"maintag_id")
      userflow_product_platform = @userflow.as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}])
      
      userflow_product_platform_main_tag = userflow_product_platform.merge(userflow_main_tag)
      
      @screenshots = @userflow.screen_shots.as_json(include: :tags)
      screenshot_main_tag = []
      @userflow.screen_shots.each {|n|screenshot_main_tag << n.tags.find_by(id: n.maintag_id)}
      
      @screenshots_with_tags = []
      @screenshots.each do|shots|
        @screenshots_with_tags << shots.merge(screenshot_main_tag[@screenshots_with_tags.count].as_json(root:"maintag_id"))
      end 
      screenshots_hash = {screenshots: @screenshots_with_tags}
      userflow_product_platform_screenshots_main_tag = userflow_product_platform_main_tag.merge(screenshots_hash)
      render json: {userflow:userflow_product_platform_screenshots_main_tag}
      
    end
    
  end
  #------------当該プロダクトの他の動画取得-------------------#-----------------------------------------------------------
  # /userflow/[product]/ プロダクトの他の動画一覧
  def product_userflow
    userflows = UserFlow
    .eager_load(:product, :platform, :tags)
    .where(products: {name: params[:product]})
    
    main_tag = []
    userflows.each do |userflow|
      main_tag << userflow.tags.find_by(id: userflow.maintag_id)
    end
    
    array = []
    userflows_tags = userflows.as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}, :tags])
    userflows_tags.each do |userflow|
      array << userflow.merge(main_tag[array.count].as_json(root:"maintag_id"))
    end
    

    render json: {userflow: array}
    
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
end

          # byebug
