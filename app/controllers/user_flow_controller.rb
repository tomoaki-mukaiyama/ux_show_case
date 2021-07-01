class UserFlowController < ApplicationController
  before_action :set_pagination_values, only: [:latest, :product_userflow, :recommended_userflow]
  #------------スクショ数＆プロダクト数--------------------------#-----------------------------------------------------------
  def stats
    userflow_count = { userflow_count: UserFlow.all.count}
    product_count = { product_count: Product.all.count}
    counts = userflow_count.merge(product_count)
    render json: { counts: counts }
  end
  #------------タグ一覧--------------------------#-----------------------------------------------------------
  def tags_index
    if params[:flg] == "recommend"
      tags_array = []
      Tag.where(isRecommend: 1).each do |tag|
        tags_array << tag.as_json
      end
      render json: { tags: tags_array }
    elsif params[:flg] == "top"
      tags_array = []
      Tag.where(isTop: 1).each do |tag|
        tags_array << tag.as_json
      end
      render json: { tags: tags_array }
    else
      tags_array = []
      Tag.all.each do |tag|
        count = { count: tag.user_flows.count}
          tags_array << tag.as_json.merge(count)
      end
      render json: { tags: tags_array }
    end
  end
  #------------指定したタグ一件--------------------------#-----------------------------------------------------------
  def tag
    @tag = Tag.find_by(id: params[:id])
    if @tag == nil
      return response_not_found
    else
      render json: { tag: @tag }
    end
  end
  #------------最新のスクショ取得----------------#-----------------------------------------------------------
  def latest
    #全スクショを最新順取得＆limit&page指定 => @userflowsに代入
      userflows_array = []
      if params[:tag] #ーーーーーータグ指定ありーーーーーーー
        @userflows = UserFlow.eager_load(:tags)   #タグ絞り込み　＆　全件取得
        .where(tags: {id: params[:tag].split(",")})
        .order(created_at: :desc)
        .limit(@page_size)
        .offset(@page_num * @page_size)
        @userflows.each do|userflow|
          userflows_array << UserFlow
          .preload(:tags, :product, :platform)
          .find_by(id: userflow.id)
          .as_json(include: [{product:{only:[:id,:name, :description, :slug, :icon_path, :quote_url]}},{platform:{only:[:id,:name, :slug]}},:tags])     #hash1 所有タグ一覧
          
        end
      else            #ーーーーーータグ指定なしーーーーーーー
        @userflows = UserFlow
        .preload(:tags, :product, :platform)
        .order(created_at: :desc)
        .limit(@page_size)
        .offset(@page_num * @page_size)
        
        @userflows.each do|userflow|
          userflows_array << userflow.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path, :quote_url]}},{platform:{only:[:id,:name, :slug]}},:tags])
        end
      end
      render json: {userflows: userflows_array}
    end
    
  #------------当該プロダクトの他のスクショ取得-------------------#-----------------------------------------------------------
  # /products/[product_id]/userflows プロダクトの他のスクショ一覧
  def product_userflow
    userflow_array = []
    if params[:tag] #ーーーーーータグ指定ありーーーーーーー
      userflows = UserFlow
      .eager_load(:product, :platform, :tags)
      .where(products: {id: params[:id]},tags: {id: params[:tag].split(",")})
      .limit(@page_size)
      .offset(@page_num * @page_size)
        userflows.each do |userflow|
          userflow_array << UserFlow
          .preload(:tags, :product, :platform)
          .find_by(id: userflow.id)
          .as_json(include: [{product:{only:[:id,:name, :description, :slug, :icon_path, :quote_url]}},{platform:{only:[:id,:name, :slug]}},:tags])     #hash1 所有タグ一覧
        end
    else            #ーーーーーータグ指定なしーーーーーーー
      userflows = UserFlow
      .eager_load(:product, :platform, :tags)
      .where(products: {id: params[:id]})
      .limit(@page_size)
      .offset(@page_num * @page_size)
      
      userflows_tags = userflows.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path, :quote_url]}},{platform:{only:[:id,:name, :slug]}}, :tags])
      userflows_tags.each do |userflow|
        userflow_array << userflow
      end
    end
    render json: {userflows: userflow_array}
  end

  #------------スクショ詳細ページ取得----------------------------#-----------------------------------------------------------
# /userflows/[userflow_id] userflow１件

  def detail
    userflow = UserFlow
    .find_by(id: params[:id])

    if userflow == nil #データが無ければ404notfoundを返す
      response_not_found #application.rb
    else

      userflow = userflow.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path, :quote_url]}},{platform:{only:[:id,:name, :slug]}},:tags]) 

      render json: {userflow: userflow}
      
    end
  end
  #------------関連スクショ取得-------------------#-----------------------------------------------------------
  def recommended_userflow
    if UserFlow.find_by(id: params[:id]) == nil
       return response_not_found
    else
      userflows = UserFlow.find_by(id: params[:id])
      .product.user_flows
      .where.not(id: params[:id])
      .limit(@page_size)
      .offset(@page_num * @page_size)
      userflow_array = []
      userflows.each do |userflow|
        userflow_array << userflow.as_json(include:[{product:{only:[:id,:name, :description, :slug, :icon_path, :quote_url]}},{platform:{only:[:id,:name, :slug]}},:tags])
      end
      render json: {userflows: userflow_array}
    end
  end
  #-----------------------------------------------------------#-----------------------------------------------------------
  
    def products_index
      products = Product.all
      products_array = []
      products.each do|product|
        userflow_count = { userflow_count: product.user_flows.count }
        product_with_userflow_count = product.as_json.merge(userflow_count)
        products_array << product_with_userflow_count
      end
      render json: {products: products_array}
    end
  #-----------------------------------------------------------#-----------------------------------------------------------
  def product_tags_index
    userflows = UserFlow
    .eager_load(:product, :tags)
    .where(products: {id: params[:id]})
    
    tags = []
    tag_ids_array = []
    userflows.each do|userflow|
      tags << userflow.tags
      tag_ids_array << userflow.tag_ids
    end
    tags_hash = tags.flatten.uniq
    tags_flatten_hash = tag_ids_array.flatten.group_by(&:itself)
    tags_with_count = []
    tags_hash.each do |tag|
      tags_count = { count: tags_flatten_hash[tag.id].count}
      tags_with_count << tag.as_json.merge!(tags_count)
    end
    render json: { product_tags: tags_with_count }
  end
  # byebug
  #-----------------------------------------------------------#-----------------------------------------------------------
  
  private
  
  def set_pagination_values
    if params[:limit] == 0.to_s       #limit=0を1として扱う
      @page_size = params[:limit].to_i + 1
    else
      @page_size = params[:limit].to_i
    end
    
    if params[:page] == 0.to_s        #page=0を1として扱う
      @page_num  = params[:page].to_i
    else
      @page_num  = params[:page].to_i - 1
    end
    if params[:page].to_s.empty? || params[:limit].to_s.empty? #pageとlimitのリクエスト不備の場合エラーを返す
      response_bad_request #(application_controller.rb)
    end
  end
end
