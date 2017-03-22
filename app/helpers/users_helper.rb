module UsersHelper
  # Returns the full name for an user.
  def full_name_for(user)
    "#{user.first_name} #{user.last_name}"
  end
end

