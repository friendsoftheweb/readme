# Template script for scrubbing sensitive data from a copied database.
#
# Requires 'faker' for providing mock data and 'ruby-progressbar'.
#
# Use this as a starting point, altering any sensitive types.

namespace "data" do

  # This task scrambles any data that may be sensitive and is intended to be used after
  # importing any database that may contain real sensitive information.
  #
  # Things like names and addresses are replaced with new randomized data. Things like
  # sessions and password reset tokens that may still be viable are just destroyed.
  desc "Anonymize all sensitive data. Use after copying a production database."
  task "anonymize" => "environment" do

    if Rails.env.production?
      puts "You're attempting to anonymize sensitive data in the production environment. Let's not do that."
      exit 1
    end

    puts "Anonymizing potentially sensitive data."

    record_count = User.count + Order.count

    progressbar = ProgressBar.create({
      total: record_count,
      format: "%e |%B|"
    })

    User.find_each do |user|
      user.update!({
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "password",
        password_confirmation: "password",
        password_reset_code: nil
      })
      progressbar.increment
    end

    Order.find_each do |order|
      order.update_columns({
        card_last4: Faker::Number.number(4),
        tracking_number: Faker::Number.number(10).to_s
      })
      progressbar.increment
    end
  end
end
