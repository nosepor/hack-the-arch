class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :destroy, :edit, :update]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: [:index, :destroy]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		user = User.find(params[:id])
		if user.activated? 
# Uncomment if users can only view their own profiles
#			if current_user?(user)
				@user = user
#			else
#     	message  = "Access Denied. "
#     	message += "You can only view your profile."
#     	flash[:warning] = message
# 			redirect_to root_url
# 		end
		else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
			redirect_to root_url
		end
	end

  def new
		@user = User.new
  end

	def create
		@user = User.new(user_params)
		if @user.save
			@user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
		else
			render 'new'
		end
	end

	def destroy
		User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Changes saved successfully"
			redirect_to @user
		else
			render 'edit'
		end
	end

	private
		def user_params
			params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
		end

		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end