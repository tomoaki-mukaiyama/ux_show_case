FactoryBot.define do
    factory :product,aliases: [:product_id] do
        name { 'youtube' }
        description { '動画サイト' }
    end
end

FactoryBot.define do
    factory :platform, aliases: [:platform_id] do
        name { 'ios' }
    end
end

FactoryBot.define do
    factory :user_flow do
        product_id
        platform_id

        product_id {1}
        platform_id {1}
        bg_color { 'red' }
        icon_path { 'path'}
        version { 'v1'}
        video_time_string { '1:00'}
        video_path { 'path'}
    end
end
