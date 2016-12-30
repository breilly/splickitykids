class Admin::VendorsController < Admin::AdminController
  before_action :set_admin_user, only: [:show, :edit, :update, :destroy, :change_status]

  # GET /admin/vendors
  # GET /admin/vendors.json
  def index
    @vendors = Vendor.all.page(params[:page]).search(params[:search])
  end

  # GET /admin/vendors/1
  # GET /admin/vendors/1.json
  def show
  end

  # GET /admin/vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /admin/vendors/1/edit
  def edit
  end

  # POST /admin/vendors
  # POST /admin/vendors.json
  def create
    @vendor = Vendor.new(admin_vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to admin_vendors_url(page: params[:page]), notice: 'Vendor was successfully created.' }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/vendors/1
  # PATCH/PUT /admin/vendors/1.json
  def update


    params[:vendor].delete(:password) if params[:vendor][:password].blank?
    params[:vendor].delete(:password_confirmation) if params[:vendor][:password].blank? and params[:vendor][:password_confirmation].blank?
    respond_to do |format|
      if @vendor.update(admin_vendor_params)
        VendorMailer.send_update_vendor_mail(@vendor).deliver
        format.html { redirect_to admin_vendors_url(page: params[:page]), notice: 'Vendor was successfully updated.' }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/vendors/1
  # DELETE /admin/vendors/1.json
  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to admin_vendors_url(page: params[:page]), notice: 'Vendor was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
  def change_status
    new_status = @vendor.account_active? ? false : true
    @vendor.account_active = new_status
    if @vendor.save
      VendorMailer.send_activation_vendor_mail(@vendor).deliver if new_status
      respond_to do |format|
        format.html { redirect_to admin_vendors_url(page: params[:page]), notice: 'Vendor status was successfully changed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_vendors_url(page: params[:page]), notice: 'Vendor status was not changed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user
      #@user = User.find(params[:id])
      @vendor = Vendor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_vendor_params
      params.require(:vendor).permit(:first_name, :last_name, :email, #:phone_number, 
        :password, :password_confirmation, :verification_file, :ssn, :dob_month, :dob_day, :dob_year, :routing_number, :account_number,
        #:date_of_birth, :city, :zip_code, :street_address, :state_name, :country_id, :state_id, 
        :company_name)
    end
end
