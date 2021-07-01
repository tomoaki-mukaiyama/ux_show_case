Rails.application.routes.draw do
  get "/tags", to: "user_flow#tags_index"
  # 1. /tags
  # 2. /tags?flg=top
  # 3. /tags?flg=recommend
  
  get "/tags/:id", to: "user_flow#tag"
  # 4. /tags/:id
  
  get "/userflows/:id" , to: "user_flow#detail"
  # 5. /userflows/:id
  
  get "/userflows" , to: "user_flow#latest"
  # 6. /userflows?page=x&limit=y
  # 7. /userflows?page=x&limit=y&tag=z
  
  get "/userflows/:id/recommends" , to: "user_flow#recommended_userflow"
  # 8. /userflows/:id/recommends?page=x&limit=y
  
  get "/products/:id/userflows" , to: "user_flow#product_userflow"
  # 9. /products/:id/userflows?page=x&limit=y
  # 12. /products/:id/userflows?page=x&limit=y&tag=z
  
  get "/stats", to: "user_flow#stats"
  # 10. /stats

  get "/products" , to: "user_flow#products_index"
  # 11. /products

  get "/products/:id/tags" , to: "user_flow#product_tags_index"
  # 13. /products/:id/tags
end
