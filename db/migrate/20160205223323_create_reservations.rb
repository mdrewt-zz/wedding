class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.integer   :attending
      t.text      :comments
      t.string    :edit_key

      t.timestamps null: false
    end
  end
end
