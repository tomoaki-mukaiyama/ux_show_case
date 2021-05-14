require 'rails_helper'

describe 'UserFlow API' do
    it  'return all userflow tags' do
        get '/userflow_tags'
        
        expect(response).to have_http_status(:success)
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
        # FactoryBot.create(:product, name: "youtube", description: "動画サイト")
        # FactoryBot.create(:platform, name: "ios")
        # FactoryBot.create(:user_flow, product_id: 1,platform_id: 1,bg_color: "red", icon_path: "path", version: "v1",video_time_string: "1:00", video_path:"path")
        
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