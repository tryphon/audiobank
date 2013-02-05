# -*- coding: utf-8 -*-
class UserController < ApplicationController

	def edit
		@user = current_user
		if request.post?
			if @user.update_attributes(params[:user])
				flash[:success] = "Vos informations ont bien été modifiées"
        redirect_to :action => :show
			else
				flash[:failure] = "Vos informations n'ont pas été modifiées"
			end
		end
	end

  def show
		@user = current_user
  end

end
