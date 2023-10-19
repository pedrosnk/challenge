# frozen_string_literal: true

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


