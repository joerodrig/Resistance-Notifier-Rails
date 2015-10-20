require 'rails_helper'
require 'factory_girl_rails'

describe Group do
  it "has a valid factory" do
    expect(create(:group)).to be_valid
  end
  
  it "is invalid without a group name"

  it "returns its group name as a string" do
    create(:group).group_name
  end

  it "generates proper role count based off of number of players" do
    group = create(:group)

    # Testing a 5 person game
    roles = Group.generate_roles(5)
    expect(roles.count "Spy" ).to eq 2
    expect(roles.count "Resistance").to eq 3

    # Testing a 6 person game
    roles = Group.generate_roles(6)
    expect(roles.count "Spy" ).to eq 2
    expect(roles.count "Resistance").to eq 4

    # Testing a 7 person game
    roles = Group.generate_roles(7)
    expect(roles.count "Spy" ).to eq 3
    expect(roles.count "Resistance").to eq 4

    # Testing a 8 person game
    roles = Group.generate_roles(8)
    expect(roles.count "Spy" ).to eq 3
    expect(roles.count "Resistance").to eq 5

    # Testing a 9 person game
    roles = Group.generate_roles(9)
    expect(roles.count "Spy" ).to eq 3
    expect(roles.count "Resistance").to eq 6

    # Testing a 10 person game
    roles = Group.generate_roles(10)
    expect(roles.count "Spy" ).to eq 4
    expect(roles.count "Resistance").to eq 6
  end
end
