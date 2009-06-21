class UserController < ApplicationController

  layout 'documents'

	def edit
		@user = current_user
		if request.post?
			if @user.update_attributes(params[:user])
				flash[:success] = "Vos informations ont bien été modifié"
			else
				flash[:failure] = "Vos informations n'ont pas été modifié"
			end
		end
	end

  def show
		@user = current_user
  end

end
