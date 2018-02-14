# Template script for creating an admin user. Useful after setting up a project or after
# importing a database to test.
namespace "data" do
  desc "Create a generic admin user"
  task "create_admin_user" => "environment" do
    if User.find_by(email: "admin@example.com").nil?
      User.create!(name: "admin", email: "admin@example.com", password: "password", password_confirmation: "password", admin: true)
      puts("You can sign in as 'admin@exmaple.com', 'password'")
    end
  end
end
