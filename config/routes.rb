Rails.application.routes.draw do
  # get "userflow", to:"user_flow#title"

  get "userflow_tags", to: "user_flow#tag_index"
  get "userflow_tags/top", to: "user_flow#tag_top"
  get "userflow_tags/recommend", to: "user_flow#tag_recommend"

  get "screenshot_tags", to: "screenshot#tag_index"

  get "/screenshots" , to: "screenshot#latest"
  get "/userflows" , to: "user_flow#latest"

  get "/userflow/:product_id/:platform_id/:flowtag_id" , to: "user_flow#detail"
  get "/userflow/:product_id/:platform_id/:flowtag_id/screenshots" , to: "user_flow#screenshot"
  get "/userflow/:product_id" , to: "user_flow#product_userflow"
end
