class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :mailbox_hsid
      t.text :mailbox_name

      t.timestamps
    end
  end
end
