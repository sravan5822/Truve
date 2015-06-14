require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { avatar_url: @user.avatar_url, birthday: @user.birthday, city: @user.city, country: @user.country, email: @user.email, fb_oauth_token: @user.fb_oauth_token, fb_refresh_token: @user.fb_refresh_token, fb_user_id: @user.fb_user_id, friends_of_friends_hash: @user.friends_of_friends_hash, gender: @user.gender, meta: @user.meta, recieve_emails: @user.recieve_emails, share_with_friends_of_friends: @user.share_with_friends_of_friends, time: @user.time }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { avatar_url: @user.avatar_url, birthday: @user.birthday, city: @user.city, country: @user.country, email: @user.email, fb_oauth_token: @user.fb_oauth_token, fb_refresh_token: @user.fb_refresh_token, fb_user_id: @user.fb_user_id, friends_of_friends_hash: @user.friends_of_friends_hash, gender: @user.gender, meta: @user.meta, recieve_emails: @user.recieve_emails, share_with_friends_of_friends: @user.share_with_friends_of_friends, time: @user.time }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
