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
    # byebug

    if params[:page].to_s.empty? || params[:limit].to_s.empty? #pageとlimitのリクエスト不備の場合エラーを返す
      response_bad_request #エラーメソッド(application_controller.rb)
    else

          #全動画を最新順取得＆limit&page指定 => @userflowsに代入
          @userflows = UserFlow.includes(:tags)
                              .order(created_at: :desc)
                              .limit(page_size)
                              .offset(page_num * page_size)
      
        @userflows_array = []
        if params[:tag] #タグ指定あり
          @userflows = @userflows.where(tags:{id:params[:tag]}) #指定タグで絞る
            @userflows.each do|u|
              @userflows_array << u.as_json(except:[:id, :product_id, :platform_id,:created_at,:updated_at],include:{tags:{only:[:name,:isTop,:isRecommend]}}) #配列に入れる
            end
        else            #タグ指定なし
          @userflows.each do|u|
            @userflows_array << u.as_json(except:[:id, :product_id, :platform_id,:created_at,:updated_at],include:{tags:{only:[:name,:isTop,:isRecommend]}}) #配列に入れる
          end
      
        end
      
          render json: {userflows: @userflows_array}
          
    end

  end
  
  #------------動画詳細ページ取得----------------------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag] userflow動画の詳細ページ
  
  #------------動画詳細ページのスクショ一覧取得----------------#-----------------------------------------------------------
  # /userflow/[product]/[platform]/[flowtag]/screen_shot userflow動画の詳細ページのスクショ一覧
  
  #------------当該プロダクトの他の動画取得-------------------#-----------------------------------------------------------
  # /userflow/[product]/ プロダクトの他の動画一覧
  #-----------------------------------------------------------#-----------------------------------------------------------
end