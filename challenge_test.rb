require 'minitest/autorun'
require_relative './challenge'

require 'stringio'

class ChallengeTest < Minitest::Test
  def test_writes_company_1_output
    expectation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUsers Emailed:
    \t\tWhite, Jack, jack.white@test.com
    \t\t  Previous Token Balance, 20
    \t\t  New Token Balance 30
    \tUsers Not Emailed:
    \t\tWhite, Meg, meg.white@test.com
    \t\t  Previous Token Balance, 30
    \t\t  New Token Balance 40
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
      output.string,
    )
  end

  def test_output_companies_ordered_by_id
    expectation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUsers Emailed:
    \t\tWhite, Jack, jack.white@test.com
    \t\t  Previous Token Balance, 20
    \t\t  New Token Balance 60
    \tUsers Not Emailed:
    \t\tTotal amount of top ups for Blue Orchid: 40
    
    \tCompany Id: 2
    \tCompany Name: The Nurse
    \tUsers Emailed:
    \t\tWhite, Meg, meg.white@test.com
    \t\t  Previous Token Balance, 30
    \t\t  New Token Balance 50
    \tUsers Not Emailed:
    \t\tTotal amount of top ups for The Nurse: 20
    
    \tCompany Id: 3
    \tCompany Name: My Doorbell
    \tUsers Emailed:
    \t\tWhite, John, john.white@test.com
    \t\t  Previous Token Balance, 22
    \t\t  New Token Balance 72
    \tUsers Not Emailed:
    \t\tTotal amount of top ups for My Doorbell: 50
    
    \tCompany Id: 5
    \tCompany Name: Little Gosth
    \tUsers Emailed:
    \t\tWhite, Mary, mary.white@test.com
    \t\t  Previous Token Balance, 25
    \t\t  New Token Balance 55
    \tUsers Not Emailed:
    \t\tTotal amount of top ups for Little Gosth: 30

    EXPECTATION

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.unordered_companies,
      users_io: UsersFixtures.users_unordered_companies,
    )

    assert_equal(
      expectation,
      output.string,
    )
  end

  def test_output_users_ordered_by_last_name
    expectation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUsers Emailed:
    \t\tBlack, Rebeca, rebeca.black@test.com
    \t\t  Previous Token Balance, 20
    \t\t  New Token Balance 30
    \t\tGrohl, Dave, dave.grohl@test.com
    \t\t  Previous Token Balance, 30
    \t\t  New Token Balance 40
    \t\tWhite, Jack, jack.white@test.com
    \t\t  Previous Token Balance, 10
    \t\t  New Token Balance 20
    \tUsers Not Emailed:
    \t\tHarrison, George, george.harrison@test.com
    \t\t  Previous Token Balance, 60
    \t\t  New Token Balance 70
    \t\tLenon, John, rebeca.black@test.com
    \t\t  Previous Token Balance, 50
    \t\t  New Token Balance 60
    \t\tMcCartney, Paul, paul@test.com
    \t\t  Previous Token Balance, 40
    \t\t  New Token Balance 50
    \t\tTotal amount of top ups for Blue Orchid: 60

    EXPECTATION

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.company_1,
      users_io: UsersFixtures.users_company_1_unordered,
    )

    assert_equal(
      expectation,
      output.string,
    )
  end

  def test_does_not_send_email_if_company_email_status_is_false
    expecation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUsers Emailed:
    \tUsers Not Emailed:
    \t\tWhite, Jack, jack.white@test.com
    \t\t  Previous Token Balance, 20
    \t\t  New Token Balance 30
    \t\tWhite, Meg, meg.white@test.com
    \t\t  Previous Token Balance, 30
    \t\t  New Token Balance 40
    \t\tTotal amount of top ups for Blue Orchid: 20

    EXPECTATION

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.company_1_email_status_false,
      users_io: UsersFixtures.users_company_1
    )

    assert_equal(
      expecation,
      output.string,
    )
  end

  def test_does_not_show_inactive_users
    expecation = <<~EXPECTATION

    \tCompany Id: 1
    \tCompany Name: Blue Orchid
    \tUsers Emailed:
    \tUsers Not Emailed:
    \t\tWhite, Bela, bela.white@test.com
    \t\t  Previous Token Balance, 30
    \t\t  New Token Balance 40
    \t\tTotal amount of top ups for Blue Orchid: 10

    EXPECTATION

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.company_1,
      users_io: UsersFixtures.users_company_1_inactive_users
    )

    assert_equal(
      expecation,
      output.string,
    )
  end

  def test_example_parity
    expectation = File.read("example_output.txt")
    companies_io = File.open("companies.json", "r")
    users_io = File.open("users.json", "r")

    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: companies_io,
      users_io: users_io,
    )

    assert_equal(
      expectation,
      output.string,
    )

    [companies_io, users_io].each(&:close)
  end

  def test_does_not_output_companies_with_no_active_users
    output = StringIO.open

    Challenge.perform(
      output_io: output,
      companies_io: CompaniesFixtures.company_1,
      users_io: UsersFixtures.empty_users,
    )

    assert(output.string.strip.empty?)
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

    def company_1_email_status_false
      StringIO.open(
        <<~JSON
          [{"id": 1, "name": "Blue Orchid", "top_up": 10, "email_status": false}]
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

    def users_unordered_companies
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
              "company_id": 2,
              "email_status": true,
              "active_status": true,
              "tokens": 30
            },
            {
              "id": 3,
              "first_name": "John",
              "last_name": "White",
              "email": "john.white@test.com",
              "company_id": 3,
              "email_status": true,
              "active_status": true,
              "tokens": 22
            },
            {
              "id": 4,
              "first_name": "Mary",
              "last_name": "White",
              "email": "mary.white@test.com",
              "company_id": 5,
              "email_status": true,
              "active_status": true,
              "tokens": 25
            }
          ]
        JSON
      )
    end

    def empty_users
      StringIO.open("[]")
    end

    def users_company_1_unordered
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
              "tokens": 10
            },
            {
              "id": 2,
              "first_name": "Rebeca",
              "last_name": "Black",
              "email": "rebeca.black@test.com",
              "company_id": 1,
              "email_status": true,
              "active_status": true,
              "tokens": 20
            },
            {
              "id": 3,
              "first_name": "Dave",
              "last_name": "Grohl",
              "email": "dave.grohl@test.com",
              "company_id": 1,
              "email_status": true,
              "active_status": true,
              "tokens": 30
            },
            {
              "id": 4,
              "first_name": "Paul",
              "last_name": "McCartney",
              "email": "paul@test.com",
              "company_id": 1,
              "email_status": false,
              "active_status": true,
              "tokens": 40
            },
            {
              "id": 5,
              "first_name": "John",
              "last_name": "Lenon",
              "email": "rebeca.black@test.com",
              "company_id": 1,
              "email_status": false,
              "active_status": true,
              "tokens": 50
            },
            {
              "id": 6,
              "first_name": "George",
              "last_name": "Harrison",
              "email": "george.harrison@test.com",
              "company_id": 1,
              "email_status": false,
              "active_status": true,
              "tokens": 60
            }
          ]
        JSON
      )
    end

    def users_company_1_inactive_users
      StringIO.open(
        <<~JSON
          [
            {
              "id": 1,
              "first_name": "John",
              "last_name": "Doe",
              "email": "john.doe@test.com",
              "company_id": 1,
              "email_status": true,
              "active_status": false,
              "tokens": 20
            },
            {
              "id": 2,
              "first_name": "Alice",
              "last_name": "White",
              "email": "alice.white@test.com",
              "company_id": 1,
              "email_status": false,
              "active_status": false,
              "tokens": 30
            },
            {
              "id": 3,
              "first_name": "Bela",
              "last_name": "White",
              "email": "bela.white@test.com",
              "company_id": 1,
              "email_status": false,
              "active_status": true,
              "tokens": 30
            }
          ]
        JSON
      )
    end
  end
end
