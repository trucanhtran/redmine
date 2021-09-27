class CategoryController < ApplicationController
    before_filter :find_project_by_project_id, :authorize

end
