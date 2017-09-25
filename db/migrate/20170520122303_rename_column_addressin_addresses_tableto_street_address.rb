class RenameColumnAddressinAddressesTabletoStreetAddress < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :address, :street_address
  end
end
