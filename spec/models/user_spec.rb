require 'rails_helper'
require 'factory_girl_rails'

describe User do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end
end
