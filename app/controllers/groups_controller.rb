class GroupsController < ApplicationController
  def index
  end

  def view
  end

  def show
    @users = User.where(:group_id => params[:id]).select(:name,:id)
  end
end
