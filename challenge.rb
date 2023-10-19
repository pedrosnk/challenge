# frozen_string_literal: true

require 'json'

# Company model used to store data on a Ruby object for further
# data processing.
class Company < Struct.new(:id, :name, :top_up, :email_status)
  attr_accessor :users

  # Method that returns all the users that will be emailed.
  # If the company does not send email, the method early return
  # an empty array
  # sig { returns(T::Array[User]) }
  def users_emailed
    return [] unless users
    return [] unless email_status

    users.filter(&:email_status)
  end

  # Method that returns all the users that will not be emailed
  # sig { returns(T::Array[User]) }
  def users_not_emailed
    return [] unless users
    return users unless email_status

    users.reject(&:email_status)
  end

  # Method that calculates and returns the total amount of top ups.
  # This calculation is based on the number of available users times the
  # top_up field.
  # sig { returns(Integer) }
  def total_top_ups
    return 0 unless users

    users.size * top_up
  end

  # This method is used for when the method `sort` is called on an array of Company.
  # The `sort` method knows which fields it should look up to decide how to sort the array.
  # sig { params(other: Company).returns(Integer) }
  def <=>(other)
    id <=> other.id
  end

  # Validates correctiveness of the object for the report.
  # sig { returns(T::Boolean) }
  def valid?
    result = 
      id.is_a?(Numeric) \
        && name.is_a?(String) \
        && top_up.is_a?(Numeric) \
        && (email_status.is_a?(TrueClass) || email_status.is_a?(FalseClass))

    unless result
      puts("Invalid company detected, this company will be discarted and ignored on the output")
      puts("Invalid company id: #{id}")
    end

    result
  end
end

# User model used to store User data on a Ruby object for further
# data processing.
class User < Struct.new(:id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens)

  # Method that calculates the top_up value of a token.
  # sig { params(top_up_value: Integer).returns(Integer) }
  def tokens_with_top_up(top_up_value)
    tokens + top_up_value
  end


  # This method is used for when the method `sort` is called on an array of User.
  # The `sort` method knows which fields it should look up to decide how to sort the array.
  # sig { params(other: User).returns(Integer) }
  def <=>(other)
    cmp = last_name&.downcase <=> other.last_name&.downcase
    if cmp == 0
      first_name&.downcase <=> other.first_name&.downcase
    else
      cmp
    end
  end

  # Validates correctiveness of the object for the report.
  # sig { returns(T::Boolean) }
  def valid?
    result = 
      id.is_a?(Numeric) \
        && first_name.is_a?(String) \
        && last_name.is_a?(String) \
        && email.is_a?(String) \
        && company_id.is_a?(Numeric) \
        && (active_status.is_a?(TrueClass) || active_status.is_a?(FalseClass)) \
        && (email_status.is_a?(TrueClass) || email_status.is_a?(FalseClass)) \
        && tokens.is_a?(Numeric)

    unless result
      puts("Invalid user detected, this user will be discarted and ignored on the output")
      puts("Invalid user id: #{id}")
    end

    result
  end
end

# This class is responsible for parsing a raw JSON file into Company and User objects.
# When parsing, it also claims responsibility for grouping the users into each company class
# and sorting both Company and User objects accordingly.
class ChallengeParser
  class << self
    # sig { params(companies_io: T.any(File, StringIO), users_io: T.any(File, StringIO)).returns(T::Array[Company]) }
    def perform(companies_io:, users_io:)
      companies = JSON.parse(companies_io.read, object_class: Company).filter(&:valid?)
      users_by_company = JSON.parse(users_io.read, object_class: User)
        .filter{ |user| user.valid? && user.active_status }
        .sort
        .group_by(&:company_id)

      companies.each do |company|
        company.users = users_by_company[company.id]
      end

      companies.sort
    end
  end
end

# Given an IO input and output, this class solves the challenge by reading, parsing, and processing
# the input IOs and writing the result on the output IO. For more information on the challenge,
# read the `challenge.txt` file.
class Challenge
  class << self
    # sig { params(output_io: T.any(File, StringIO), companies_io: T.any(File, StringIO), users_io: T.any(File, StringIO)).void }
    def perform(output_io:, companies_io:, users_io:)
      companies = ChallengeParser.perform(companies_io: companies_io, users_io: users_io)

      companies.each do |company|
        next if company.users.nil? || company.users.empty?

        output_io << <<~COMPANY
      
        \tCompany Id: #{company.id}
        \tCompany Name: #{company.name}
        \tUsers Emailed:
        COMPANY
      
        output_io << company.users_emailed.map do |user|
          user_output(user: user, company_top_up: company.top_up)
        end.join
      
        output_io << <<~COMPANY
        \tUsers Not Emailed:
        COMPANY

        output_io << company.users_not_emailed.map do |user|
          user_output(user: user, company_top_up: company.top_up)
        end.join

        output_io << <<~TOTAL
        \t\tTotal amount of top ups for #{company.name}: #{company.total_top_ups}
        TOTAL
      end

      # add newline at the end of the file
      output_io << "\n"
    end

    private

    # This method, when called for each User, returns printed information
    # based on the user and the company top-up.
    # sig { params(user: User, company_top_up: Integer).returns(String) }
    def user_output(user:, company_top_up:)
      <<~USER
      \t\t#{user.last_name}, #{user.first_name}, #{user.email}
      \t\t  Previous Token Balance, #{user.tokens}
      \t\t  New Token Balance #{user.tokens_with_top_up(company_top_up)}
      USER
    end
  end
end

# The block bellow is only executed when the script is called directly
if __FILE__ == $0
  begin
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

  rescue JSON::ParserError => e
    puts("Error parsing json files, please verify integrty of companies.json and users.json")
    puts("Error message: #{e.message}")

  rescue Errno::ENOENT => e
    puts "Error openning data files"
    puts "Error message: #{e.message}"
    puts "For this script to run successfully you need have companies.json and users.json"
    puts "on the same folder"
  end
end
