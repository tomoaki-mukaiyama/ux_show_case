class UserFlowController < ApplicationController
  def title
    render json: {title: 'uxshowcase'}
  end
  
  def tag_index
    #IsFlowTagの値が1のやつを全取得、json形式で配列に入れる
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

end