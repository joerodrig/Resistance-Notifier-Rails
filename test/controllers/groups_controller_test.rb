require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  def test_new
    group_params = Rack::Utils.parse_nested_query params[:group]
    # @group = Group.new(group_params)
    # @group.save!
    # redirect_to @group
    post(:new, {group: { group_name: "New York"}})

    assert_response :found

    assert_not_nil Group.find_by(group_name: "New York")
  end

  test "the truth" do
    assert true
  end
end
