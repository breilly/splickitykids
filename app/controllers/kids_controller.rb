class KidsController < ApplicationController
  before_action :set_kid, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  respond_to :html

  def index
    @kids = Kid.all
    respond_with(@kids)
  end

  def show
    respond_with(@kid)
  end

  def new
    @kid = Kid.new
    respond_with(@kid)
  end

  def edit
  end

  def create
    @kid = Kid.new(kid_params)
    @kid.user_id = current_user.id
    @kid.save
    redirect_to kids_path
    #respond_with(@kid)
  end

  def update
    @kid.update(kid_params)
    respond_with(@kid)
  end

  def destroy
    @kid.delete
    respond_with(@kid)
  end

  private
    def set_kid
      @kid = Kid.find(params[:id])
    end

    def kid_params
      params.require(:kid).permit(:first_name, :last_name, :dob, :user_id)
    end
end
