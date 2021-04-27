Rails.application.routes.draw do
  get "userflow", to: "user_flow#title"
  get "userflow-tag", to: "tag#tag_index"
  get "userflow-tag/top", to: "tag#tag_top"
  get "userflow-tag/recommend", to: "tag#tag_recommend"
  get "screenshot-tag", to: "tag#tag_index"
  get "screenshot-tag/top", to: "tag#tag_top"
  get "screenshot-tag/recommend", to: "tag#tag_recommend"
end
