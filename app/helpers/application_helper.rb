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
end
