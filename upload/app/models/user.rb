class User < ActiveRecord::Base
  attr_accessible :avatar, :name
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end
