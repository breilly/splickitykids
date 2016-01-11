class Admin::UsersController < Admin::AdminController
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy, :change_status]

  # GET /admin/users
  # GET /admin/users.json
  def index
    @users = User.all.page(params[:page]).search(params[:search])
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = User.new(admin_user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_url(page: params[:page]), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    respond_to do |format|
      if @user.update(admin_user_params)
        UserMailer.send_update_user_mail(@user).deliver
        format.html { redirect_to admin_users_url(page: params[:page]), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url(page: params[:page]), notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  def change_status
    new_status = @user.account_active? ? false : true
    @user.account_active = new_status
    if @user.save
      UserMailer.send_activation_user_mail(@user).deliver if new_status
      respond_to do |format|
        format.html { redirect_to admin_users_url(page: params[:page]), notice: 'User status was successfully changed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_users_url(page: params[:page]), notice: 'User status was not changed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, 
        :date_of_birth, :city, :zip_code, :street_address, :state_name, :country_id, :state_id, :company_name)
    end
end
