class Welcome < ActiveRecord::Base
  validates :name, :presence => true

  after_create :afterCreate
  before_create :beforeCreate
  around_create :aroundCreate 

  def afterCreate
    p "afterCreate"
  end
  def beforeCreate
    p "beforeCreate"
  end
  def aroundCreate
    p "aroundCreate"
  end
end
