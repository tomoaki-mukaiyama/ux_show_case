class UserFlowController < ApplicationController

  #------------tag_typeの値が1のタグ一覧--------------------------#-----------------------------------------------------------
  
  def tag_index
    # byebug
    if params[:flg] == "recommend"
      @tags = Tag.where(isRecommend: 1,tag_type: 0)
      @tags_array = []
      @tags.each do |tag|
        @tags_array << tag.as_json
      end
      render json: { tags: @tags_array }
    elsif params[:flg] == "top"
      @tags = Tag.where(isTop: 1,tag_type: 0)
      @tags_array = []
      @tags.each do |tag|
          @tags_array << tag.as_json
      end
      render json: { tags: @tags_array }
    else
      @tags = Tag.where(tag_type: 0)
      @tags_array = []
      @tags.each do |tag|
          @tags_array << tag.as_json
      end
      render json: { tags: @tags_array }
    end
  end
 
  #------------指定したタグ一件--------------------------#-----------------------------------------------------------
  def userflow_tag

    @tag = Tag.find_by(id: params[:id])
    if @tag.tag_type == true
      respond_must_be_userflow
    else
      render json: { tag: @tag }
    end
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
        
        # byebug
        @userflows.each do|userflow|
          hash = UserFlow
          .preload(:tags, :product, :platform)
          .find_by(id: userflow.id)
          .as_json(include: [{product:{only:[:id,:name, :description, :slug, :icon_path]}},{platform:{only:[:id,:name, :slug]}},:tags])     #hash1 所有タグ一覧
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
          hash = userflow.as_json(include: [{product:{only:[:id,:name, :description, :slug, :icon_path]}},{platform:{only:[:id,:name, :slug]}},:tags])
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
  # /userflows/[userflow_id] userflow動画の詳細ページ 最新の１件
  
  # .where(products:{name: params[:product]},platforms:{name:params[:platform]},tags: {slug: params[:flowtag]}) 
  def detail
    userflow = UserFlow
    .find_by(id: params[:id])
    # .preload(:tags, :product, :platform)
    # byebug
    if userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else

      userflow_main_tag = userflow.tags.find_by(id: userflow.maintag_id).as_json(root:"maintag")

      userflow = userflow.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path]}},{platform:{only:[:id,:name, :slug]}},:tags]) 
      
      userflow_product_platform_tags_maintag = userflow.merge(userflow_main_tag)

      render json: {userflow: userflow_product_platform_tags_maintag}
      
    end
  end
  
  #------------動画のスクショ一覧取得----------------#-----------------------------------------------------------
  # /userflows/[userflow_id]/screen_shot 
  def screenshots

    #絞り込みでターゲットのidを取得 #eager_loadではスクショのタグを芋づる取得できない為、そのidでpreloadでfind_byする
    @userflow = UserFlow
    .preload(:tags)
    .find_by(id: params[:id])

    if @userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else

      @screenshots = @userflow.screen_shots.as_json(include: :tags)
      screenshot_main_tag = []
      @userflow.screen_shots.each {|n|screenshot_main_tag << n.tags.find_by(id: n.maintag_id)}
      
      @screenshots_with_tags = []
      @screenshots.each do|shots|
        @screenshots_with_tags << shots.merge(screenshot_main_tag[@screenshots_with_tags.count].as_json(root:"maintag"))
      end 
      render json: {screenshots: @screenshots_with_tags}
      
    end
    
  end
  #------------当該プロダクトの他の動画取得-------------------#-----------------------------------------------------------
  # /products/[product_id]/ プロダクトの他の動画一覧
  def product_userflow
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

      userflows = UserFlow
      .eager_load(:product, :platform, :tags)
      .where(products: {id: params[:id]})
      .limit(page_size)
      .offset(page_num * page_size)
      
      main_tag = []
      userflows.each do |userflow|
        main_tag << userflow.tags.find_by(id: userflow.maintag_id)
      end
      
      array = []
      userflows_tags = userflows.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path]}},{platform:{only:[:id,:name, :slug]}}, :tags])
      userflows_tags.each do |userflow|
        array << userflow.merge(main_tag[array.count].as_json(root:"maintag"))
      end

      render json: {userflows: array}
    end
  end
  #------------関連動画取得-------------------#-----------------------------------------------------------
  def recommended_userflow
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
      userflows = UserFlow.find_by(id: params[:id])
      .product.user_flows
      .where.not(id: params[:id])
      .limit(page_size)
      .offset(page_num * page_size)
      # byebug
      userflow_array = []
      userflows.each do |userflow|
        userflow_product_platform = userflow.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path]}},{platform:{only:[:id,:name, :slug]}},:tags])
        maintag = userflow.tags.find_by(id: userflow.maintag_id).as_json(root:"maintag")
        if userflows.count != 1 #userflowが複数ある場合、配列に入れる
          userflow_array << userflow_product_platform.merge(maintag)
        else
          userflow_array = userflow_product_platform.merge(maintag) #一つの場合一つだけ出力
        end
      end

      
      render json: {userflows: userflow_array}
    end
    
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
end
