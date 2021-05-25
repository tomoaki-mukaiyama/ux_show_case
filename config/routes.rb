Rails.application.routes.draw do

  get "userflow_tags", to: "user_flow#tag_index"
  get "userflow_tags/top", to: "user_flow#tag_top"
  get "userflow_tags/recommend", to: "user_flow#tag_recommend"
  get "userflow_tag/:flowtag", to: "user_flow#flowtag"
  
  get "screenshot_tags", to: "screenshot#tag_index"

  get "/screenshots" , to: "screenshot#latest"
  get "/userflows" , to: "user_flow#latest"

  get "/userflow/:product/:platform/:flowtag" , to: "user_flow#detail"
  get "/userflow/:product/:platform/:flowtag/screenshots" , to: "user_flow#screenshot"
  get "/userflows/:product" , to: "user_flow#product_userflow"
end
