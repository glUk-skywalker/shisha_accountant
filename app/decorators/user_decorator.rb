class UserDecorator
  def initialize(user)
    @user = user
  end

  def nick
    @user.username ? '@' + @user.username : ''
  end

  def name(show = [:first_name])
    items = []
    items << @user.first_name if show.include?(:first_name)
    items << nick             if show.include?(:username)
    items << @user.last_name  if show.include?(:last_name)
    items.compact!
    items.reject!(&:empty?)
    items.join(' ')
  end
end
