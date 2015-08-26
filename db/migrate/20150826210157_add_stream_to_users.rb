class AddStreamToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :stream, index: true
  end
end
