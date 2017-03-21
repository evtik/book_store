class RenameTypeToAddressType < ActiveRecord::Migration[5.0]
  def change
    rename_column :addresses, :type, :address_type
  end
end
