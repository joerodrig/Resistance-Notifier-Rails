
class Group extends React.Component {
  constructor(props){
    super(props);
    this.state               = {}
    this.state.selectedUsers = []
    this.state.spies         = 0
    this.state.resistance    = 0
  }

  // When a user is selected, add them to
  // selected users, else remove them
  updateSelectedUsers(user) {
    let userId  = user.target.value;
    let users   = this.state.selectedUsers;
    let userIdx = users.indexOf(userId);
    (userIdx !== -1)? users.splice(userIdx, 1) : users.push(userId)

    this.setState({selectedUsers: users});
    this.calculateRoles(users);
  }

  // Display selectable users within the group
  users(){
    return this.props.users.map((user, idx) => {
      return (<li>
               <input
                 type="checkbox"
                 value={user.id}
                 onChange={(user) => this.updateSelectedUsers(user)}/> {user.name}
              </li>)
    });
  }

  setMessagingOption(e){
    this.setState({messageType: e.target.value});
  }

  // Calculating roles on the client
  calculateRoles(users) {
    switch (users.length) {
      case 5:
        this.setState({spies: 2, resistance: 3});
        return
      case 6:
        this.setState({spies: 2, resistance: 4});
        return
      case 7:
        this.setState({spies: 3, resistance: 4});
        return
      case 8:
        this.setState({spies: 3, resistance: 5});
        return
      case 9:
        this.setState({spies: 3, resistance: 6});
        return
      case 10:
        this.setState({spies: 4, resistance: 6});
        return
      default:
        this.setState({spies: 0, resistance: 0});
    }
  }

  // Submit selected players to server to send them their roles
  submitPlayers() {
    let data = {
      users:         this.state.selectedUsers,
      spies:         this.state.spies,
      resistance:    this.state.resistance,
      message_type:   this.state.messageType,
      group:         this.props.group,
    };

    $.ajax({
      data: data,
      url:  './'+data.group+'/submit',
      type: "POST",
      success: function( data ) {
        console.log("successfully submitted");
      }.bind(this)
    });
  }

  render() {
    return (
      <div>
        <h1> # of players: {this.state.selectedUsers.length}</h1>
        <h1><span>Spies: {this.state.spies}</span> <span>Resistance: {this.state.resistance}</span></h1>
        <h1>Select Players:</h1>
        <ul>{this.users()}</ul>
        <div>
           <form onChange={this.setMessagingOption.bind(this)}>
            <label>
              <input type="radio" name="notification-option" value="slack_message" />
              Slack Message
            </label>
            <label>
              <input type="radio" name="notification-option" value="text_message" />
              Text Message
            </label>
          </form>
              </div>
        <button type="submit" onClick={this.submitPlayers.bind(this)}> Start Game</button>
      </div>
    )
  }
}
