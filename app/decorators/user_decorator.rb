class UserDecorator
  def initialize(user)
    @user = user
  end

  def nick
    @user.username ? '@' + @user.username : ''
  end

  def name(show = [:first_name])
    items = []
    items << @user.first_name if @user.first_name && show.include?(:first_name)
    items << nick if @user.username && show.include?(:username)
    items << @user.last_name if @user.last_name && show.include?(:last_name)
    items.join(' ')
  end
end
