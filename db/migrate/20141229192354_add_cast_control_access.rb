class AddCastControlAccess < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.column :casts_token_secret, :string
    end
    change_table(:documents) do |t|
      t.column :protected_casts, :boolean
    end
  end
end
