class UploadsController < InheritedResources::Base
  belongs_to :document, :singleton => true

  actions :all
  respond_to :xml, :json

  def confirm
    upload.confirm!
    respond_with document
  end

  protected

  alias_method :upload, :resource
  alias_method :document, :parent

  def begin_of_association_chain
    current_user
  end

end
