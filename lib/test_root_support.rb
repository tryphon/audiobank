class TestRootSupport

  attr_accessor :model

  def initialize(model)
    @model = model
  end

  def test_root
    Rails.root + "tmp" + model.name.pluralize.parameterize
  end

  def prepare
    test_root.mkpath
    model.root = test_root
  end
  alias_method :before, :prepare

  def clean
    test_root.rmtree
  end
  alias_method :after, :clean

  @@supports = nil

  def self.supports(models = [])
    if models.present?
      @@supports = models.collect do |model|
        TestRootSupport.new(model)
      end
    end

    @@supports
  end

  def self.all(method, *models)
    supports(models).each do |support|
        support.send(method)
    end
  end

end
