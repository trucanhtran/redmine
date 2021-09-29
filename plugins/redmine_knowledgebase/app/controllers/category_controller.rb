class CategoryController < ApplicationController
 
  def update
    @category.user_whitelist = 
      if params["user_whitelist"].blank?
        ""
      else
        params["user_whitelist"].join(",")
      end
      
  end

end
