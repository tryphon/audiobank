class DocumentsController < InheritedResources::Base

  actions :all
  respond_to :xml, :json

  protected

  def begin_of_association_chain
    current_user
  end

  def collection
		current_user.documents.paginate :page => params[:page], :per_page => (params[:per_page] or 10)
	end

end
