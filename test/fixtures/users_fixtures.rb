# frozen_string_literal: true

class UsersFixtures
  class << self
    def user(params={})
      user_params = {
        id: 1,
        first_name: "John",
        last_name: "Doe",
        email: "john.dow@test.com",
        company_id: 1,
        email_status: true,
        active_status: true,
        tokens: 10
      }
      user_params.merge!(params)
      User.new(**user_params)
    end

    def users_io_company_1
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

    def users_io_unordered_companies
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

    def empty_users_io
      StringIO.open("[]")
    end

    def users_io_company_1_unordered
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

    def users_io_company_1_inactive_users
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
