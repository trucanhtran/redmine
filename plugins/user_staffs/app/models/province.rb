class Province < ActiveRecord::Base
    has_one :location
    has_many :districts
end
