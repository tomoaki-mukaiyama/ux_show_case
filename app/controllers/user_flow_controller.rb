class UserFlowController < ApplicationController
  # def title
  #   render json: {title: 'uxshowcase'}
  # end
  #------------useflowのタグ一覧取得--------------------------#-----------------------------------------------------------
  
  def tag_index
    #tag_typeの値が1のやつ(UserFlowのタグ)を全取得
    @tags = Tag.where(tag_type: 0)
    @tags_array = []
    @tags.each do |tag|
        @tags_array << tag.as_json
    end
    render json: { tags: @tags_array }
  end
  #------------useflowのタグ isTopが１のやつ一覧取得--------------------------#-----------------------------------------------------------
  
  def tag_top
    @tags = Tag.where(isTop: 1)
    @tags_array = []
    @tags.each do |tag|
        @tags_array << tag.as_json
    end
    render json: { tags: @tags_array }
  end
  #------------useflowのタグ isRecommendが１のやつ一覧取得--------------------------#-----------------------------------------------------------

  def tag_recommend
    @tags = Tag.where(isRecommend: 1)
    @tags_array = []
    @tags.each do |tag|
        @tags_array << tag.as_json
    end
    render json: { tags: @tags_array }
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
        .where(tags: {id: params[:tag]})
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @userflows.each do|userflow|
          hash = UserFlow
          .preload(:tags, :product, :platform)
          .find_by(id: userflow.id)
          .as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags])     #hash1 所有タグ一覧
          

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
    # @target_userflow = UserFlow
    # .eager_load(:tags)
    # .where(product_id:params[:product_id],platform_id:params[:platform_id],tags: {id: params[:flowtag_id]})
    # .order(created_at: :desc)
    # .first
    @target_userflow = UserFlow
    .eager_load(:tags,:product,:platform)
    .where(products:{name: params[:product]},platforms:{name:params[:platform]},tags: {id: params[:flowtag_id]}) 
    .order(created_at: :desc)
    .first

    if @target_userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else
      @userflow_product_platform_flowtag = UserFlow
      .preload(:tags, :product, :platform)
      .find_by(id: @target_userflow.id)
      .as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags]) 
      
      render json: {userflow: @userflow_product_platform_flowtag}
      
    end
  end
  
  #------------動画のスクショ一覧取得----------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag]/screen_shot 
  def screenshot
    # @target_userflow = UserFlow
    # .eager_load(:tags)
    # .where(product_id:params[:product_id],platform_id:params[:platform_id],tags: {id: params[:flowtag_id]})
    # .order(created_at: :desc)
    # .first
    # byebug
    #絞り込みでターゲットのidを取得 #eager_loadではスクショのタグを芋づる取得できない為、そのidでpreloadでfind_byする
    @target_userflow = UserFlow
    .eager_load(:tags,:product,:platform)
    .where(products:{name: params[:product]},platforms:{name:params[:platform]},tags: {id: params[:flowtag_id]}) 
    .order(created_at: :desc)
    .first

    if @target_userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else
      @userflow = UserFlow
      .preload(:screen_shots, :product, :platform)
      .find_by(id: @target_userflow.id)

      @userflow_product_platform_flowtag_screenshots = @userflow.as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}]) #,screen_shots:{include: :tags}
      
      @screenshots = @userflow.screen_shots.as_json(include: :tags)
      main_tag = []
      @userflow.screen_shots.each {|n|main_tag << n.tags.find_by(id: n.main_tag)}
      @screenshots_with_tags = []
      @screenshots.each do|shots|
        @screenshots_with_tags << shots.merge(main_tag[@screenshots_with_tags.count].as_json(root:"main_tag"))
      end 
      screenshots_hash = {screenshots: @screenshots_with_tags}
      @userflow_product_platform_flowtag_screenshots = @userflow_product_platform_flowtag_screenshots.merge(screenshots_hash)
      render json: {userflow:@userflow_product_platform_flowtag_screenshots}
      
    end
    
  end
  #------------当該プロダクトの他の動画取得-------------------#-----------------------------------------------------------
  # /userflow/[product]/ プロダクトの他の動画一覧
  def product_userflow
    @product_userflow = UserFlow
    .eager_load(:product, :platform)
    .where(products: {name: params[:product]})
    .as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}])


    # @product_userflow = UserFlow
    # .preload(:product, :platform)
    # .where(product_id: params[:product_id])
    # .as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}])

    render json: {userflow: @product_userflow}
    
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
end