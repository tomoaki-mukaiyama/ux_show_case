Rails.application.routes.draw do
  get 'userflow', to: "user_flow#title"
  get 'userflow-tag', to: "user_flow#tag_index"
end
