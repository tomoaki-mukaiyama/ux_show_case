Rails.application.routes.draw do
  # get "userflow", to:"user_flow#title"

  get "userflow-tags", to: "user_flow#tag_index"
  get "userflow-tags/top", to: "user_flow#tag_top"
  get "userflow-tags/recommend", to: "user_flow#tag_recommend"

  get "screenshot-tags", to: "screenshot#tag_index"

  get "/screen_shots" , to: "screenshot#latest"
  get "/userflows" , to: "user_flow#latest"

  get "/userflow/:product_id/:platform_id/:flowtag_id" , to: "user_flow#detail"
  get "/userflow/:product_id/:platform_id/:flowtag_id/screenshot" , to: "user_flow#screenshot"
  get "/userflow/:product_id" , to: "user_flow#product_userflow"
end
