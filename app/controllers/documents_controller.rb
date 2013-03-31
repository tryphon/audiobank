class DocumentsController < InheritedResources::Base
  actions :all
  respond_to :html, :xml, :json

  protected

  def begin_of_association_chain
    current_user
  end

  def collection
		current_user.documents.paginate :page => params[:page], :per_page => 4
	end
end
