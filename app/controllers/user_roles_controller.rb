class UserRolesController < ApplicationController
  include SecurityController
  before_action :set_user_role, only: %i[ show update destroy ]

  # GET /user_roles
  def index
    @user_roles = UserRole.all
    render json: @user_roles
  end

  # GET /user_roles/1
  def show
    render json: @user_role
  end

  # POST /user_roles
  def create
    unless isAdmin?
      render json: { error: 'Not Authorized' }, status: 403
      return
    end
    @user_role = UserRole.new(user_role_params)

    if @user_role.save
      render json: @user_role, status: :created, location: @user_role
    else
      render json: @user_role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_roles/1
  def update
    unless isAdmin?
      render json: { error: 'Not Authorized' }, status: 403
      return
    end

    if @user_role.update(user_role_params)
      render json: @user_role
    else
      render json: @user_role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_roles/1
  def destroy
    unless isAdmin?
      render json: { error: 'Not Authorized' }, status: 403
      return
    end
    @user_role.destroy!
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_role
      @user_role = UserRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_role_params
      params.require(:user_role).permit(:name, :description)
    end
    end