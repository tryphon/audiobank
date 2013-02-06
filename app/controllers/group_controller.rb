# -*- coding: utf-8 -*-
class GroupController < ApplicationController

  def add
    @group = Group.new(params[:group])
    if request.post?
      @group.owner = current_user
      if @group.save
        flash[:success] = "Le groupe a bien été crée"
        redirect_to :action => 'manage'
      else
        flash[:failure] = "Le groupe n'a pas été crée"
      end
    end
  end
  
  def show 
  	@group = current_user.manageable_groups.find(params[:id])
  	@manageable = true
  end  

  def manage
    @groups = current_user.manageable_groups.paginate(:page => params[:page], :per_page => 4)
  end
  
  def edit
    @group = current_user.manageable_groups.find(params[:id])
    if request.post?
      if @group.update_attributes(params[:group])
        flash[:success] = "Votre groupe a bien été édité"
        redirect_to :action => 'show', :id => @group
      else
        flash[:failure] = "Votre groupe n'a pas été édité"
      end
    end
  end
  
  def destroy
    current_user.manageable_groups.find(params[:id]).destroy
    redirect_to :action => 'manage'
  end
  
	def add_member
		@group = current_user.manageable_groups.find(params[:group])
		@group.users << User.find(params[:id].split("_")[1])
		@group.save
		render :action => "update"
	end
  
  def remove_member
		@group = current_user.manageable_groups.find(params[:group])
		@group.users.delete(User.find(params[:id].split("_")[1]))
		@group.save
		render :action => "update"
  end  

  def search_nonmembers
    group = current_user.manageable_groups.find(params[:id])
    query = params[:q].downcase

    candidates = group.nonmembers.select do |user|
      user.match_name? query
    end

    render :json => candidates.to_json(:only => :id, :methods => :full_name)
  end	

end
