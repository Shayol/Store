module UsersHelpers
  def login_user
    user = create(:user)
    user.confirmed_at = Time.now
    user.save
    login_as(user, :scope => :user)
    user
  end
end