# frozen_string_literal: true

require_relative "./test_helper.rb"

class CompanyTest < Minitest::Test
  def setup
    @company = Company.new(id: 1, name: "Blue Orchid", top_up: 10, email_status: true)
    @company.users = [
      UsersFixtures.user(id: 1, last_name: "Black"),
      UsersFixtures.user(id: 2, last_name: "Brown"),
      UsersFixtures.user(id: 3, last_name: "White"),
      UsersFixtures.user(id: 4, last_name: "Cera", email_status: false),
      UsersFixtures.user(id: 5, last_name: "Michael", email_status: false),
      UsersFixtures.user(id: 6, last_name: "Smith", email_status: false),
   ]
  end

  def test_total_top_ups
    assert_equal(60, @company.total_top_ups)
  end

  def test_total_top_ups_when_theres_no_users
    @company.users = []
    assert_equal(0, @company.total_top_ups)
  end

  def test_users_emailed_contains_users_that_gonna_reveice_the_email
    assert_equal(
      [1, 2, 3],
      @company.users_emailed.map(&:id),
    )
  end

  def test_users_emailed_is_empty_when_company_email_status_is_false
    @company.email_status = false
    assert_equal(
      [],
      @company.users_emailed.map(&:id),
    )
  end

  def test_users_not_emailed_contains_users_with_email_status_false
    assert_equal(
      [4, 5, 6],
      @company.users_not_emailed.map(&:id),
    )
  end

  def test_users_not_emailed_contains_all_users_if_company_email_status_is_false
    @company.email_status = false
    assert_equal(
      [1, 2, 3, 4, 5, 6],
      @company.users_not_emailed.map(&:id),
    )
  end

  def test_users_emailed_is_empty_when_company_email_status_is_false
    @company.email_status = false
    assert_equal(
      [],
      @company.users_emailed.map(&:id),
    )
  end

  def test_comparation_returns_minus_1_if_other_company_id_is_greather
    other = @company.clone
    other.id = 2
    assert_equal(-1, @company <=> other)
  end

  def test_comparation_returns_1_if_other_company_id_is_lower
    other = @company.clone
    @company.id = 2
    assert_equal(1, @company <=> other)
  end

  def test_comparation_returns_0_if_other_company_has_the_same_id
    other = @company.clone
    assert_equal(0, @company <=> other)
  end

  def test_company_is_valid_if_all_fields_are_met
    assert(@company.valid?)
  end

  def test_company_is_invalid_if_any_field_is_missing
    @company.name = nil
    refute(@company.valid?)
  end
end
