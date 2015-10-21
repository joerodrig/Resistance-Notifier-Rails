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

    roles = group.generate_roles(4)
    expect(roles).to                    eq []

    roles = group.generate_roles(11)
    expect(roles).to                    eq []

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

  it "assigns players their roles" do
    group        = create(:group)
    player_one   = create(:user)
    player_two   = create(:user)
    player_three = create(:user)
    player_four  = create(:user)
    player_five  = create(:user)

    players = group.assign_player_roles([
                player_one.id,
                player_two.id,
                player_three.id,
                player_four.id,
                player_five.id
              ])

    expect(players.is_a?(Array)).to be_truthy
    expect(players.first).to include(:player, :role)
  end

  it "updates a players role count" do
    group = create(:group)
    data = { player: create(:user), role: "Resistance" }
    group.increment_role_count(data)
    expect(data[:player][:resistance_count]).to eq 1
  end

end
