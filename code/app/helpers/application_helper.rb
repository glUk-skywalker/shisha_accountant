module ApplicationHelper
  def login_button
    params = {
      'async' => true,
      'src' => 'https://telegram.org/js/telegram-widget.js?4',
      'data-telegram-login' => 'shisha_accountant_bot',
      'data-size' => 'large',
      'data-radius' => '5',
      'data-auth-url' => '/auth',
      'data-request-access' => 'write'
    }
    Haml::Engine.new('%script' + params.to_s).render
  end

  def not_allowed_user_message
    <<~HEREDOC
      Sorry.. You are not allowed to use this bot yet :(
      The request on your participation has been sent to the owner.
      Please, wait until he accepts it.
      Thanks for you patience! :)
    HEREDOC
  end
end
