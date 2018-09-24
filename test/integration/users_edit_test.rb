require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path @user
    assert_template 'users/edit'
    patch user_path @user, params: { user: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'

    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger', 'The form contains 4 errors'
    assert_select "li", "Name can't be blank"
    assert_select "li", "Email is invalid"
    assert_select "li", "Password confirmation doesn't match Password"
    min_validation = User.validators_on(:password).find do |v|
      v.options.key?(:minimum)
    end
    min_length = min_validation.options[:minimum]
    assert_select "li", "Password is too short (minimum is #{min_length} characters)"
  end

  test "successful edit with friendly fowarding" do
    get edit_user_path @user
    log_in_as @user
    assert_redirected_to edit_user_url @user
    assert session[:forwarding_url].nil?
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path @user, params: { user: { name: name,
                                                email: email,
                                                password: "",
                                                password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    # reloads the user's values from the db and confirms they were
    # successfully updated.
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
