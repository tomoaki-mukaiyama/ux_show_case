

# 5.times do |n|
#     UserFlow.create!(
#         product_id: n + 1,
#         platform_id: n + 1,
#         bg_color: "test_color#{n + 1}",
#         icon_path: "test_icon_path#{n + 1}",
#         version: "test_v1",
#         video_time_string: "1:00",
#         video_path: "test_video_path#{n + 1}"
#     )
# end
# 5.times do |n|
#     ScreenShot.create!(
#         userflow_id: n + 1,
#         main_tag: 3,
#         path: "test/path#{n + 1}"
#     )
# end

# 5.times do |n|
#     ScreenShotTag.create!(
#         screen_shot_id: n + 1,
#         tag_id: 3
#     )
# end


5.times do |n|
    UserFlowTag.create!(
        tag_id: [4,5,6].sample,
        user_flow_id: n + 1
    )
end
