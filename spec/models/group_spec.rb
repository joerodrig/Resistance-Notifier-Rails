require 'spec_helper'
require 'factory_girl_rails'

describe 'Group' do
  it "has a valid factory" do
    create(:group).should be_valid
  end
  it "is invalid without a group name"
  it "returns its group name as a string"
end
