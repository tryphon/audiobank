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
		@pages = Paginator.new(self, user.manageable_groups.size, 4, params[:page])
    @groups = user.manageable_groups.find(:all, :limit => @pages.items_per_page, :offset => @pages.current.offset)
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

end
