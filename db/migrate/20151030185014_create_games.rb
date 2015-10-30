class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :spies, array: true, default: []
      t.text :resistance, array: true, default: []
      t.string :winner
    end
  end
end
