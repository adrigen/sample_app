require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name:"Test User", email:"test@user.com", password:"foobalow", password_confirmation:"foobalow")
  end
  test "should be valid" do
    assert @user.valid?
  end
  test "should not be valid" do
    @user.name = ""
    assert_not @user.valid?
  end
  test "should not be present" do 
    @user.name = "    "
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  test "email vailidation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test "user validation should reject invalid addresses" do 
    invalid_addresses = %w[apple@orange,com no_at_dot.com no@dot. foo@bar_baz.com foo@bar+bax.com foo@bar..baz]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should not be valid"
    end
  end
  test "user name should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  test "emails should save in lowercase" do 
    uppercase_address = "Foo@bar.com"
    @user.email = uppercase_address
    @user.save
    @user.reload
    assert @user.email = uppercase_address.downcase
  end
  test "password should not be blank" do 
    @user.password = " " * 6
    assert_not @user.valid?
  end
  test "password should have min length" do 
    @user.password = "a" * 5
    assert_not @user.valid?
  end
end



