class UserFlowController < ApplicationController
  # def title
  #   render json: {title: 'uxshowcase'}
  # end
  #------------useflowのタグ一覧取得--------------------------#-----------------------------------------------------------
  
  def tag_index
    #tag_typeの値が1のやつ(UserFlowのタグ)を全取得
    @tags = Tag.where(tag_type: 1)
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
      response_bad_request #エラーメソッド(application_controller.rb)
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
          
          # byebug
          if userflow.tags.count == 1
            user@tags = userflow.tags.as_json(root: "tags").first
            hash = userflow.as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}]).merge!(user@tags)
          end
          

          if @userflows.count != 1 #userflowが複数ある場合、配列に入れる
            @userflows_array << {userflow: hash}
          else
            @userflows_array = {userflow: hash} #一つの場合一つだけ出力
          end
        end
      else            #ーーーーーータグ指定なしーーーーーーー
        @userflows = UserFlow.preload(:tags, :product, :platform)
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size) 
        
        @userflows.each do|userflow|
          if userflow.tags.count != 1
            hash = userflow.as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags])
          else
            user@tags = userflow.tags.as_json(root: "tags").first
            hash = {userflow: userflow.as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}]).merge!(user@tags)}
          end

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
    target_flow = UserFlow
    .eager_load(:tags)
    .where(product_id:params[:product_id],platform_id:params[:platform_id],tags: {id: params[:flowtag_id]})
    .order(created_at: :desc)
    .first
    if target_flow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else
      flow = UserFlow
      .preload(:tags, :product, :platform)
      .find_by(id: target_flow.id)
      .as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags]) 
      
      # @tags = flow.tags.as_json
      # @tags = flow.tags.first if flow.tags.count == 1 #一つしか無いなら.firstで取り出して配列解除
      # tags_hash = {tags: @tags}
      # flow = flow.as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}])
      # flow = flow.merge!(tags_hash)
      render json: {userflow: flow}
      
    end
  end
  
  #------------動画のスクショ一覧取得----------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag]/screen_shot 
  def screenshot
    @screenshots_array = []
    target_flow = UserFlow
    .eager_load(:tags)
    .where(product_id:params[:product_id],platform_id:params[:platform_id],tags: {id: params[:flowtag_id]})
    .order(created_at: :desc)
    .first
    if target_flow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else
      flow = UserFlow
      .preload(:screen_shots, :product, :platform)
      .find_by(id: target_flow.id)
      .as_json(include: [{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},{ screen_shots: {include: :tags}}])
      
      # byebug


      render json: {userflow: flow}
      
    end
    
  end
  #------------当該プロダクトの他の動画取得-------------------#-----------------------------------------------------------
  # /userflow/[product]/ プロダクトの他の動画一覧
  def product_userflow
    @product_userflow = UserFlow
    .preload(:product, :platform)
    .where(product_id: params[:product_id])
    .as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}}])

    render json: {userflow: @product_userflow}
    
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
end