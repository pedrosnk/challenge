require 'json'
require 'stringio'

companies = JSON.parse(File.read('./companies.json'), symbolize_names: true)
users = JSON.parse(File.read('./users.json'), symbolize_names: true)

companies.each do |company|
  company[:users] =
    users
    .filter { |user| user[:company_id] == company[:id] && user[:active_status] }
    .sort_by { |user| user[:last_name].downcase }
end

companies.sort_by! { |c| c[:id] }

file = File.open("output.txt", "w")

companies.each do |company|
  users_emailed = company[:users].filter do |user|
    user[:email_status] && company[:email_status]
  end
  users_not_emailed = company[:users].reject do |user|
    user[:email_status] && company[:email_status]
  end
  total_top_ups = company[:users].size * company[:top_up]

  file << <<~COMPANY

  \tCompany Id: #{company[:id]}
  \tCompany Name: #{company[:name]}
  \tUser Emailed:
  COMPANY

  file << users_emailed.map do |user|
    <<~USER
    \t\t#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}
    \t\t  Previous Token Balance: #{user[:tokens]}
    \t\t  New Token Balance: #{user[:tokens] + company[:top_up]}
    USER
  end.join

  file << <<~COMPANY
  \tUser Not Emailed:
  COMPANY
  file << users_not_emailed.map do |user|
    <<~USER
    \t\t#{user[:last_name]}, #{user[:first_name]}, #{user[:email]}
    \t\t  Previous Token Balance: #{user[:tokens]}
    \t\t  New Token Balance: #{user[:tokens] + company[:top_up]}
    USER
  end.join
  file << <<~TOTAL
  \t\tTotal amount of top ups for #{company[:name]}: #{total_top_ups}
  TOTAL
end

file.close
