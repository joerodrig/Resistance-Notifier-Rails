require 'slack-notifier'

class GroupsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def show
    @users = User.where(:group_id => params[:id]).select(:name, :id)
    @group = params[:id]
  end

  def web_notify

    #TODO: Add optional param to decide how to shuffle
    roles   = Group.generate_roles(params[:users].length)
    players = Group.assign_player_roles(params[:users]).shuffle!

    unless roles.empty?
      players.each { |user| send(params_message_type, *[user, roles.shift]) }

      playerNames = players.map(&:name)

      data = {
        channel:    "#the-resistance",
        username:   "Merlin",
        text:       "Starting game with players: #{playerNames.join(', ')}",
        icon_emoji: ":ben:"
      }

      slack_post(data)
    end

    redirect_to :back
  end

  #TODO: Start a game via slack command
  def slack_notify
    notifier = Slack::Notifier.new ENV["slack_slash_command_URL"]
    notifier.channel = "@#{params[:user_name]}"
    notifier.ping "Starting game"
    render :nothing => true
  end

  def slack_message(user, role)
    data = {
      channel:    "@#{user.slack_name}",
      username:   "Merlin",
      text:       "@#{user[:slack_name]}: #{role}",
      icon_emoji: ":#{role.downcase}:"
    }
    slack_post(data)
  end

  def slack_post(data)
    notifier            = Slack::Notifier.new ENV["slack_incoming_hook_URL"]
    notifier.channel    = data[:channel]
    notifier.username   = data[:username]
    notifier.ping data[:text], icon_emoji: data[:icon_emoji]
  end

  def text_message(user, role)
    @client = Twilio::REST::Client.new(ENV['twilio_account_sid'], ENV['twilio_auth_token'])
    @client.account.messages.create(
      :body => role,
      :to   => user.phone_number,
      :from => ENV['twilio_num']
    )
  end

  def new
    group_params = Rack::Utils.parse_nested_query params[:group]
    @group = Group.new(group_params)
    @group.save!
    redirect_to @group
  end

  private
  def params_message_type
    types = %w(text_message slack_message)
    params[:message_type] if types.include?(params[:message_type])
  end
end
