class SearchesController < ApplicationController
def show
    if params[:q].present?
        @search = Activity.search(params[:q].split.join(' AND ')).records
    else
      @search = []
    end
  end
end