# frozen_string_literal: true

class AddColumnBasicInfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_column :users, :user_name, :string
    add_column :users, :self_intro, :text
    add_column :users, :web_site, :string
  end
end
