class CreatePixels < ActiveRecord::Migration[5.2]
  def change
    create_table :pixels do |t|
      t.references  :session,       null: false, index: true
      t.string      :phone_number,  null: false
      t.string      :coordinate,    null: false

      t.timestamps

      t.index [:session_id, :coordinate, :phone_number],
              name: 'udx_on_sid_and_coordinate_and_phone_number',
              unique: true
    end
  end
end
