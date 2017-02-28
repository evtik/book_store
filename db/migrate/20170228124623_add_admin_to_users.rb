class AddAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean

    User.create! do |u|
      u.email = 'admin@example.com'
      u.password = '11111111'
      u.admin = true
    end
  end
end
