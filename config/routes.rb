Rails.application.routes.draw do
  # get "userflow", to: "user_flow#title"

  get "userflow-tag", to: "user_flow#tag_index"
  get "userflow-tag/top", to: "user_flow#tag_top"
  get "userflow-tag/recommend", to: "user_flow#tag_recommend"

  get "screenshot-tag", to: "screenshot#tag_index"

  get "/screen_shots" , to: "screenshot#latest"
  get "/userflow" , to: "user_flow#latest"
end
