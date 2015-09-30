class UsersController < ApplicationController
  def new
    user_params = {:name => params[:name], :phone_number => params[:phone_number], :group_id => params[:group_id]}
    @user = User.new(user_params)
    @user.save!
    @group = Group.find(params[:group_id])
    redirect_to @group
  end
end
