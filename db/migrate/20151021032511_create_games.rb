class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.Array, :players
      t.String :Winner

      t.timestamps null: false
    end
  end
end
