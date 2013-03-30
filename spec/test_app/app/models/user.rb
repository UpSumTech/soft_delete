class User < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  include SoftDelete::Archivable

  soft_delete :if => lambda {|obj| obj.name =~ /Foo/}
end
