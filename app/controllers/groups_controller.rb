class GroupsController < ApplicationController
  def index
  end

  def show
    @users = User.where(:group_id => params[:id]).select(:name,:id)
    @group = params[:id]
  end

  def message

    #Twilio stuff
    account_sid = 'AC5abea81a9e817d817711301623edbe85'
    auth_token  = 'abeb85cc7eac3a87136c4fed640ed949'
    twilio_num  = "+13474348476"
    @client = Twilio::REST::Client.new account_sid, auth_token

    spies      = params[:spies].to_i
    resistance = params[:resistance].to_i
    roles      = []

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

      params[:users].each do |userId|

        # Retrieve their phone number and text the user their role
        user = User.find(userId)
        if (params[:debug] == "true")
          puts "Texting #{user[:name]} at num:#{user[:phone_number]} their role as #{roles.first}"
        else
          @client.account.messages.create(:body => roles.first,
            :to => user[:phone_number],
            :from => twilio_num )
        end

        # Delete the role from the array
        roles.shift
      end
    end

    redirect_to :back
  end
end
