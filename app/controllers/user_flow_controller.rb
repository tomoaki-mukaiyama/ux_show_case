class UserFlowController < ApplicationController
  # def title
  #   render json: {title: 'uxshowcase'}
  # end
  #------------useflowのタグ一覧取得--------------------------#-----------------------------------------------------------
  
  def tag_index
    #tag_typeの値が1のやつ(UserFlowのタグ)を全取得、json形式で配列に入れる
    @tags = Tag.where(tag_type: 1)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
    end
    render json: { tags: @tags_array }
  end
  #------------useflowのタグ isTopが１のやつ一覧取得--------------------------#-----------------------------------------------------------
  
  def tag_top
    @tags = Tag.where(isTop: 1)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
    end
    render json: { tags: @tags_array }
  end
  #------------useflowのタグ isRecommendが１のやつ一覧取得--------------------------#-----------------------------------------------------------

  def tag_recommend
    @tags = Tag.where(isRecommend: 1)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
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
      if params[:tag] #タグ指定ありーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        
        @userflows = UserFlow.eager_load(:tags)   #タグ絞り込み　＆　全件取得
        .where(tags: {id: params[:tag]})
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @userflows.each do|userflow|
          hash = UserFlow.preload(:tags).find(userflow.id).as_json(include: :tags)     #hash1 所有タグ一覧 
          if @userflows.count != 1 #userflowが複数ある場合、配列に入れる
            @userflows_array << hash
          else
            @userflows_array = hash #無い場合、そのままレンダー
          end
        end
        # byebug
      else            #タグ指定なしーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
        @userflows = UserFlow.preload(:tags)
        .order(created_at: :desc)
        .limit(page_size)
        .offset(page_num * page_size)
        
        @userflows.each do|userflow|
          hash = userflow.as_json(include: :tags)
          if @userflows.count != 1 #userflowが複数ある場合、配列に入れる
            @userflows_array << hash
          else
            @userflows_array = hash #無い場合、そのままレンダー
          end
        end
        
      end
      
      render json: {userflows: @userflows_array}
      
    end
    
  end
  
  #------------動画詳細ページ取得----------------------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag] userflow動画の詳細ページ 最新の１件
  
  def detail
    @userflows_array = []
    target_flow = UserFlow
    .eager_load(:tags)
    .where(product_id:params[:product_id],platform_id:params[:platform_id],tags: {id: params[:flowtag_id]})
    .order(created_at: :desc)
    .first
    if target_flow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else
      flow = UserFlow.preload(:tags, :product, :platform).find(target_flow.id).as_json(include:[{product:{only:[:id,:name, :description]}},{platform:{only:[:id,:name]}},:tags]) #.as_json(include: {product:{only:[:name, :description]}} )
      
      render json: {userflow: flow}
      
    end
    # byebug
  end
  
  #------------動画詳細ページのスクショ一覧取得----------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag]/screen_shot userflow動画の詳細ページのスクショ一覧
  
  #------------当該プロダクトの他の動画取得-------------------#-----------------------------------------------------------
  # /userflow/[product]/ プロダクトの他の動画一覧
  #-----------------------------------------------------------#-----------------------------------------------------------
end