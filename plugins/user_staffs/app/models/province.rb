class Province < ActiveRecord::Base
    has_one :location
end
