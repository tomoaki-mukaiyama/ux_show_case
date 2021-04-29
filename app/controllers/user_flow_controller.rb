class UserFlowController < ApplicationController
  # def title
  #   render json: {title: 'uxshowcase'}
  # end
  
  def tag_index
    #tag_typeの値が1のやつ(UserFlowのタグ)を全取得、json形式で配列に入れる
    @tags = Tag.where(tag_type: 1)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
    end
    render json: { tags: @tags_array }
  end
  
  def tag_top
    @tags = Tag.where(isTop: 1)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
    end
    render json: { tags: @tags_array }
  end

  def tag_recommend
    @tags = Tag.where(isRecommend: 1)
    @tags_array = []
    @tags.each do |tag|
      @tags_array << tag.as_json(only:[:name])
    end
    render json: { tags: @tags_array }
  end

  #------------最新のuserflow(動画)取得----------------
  def latest
    page_size = params[:limit].to_i
    page_num  = params[:page].to_i - 1

    #全動画を最新順取得＆limit&page指定 => @userflowsに代入
    @userflows = UserFlow.includes(:tags)
                         .order(created_at: :desc)
                         .limit(page_size)
                         .offset(page_num * page_size)
  #
  #byebug
  @userflows_array = []
  if params[:tag] #タグ指定あり
    @userflows = @userflows.where(tags:{id:params[:tag]}) #指定タグで絞る
      @userflows.each do|u|
        @userflows_array << u.as_json(except:[:id, :product_id, :platform_id],include:{tags:{only:[:name,:isTop,:isRecommend]}}) #配列に入れる
      end
  else            #タグ指定なし
    @userflows.each do|u|
      @userflows_array << u.as_json(except:[:id, :product_id, :platform_id],include:{tags:{only:[:name,:isTop,:isRecommend]}}) #配列に入れる
    end

  end

    render json: {userflows: @userflows_array}
  end

end