require 'rails_helper'

describe 'UserFlow API' do
    before do
        # FactoryBot.create(:tag, tag_type: 0, isTop: 1, isRecommend: 1, name: "name", slug: "signup" )
        # FactoryBot.create(:tag, tag_type: 1, isTop: 1, isRecommend: 1, name: "name", slug: "search" )
    end
    it  'return all userflow tags' do
        get '/userflow_tags'
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(1)
    end
    
    it  'return all userflow tags/top' do
        get '/userflow_tags/top'
        
        expect(response).to have_http_status(:success)
    end
    
    it  'return all userflow tags/recommend' do
        get '/userflow_tags/recommend'
        
        expect(response).to have_http_status(:success)
    end
    
    it 'return all userflow products' do
        get '/userflow/youtube'

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(1)
    end
end

describe 'ScreenShot API' do
    it 'return all screenshot tags' do
        get '/screenshot_tags'
        
        expect(response).to have_http_status(:success)
        
    end
    # it '' do
    
    # end
end