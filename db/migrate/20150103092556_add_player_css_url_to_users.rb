class AddPlayerCssUrlToUsers < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :player_css_url
    end
  end
end
