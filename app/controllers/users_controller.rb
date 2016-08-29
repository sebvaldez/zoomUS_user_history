class UsersController < ApplicationController

	def find_users
		@total_users = User.all.size
	end

	def search
		@users = User.search(params[:search_param])
		if @users
			render partial: 'lookup'

		else
			render status: :not_found, nothing: true
		end
	end

	def show
		@user = User.find(params[:id])
	end


end
