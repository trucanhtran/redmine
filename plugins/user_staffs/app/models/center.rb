class Center < ActiveRecord::Base
  has_many :users
  has_many :departments, through: :users
end
