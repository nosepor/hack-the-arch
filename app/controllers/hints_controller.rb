class HintsController < ApplicationController
	before_action :admin_user, only: [:new, :create, :edit, :update]

	def new
		@hint = Hint.new
		@problem = Problem.find(params[:problem_id])
	end

	def create
		@hint = Hint.new(hint_params)
		@problem = Problem.find(params[:hint][:problem_id])
		if @hint.save
			@problem.add(@hint.id)
			flash[:success] = "Hint saved!"
			redirect_to edit_problem_path(@problem)
		else
			render 'new'
		end
	end

	def edit
		@hint = Hint.find(params[:hint_id])
		@problem = Problem.find(params[:problem_id])
	end

	def update
		@hint = Hint.find(params[:id])
		if @hint.update_attributes(hint_params)
			@problem = Problem.find(params[:hint][:problem_id])
			redirect_to edit_problem_path(@problem)
		else
			render 'edit'
		end
	end

	private
		def hint_params
			params.require(:hint).permit(:priority, :hint, :points)
		end

		def admin_user
      unless logged_in? && current_user.admin?
				store_location
				flash[:danger] = "Access Denied."
				redirect_to login_url
			end
    end
end