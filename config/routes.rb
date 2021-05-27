Rails.application.routes.draw do

  get "/userflow_tags", to: "user_flow#tag_index"
  get "/userflow_tags/:id", to: "user_flow#userflow_tag"
  
  get "/screenshot_tags", to: "screenshot#tag_index"
  get "/screenshot_tags/:id", to: "screenshot#screenshot_tag"

  get "/screenshots" , to: "screenshot#latest"
  
  get "/userflows" , to: "user_flow#latest"
  get "/userflows/:id" , to: "user_flow#detail"
  get "/userflows/:id/screenshots" , to: "user_flow#screenshots"
  get "/userflows/:id/recommends" , to: "user_flow#recommended_userflow"

  get "/products/:id/userflows" , to: "user_flow#product_userflow"
end
