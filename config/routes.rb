Rails.application.routes.draw do

  get "/stats", to: "user_flow#stats"
  get "/tags", to: "user_flow#tag_index"
  get "/tags/:id", to: "user_flow#tag"
  
  get "/userflows" , to: "user_flow#latest"
  get "/userflows/:id" , to: "user_flow#detail"
  get "/userflows/:id/recommends" , to: "user_flow#recommended_userflow"
  
  get "/products/:id/userflows" , to: "user_flow#product_userflow"
end
