ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  # Using this method in an integration test will not work, because
  # TestCase helpers cannot manipulate the 'session' method directly 
  # in an integration test - instead we must 'post' to the sessions path...
  def log_in_as(user, remember_me)
    session[:user_id] = user.d
  end
end

class ActionDispatch::IntegrationTest
  # These are the methods that will be called inside integration tests.

  # Log in as a particular user.
  # Accept keyword arguments w/ default values for the password
  # and remember_me checkbox.
  def log_in_as(user, password: 'password', remember_me: '1')
    # Inside integration tests, we CAN NOT manipulate 'session' directly
    # but we can 'post' to the sessions path...
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end