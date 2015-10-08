class GroupsController < ApplicationController
  def index
  end

  def show
    @users = User.where(:group_id => params[:id]).select(:name,:id)
    @group = params[:id]
  end

  def message
    spies      = params[:spies].to_i
    resistance = params[:resistance].to_i
    roles      = []
    players    = []

    if (spies + resistance > 0)

      # Add all roles to an array
      for i in 0..(spies-1)
        roles.push("Spy")
      end
      for resistance in 0..(resistance-1)
        roles.push("Resistance")
      end

      # Shuffle roles
      roles = roles.shuffle

      # Shuffle users
      params[:users] = params[:users].shuffle

      params[:users].each do |userId|

        # Retrieve user profile and message based off params
        user = User.find(userId)
        players.push(user[:name])
        if (params[:message_type] == "text_message")
          text_message(user, roles.first)
        elsif (params[:message_type] == "slack")
          slack_message(user, roles.first)
        end

        # Delete the role from the array
        roles.shift
      end

      data = {
              "channel"   => "#the-resistance",
              "username"  => "Merlin",
              "text"      => "Starting game with players: #{players.join(',')}",
              "icon_emoji"=> ":spy:"
             }

      slack_post(data)
    end

    redirect_to :back
  end

  def slack_message(user,role)
    data = {
            "channel"=>    "@#{user[:slack_name]}",
            "username"=>   "Merlin",
            "text"=>       "#{role}",
            "icon_emoji"=> ":spy:"
           }

    slack_post(data)
  end

  #TODO: Use ruby-slack-gem instead of curl to clean payload
  def slack_post(data)

    # Convert hash to string
    data = "payload={"+data.collect { |k, v| "\"#{k}\": \"#{v}\"," }.join + "}"

    # Delete extra comma..
    data[data.length-2] = ""

    slack_token = ENV["slack_incoming_hook_token"]
    slackURL    = 'https://hooks.slack.com/services/' + slack_token

    Curl.post(slackURL, data)
  end

  def text_message(user, role)
    @client = Twilio::REST::Client.new(ENV['twilio_account_sid'], ENV['twilio_auth_token'])
    @client.account.messages.create(
      :body => role,
      :to   => user[:phone_number],
      :from => ENV['twilio_num']
    )
  end

  def new
    group_params = Rack::Utils.parse_nested_query params[:group]
    @group = Group.new(group_params)
    @group.save!
    redirect_to @group
  end

end
