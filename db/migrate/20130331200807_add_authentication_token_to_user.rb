class AddAuthenticationTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :authentication_token
    end

    User.reset_column_information

    User.find_each do |user|
      user.update_attribute :authentication_token, user.generate_authentication_token
    end
  end
end
