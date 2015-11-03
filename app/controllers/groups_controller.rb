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
    @group  = Group.find(params[:id])
    players = @group.assign_player_roles(params[:users])

    player_names = []
    if (params[:notifySpies])
      spies = []
      players.each do |data|
        spies << data[:player][:name] if data[:role] == "Spy"
      end
    end

    players.shuffle!.each do |data|
      if (params[:notifySpies] && data[:role] == "Spy")
        otherSpies = spies.reject { |v| v == data[:player][:name] }
        spy_notification = "#{spies.join(', ')}"
        send(params_message_type, *[data[:player], spy_notification])
      else
        send(params_message_type, *[data[:player], data[:role]])
      end

      player_names << data[:player][:name]
      @group.increment_role_count(data)
    end

    data = {
      channel:    "#the-resistance",
      username:   "Merlin",
      text:       "Starting game with players: #{player_names.shuffle.join(', ')}",
      icon_emoji: ":ben:"
    }

    slack_post(data)

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
      icon_emoji: ":ben:"
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
