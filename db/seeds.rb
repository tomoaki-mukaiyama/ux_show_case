# #-------------------------------------------------------------------
# Product.create!(name:"youtube",description:"動画サイト")
# Product.create!(name:"twitter",description:"SNS")

# #-------------------------------------------------------------------
# Platform.create!(name:"ios")
# Platform.create!(name:"android")
# #-------------------------------------------------------------------
# 6.times do |n|
#     Tag.create!(
#         tag_type:1,
#         slug: "search#{n + 1}"
#     )
# end
# tag_type = [0,0,1,1,1,1]
# 6.times do |a|
#     Tag.all[a-1].update!(tag_type: tag_type[a-1])
# end
# #-------------------------------------------------------------------
# Tag.where(tag_type: 0).all.each do |n|
#     n.user_flows.create!(
#         product_id: 1,
#         platform_id: 1,
#         tag_id: [1,2]
#     )
# end

# product_id = [1,1,1,1,2,2,2,2]
# platform_id = [1,1,2,2,1,1,2,2]

# n = -1
# UserFlow.all.each{|u|u.update!(product_id: product_id[n += 1])}
# n = -1
# UserFlow.all.each{|u|u.update!(platform_id: platform_id[n += 1])}
# #-------------------------------------------------------------------

# UserFlow.all.each {|n|n.screen_shots.create!(user_flow_id:n.id)}
# main_tag=[3,4,5,6,3,4,5,6]
# 2.times do |n|
#     ScreenShot.all.each do |ss|
#         ss.update!(tag_id: main_tag[ss.id - 1])
#     end
# end
# #-------------------------------------------------------------------

# 2.times do
#     8.times do |n|
#         ScreenShotTag.create!(
#             tag_id:1,
#             screen_shot_id: n + 1
#         )
#     end
# end

# tag_id = [3,5,4,6,4,5,3,6,3,4,5,4,5,4,6,3]
# ScreenShotTag.all.each {|n|n.update!(tag_id: tag_id[n.id - 1])}

# num = -2
# count = ScreenShotTag.all.count / 2
# count.times do|n|
#     # byebug
#     ScreenShotTag.all[num = num + 2].update!(screen_shot_id:n + 1)
# end
# num = -1
# count.times {|n|ScreenShotTag.all[num = num + 2].update!(screen_shot_id:n + 1)}
# #-------------------------------------------------------------------

# 8.times do |n|
#     UserFlowTag.create!(
#         tag_id: 1,
#         user_flow_id: n + 1
#     )
# end
# tag_id = [1,1,2,2,1,1,2,2]
# UserFlowTag.all.each{|n|n.update!(tag_id: tag_id[n += 1])}