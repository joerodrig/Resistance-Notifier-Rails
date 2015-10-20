class GroupGroupNameShouldNotBeNil < ActiveRecord::Migration
  def change
    change_column :groups, :group_name, :string, :null => false
  end
end
