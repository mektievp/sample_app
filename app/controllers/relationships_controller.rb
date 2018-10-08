class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		respond_to do |format|
			# What this says is, “if the client wants JS in response to this action,
			# just respond as we would have before, but if the client wants HTML,
			# return the updated follower count and follow button in HTML format.” 
			# (Rails determines the desired response format from the HTTP Accept header
			# submitted by the client.)
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		respond_to do |format|
			# What this says is, “if the client wants JS in response to this action,
			# just respond as we would have before, but if the client wants HTML,
			# return the updated follower count and follow button in HTML format.” 
			# (Rails determines the desired response format from the HTTP Accept header
			# submitted by the client.)
			format.html { redirect_to @user }
			format.js
		end
	end
end
