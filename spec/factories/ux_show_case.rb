FactoryBot.define do
    factory :product do
        name { 'youtube' }
        description { '動画サイト' }
    end
end

FactoryBot.define do
    factory :platform do
        name { 'ios' }
    end
end

FactoryBot.define do
    factory :user_flow do
        association :product
        association :platform
        
        product_id {1}
        platform_id {1}
        bg_color { 'red' }
        icon_path { 'path' }
        version { 'v1' }
        video_time_string { '1:00' }
        video_path { 'path' }
    end
end

FactoryBot.define do
    factory :tag do #, aliases: [:tag_id, :main_tag] do
    end
end

FactoryBot.define do
    factory :user_flow_tag do
        tag_id{ 1 }
        userflow_id{ 1 }
    end
end