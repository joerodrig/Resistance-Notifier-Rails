class TrackRoleCountPerUser < ActiveRecord::Migration
  def change
    add_column :users, :resistance_count, :integer, :default => 0
    add_column :users, :spy_count, :integer, :default => 0
  end
end
