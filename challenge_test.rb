require 'minitest/autorun'
require_relative './challenge'

require 'stringio'

class ChallengeTest < Minitest::Test
  def test_writes_company_1_output
    expectation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUser Emailed:
    \t\tWhite, Jack, jack.white@test.com
    \t\t  Previous Token Balance: 20
    \t\t  New Token Balance: 30
    \tUser Not Emailed:
    \t\tWhite, Meg, meg.white@test.com
    \t\t  Previous Token Balance: 30
    \t\t  New Token Balance: 40
    \t\tTotal amount of top ups for Blue Orchid: 20
    EXPECTATION

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.company_1,
      users_io: UsersFixtures.users_company_1,
    )

    assert_equal(
      expectation,
      output.string
    )
  end

  def test_output_companies_ordered_by_id
    expectation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUser Emailed:
    \tUser Not Emailed:
    \t\tTotal amount of top ups for Blue Orchid: 0
    
    \tCompany Id: 2
    \tCompany Name: The Nurse
    \tUser Emailed:
    \tUser Not Emailed:
    \t\tTotal amount of top ups for The Nurse: 0
    
    \tCompany Id: 3
    \tCompany Name: My Doorbell
    \tUser Emailed:
    \tUser Not Emailed:
    \t\tTotal amount of top ups for My Doorbell: 0
    
    \tCompany Id: 5
    \tCompany Name: Little Gosth
    \tUser Emailed:
    \tUser Not Emailed:
    \t\tTotal amount of top ups for Little Gosth: 0
    EXPECTATION

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.unordered_companies,
      users_io: UsersFixtures.empty_users,
    )

    assert_equal(
      expectation,
      output.string
    )
  end
end

class CompaniesFixtures
  class << self
    def company_1
      StringIO.open(
        <<~JSON
          [{"id": 1, "name": "Blue Orchid", "top_up": 10, "email_status": true}]
        JSON
      )
    end

    def unordered_companies
      StringIO.open(
        <<~JSON
          [
            {"id": 5, "name": "Little Gosth", "top_up": 30, "email_status": true},
            {"id": 2, "name": "The Nurse", "top_up": 20, "email_status": true},
            {"id": 1, "name": "Blue Orchid", "top_up": 40, "email_status": true},
            {"id": 3, "name": "My Doorbell", "top_up": 50, "email_status": true}
          ]
        JSON
      )
    end
  end
end

class UsersFixtures
  class << self
    def users_company_1
      StringIO.open(
        <<~JSON
          [
            {
              "id": 1,
              "first_name": "Jack",
              "last_name": "White",
              "email": "jack.white@test.com",
              "company_id": 1,
              "email_status": true,
              "active_status": true,
              "tokens": 20
            },
            {
              "id": 2,
              "first_name": "Meg",
              "last_name": "White",
              "email": "meg.white@test.com",
              "company_id": 1,
              "email_status": false,
              "active_status": true,
              "tokens": 30
            }
          ]
        JSON
      )
    end

    def empty_users
      StringIO.open("[]")
    end
  end
end
