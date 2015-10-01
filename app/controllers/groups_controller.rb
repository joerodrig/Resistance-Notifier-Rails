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

    if (spies != 0 && resistance != 0)

      # Add all roles to an array
      for spy in 0..(spies-1)
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

        # Retrieve their phone number and text the user their role
        user = User.find(userId)
        if (params[:debug] == "true")
          puts "Texting #{user[:name]} at num:#{user[:phone_number]} their role as #{roles.first}"
          players.push(user[:name])
        else
          @client = Twilio::REST::Client.new(ENV['twilio_account_sid'], ENV['twilio_auth_token'])
          @client.account.messages.create(:body => roles.first,
            :to => user[:phone_number],
            :from => ENV['twilio_num'] )
        end

        # Delete the role from the array
        roles.shift
      end
    end

    data = {"channel":    "#the-resistance",
            "username":   "Merlin",
            "text":       "Starting game with players: #{players.join(',')}",
            "icon_emoji": ":spy:"
           }

    # Convert hash to string
    data = "payload={"+data.collect { |k, v| "\"#{k}\": \"#{v}\"," }.join + "}"

    # Delete extra comma..
    data[data.length-2] = ""

    slack_token = ENV["slack_incoming_hook_token"]
    slackURL = 'https://hooks.slack.com/services/' + slack_token

    Curl.post(slackURL, data)

    redirect_to :back
  end

  def new
    group_params = Rack::Utils.parse_nested_query params[:group]
    @group = Group.new(group_params)
    @group.save!
    redirect_to @group
  end

end
