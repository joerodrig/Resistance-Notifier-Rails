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

    roles = group.generate_roles(5)
    expect(roles.count "Spy" ).to       eq 2
    expect(roles.count "Resistance").to eq 3

    roles = group.generate_roles(6)
    expect(roles.count "Spy" ).to       eq 2
    expect(roles.count "Resistance").to eq 4

    roles = group.generate_roles(7)
    expect(roles.count "Spy" ).to       eq 3
    expect(roles.count "Resistance").to eq 4

    roles = group.generate_roles(8)
    expect(roles.count "Spy" ).to       eq 3
    expect(roles.count "Resistance").to eq 5

    roles = group.generate_roles(9)
    expect(roles.count "Spy" ).to       eq 3
    expect(roles.count "Resistance").to eq 6

    roles = group.generate_roles(10)
    expect(roles.count "Spy" ).to       eq 4
    expect(roles.count "Resistance").to eq 6
  end

  it "updates role count for a user when assigning a role" do
    group        = create(:group)
    player_one   = create(:user)
    player_two   = create(:user)
    player_three = create(:user)
    player_four  = create(:user)
    player_five  = create(:user)

    group.assign_player_roles([player_one.id,
                               player_two.id,
                               player_three.id,
                               player_four.id,
                               player_five.id
                             ])
  end
end
