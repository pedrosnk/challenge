# frozen_string_literal: true

require_relative "./test_helper"

class ChallengeParserTest < Minitest::Test
  def test_returns_array_of_companies_with_users_grouped
    companies =
      ChallengeParser.perform(
        companies_io: CompaniesFixtures.company_io_1,
        users_io: UsersFixtures.users_io_company_1,
      )

    assert_equal(["Blue Orchid"], companies.map(&:name))
    assert_equal(["Jack"], companies[0].users_emailed.map(&:first_name))
    assert_equal(["Meg"], companies[0].users_not_emailed.map(&:first_name))
  end

  def test_orders_companies_by_id
    companies = 
      ChallengeParser.perform(
        companies_io: CompaniesFixtures.unordered_companies_io,
        users_io: UsersFixtures.users_io_unordered_companies,
      )

    assert_equal([1, 2, 3, 5], companies.map(&:id))
  end
end
