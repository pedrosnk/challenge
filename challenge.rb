# frozen_string_literal: true

require 'json'

class Challenge
  class << self
    def perform(output_io:, companies_io:, users_io:)
      companies = JSON.parse(companies_io.read, symbolize_names: true)
      users = JSON.parse(users_io.read, symbolize_names: true)

      companies.each do |company|
        company[:users] =
          users
          .filter { |user| user[:company_id] == company[:id] && user[:active_status] }
          .sort_by { |user| user[:last_name].downcase }
      end
      
      companies.sort_by! { |c| c[:id] }

      companies.each do |company|
        users_emailed = company[:users].filter do |user|
          user[:email_status] && company[:email_status]
        end
        users_not_emailed = company[:users].reject do |user|
          user[:email_status] && company[:email_status]
        end
        total_top_ups = company[:users].size * company[:top_up]
      
        output_io << <<~COMPANY
      
        \tCompany Id: #{company[:id]}
        \tCompany Name: #{company[:name]}
        \tUser Emailed:
        COMPANY
      
        output_io << users_emailed.map do |user|
          <<~USER
          \t\t#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}
          \t\t  Previous Token Balance: #{user[:tokens]}
          \t\t  New Token Balance: #{user[:tokens] + company[:top_up]}
          USER
        end.join
      
        output_io << <<~COMPANY
        \tUser Not Emailed:
        COMPANY
        output_io << users_not_emailed.map do |user|
          <<~USER
          \t\t#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}
          \t\t  Previous Token Balance: #{user[:tokens]}
          \t\t  New Token Balance: #{user[:tokens] + company[:top_up]}
          USER
        end.join
        output_io << <<~TOTAL
        \t\tTotal amount of top ups for #{company[:name]}: #{total_top_ups}
        TOTAL
      end
    end
  end
end

# calling script direclty
if __FILE__ == $0
  output_io = File.open("output.txt", "w")
  companies_io = File.open("companies.json", "r")
  users_io = File.open("users.json", "r")
  Challenge.perform(
    output_io: output_io,
    companies_io: companies_io,
    users_io: users_io,
  )

  # close files after execution
  [output_io, companies_io, users_io].each(&:close)
end