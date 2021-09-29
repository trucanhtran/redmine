class Category < ActiveRecord::Base
  def blacklisted?(user)
    return false if self.user_whitelist.blank?
    whitelisted = self.user_whitelist.split(",").include?
    (user.id.to_s)
    !whitelisted
  end
end
