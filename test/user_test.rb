# frozen_string_literal: true

require_relative "./test_helper"

class UserTest < Minitest::Test
  def setup
    @user = UsersFixtures.user
  end

  def test_token_with_top_up_sums_the_top_up_to_the_token
    assert_equal(20, @user.tokens_with_top_up(10))
  end

  def test_users_should_be_sorted_by_last_name
    users = [
      UsersFixtures.user(last_name: "Beta", id: 1),
      UsersFixtures.user(last_name: "Delta", id: 2),
      UsersFixtures.user(last_name: "Alpha", id: 3),
    ]

    assert_equal([3,1,2], users.sort.map(&:id))
  end

  def test_users_should_be_sorted_by_first_name_case_last_name_is_a_match
    users = [
      UsersFixtures.user(first_name: "Lambda", id: 1),
      UsersFixtures.user(first_name: "Alpha", id: 2),
      UsersFixtures.user(first_name: "Zeta", id: 3),
    ]

    assert_equal([2, 1, 3], users.sort.map(&:id))
  end

  def test_user_is_valid_if_all_fields_are_met
    assert(@user.valid?)
  end

  def test_user_is_invalid_if_any_field_is_missing
    @user.first_name = nil
    refute(@user.valid?)
  end
end
