class CreateUserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :profile
      t.string :password
      t.string :role
    end
  end
end
