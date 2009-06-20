# -*- coding: utf-8 -*-
class GroupController < ApplicationController

	layout 'documents'

  def add
    @group = Group.new(params[:group])
    if request.post?
      @group.owner = User.find(session[:user])
      if @group.save
        flash[:success] = "Le groupe a bien été crée"
        redirect_to :action => 'manage'
      else
        flash[:failure] = "Le groupe n'a pas été crée"
      end
    end
  end
  
  def show 
    user = User.find(session[:user])
  	@group = user.manageable_groups.find(params[:id])
  	@manageable = true
  end  

  def manage
    user = User.find(session[:user])
    @groups = user.manageable_groups.paginate(:page => params[:page], :per_page => 4)
  end
  
  def edit
    @group = User.find(session[:user]).manageable_groups.find(params[:id])
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
    User.find(session[:user]).manageable_groups.find(params[:id]).destroy
    redirect_to :action => 'manage'
  end
  
	def add_member
		@group = User.find(session[:user]).manageable_groups.find(params[:group])
		@group.users << User.find(params[:id].split("_")[1])
		@group.save
		render :action => "update"
	end
  
  def remove_member
		@group = User.find(session[:user]).manageable_groups.find(params[:group])
		@group.users.delete(User.find(params[:id].split("_")[1]))
		@group.save
		render :action => "update"
  end  

  def search_nonmembers
    input = params[:input].nil? ? "" : params[:input].downcase
    id = params[:id]
    
    @people = Group.find(id).nonmembers.delete_if do |user|
      not (user.name.downcase.include?(input) or (!user.username.nil? and user.username.downcase.include?(input)))
    end
    render :partial => "users/people", :object => @people, 
      :locals => { :empty => "Aucun utilisateur ne correspond", :draggable => true }
  end	

end
