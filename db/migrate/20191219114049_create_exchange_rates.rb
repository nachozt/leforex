class CreateExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :exchange_rates do |t|
      t.string :from
      t.string :to
      t.float :rate
      t.datetime :date
      t.references :institution, null: false, foreign_key: true

      t.timestamps
    end
  end
end
