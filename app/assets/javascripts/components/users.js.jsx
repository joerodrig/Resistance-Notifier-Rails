
class Group extends React.Component {
  constructor(props){
    super(props);
    this.state               = {};
    this.state.selectedUsers = [];
    this.state.spies         = 0;
    this.state.resistance    = 0;
    this.state.notifySpies   = false;
  }

  // When a user is selected, add them to
  // selected users, else remove them
  updateSelectedUsers(users) {
    this.setState({selectedUsers: users});
    this.calculateRoles(users);
  }

  setMessagingOption(e){
    this.setState({messageType: e.target.value});
  }

  notifySpies(e){
    this.setState({notifySpies: e.target.checked })
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
      notifySpies:   this.state.notifySpies,
      message_type:  this.state.messageType,
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
        <DetailCard count={this.state.selectedUsers.length}
                    spies={this.state.spies}
                    resistance={this.state.resistance}
        />

        <PlayerList users={this.props.users}
                    selected={this.state.selectedUsers}
                    update={e => this.updateSelectedUsers(e)}
        />

      <div>
        <h4> Extra Settings: </h4>
          <label>
            <input type="checkbox"
                   onChange={(e) => this.notifySpies(e)}/> Notify Spies
          </label>
      </div>

        <MessageType messageType={e => this.setMessagingOption(e)} />

        <button type="submit"
                disabled={this.state.selectedUsers.length < 5}
                onClick={e => this.submitPlayers(e)}> Start Game</button>
      </div>
    )
  }
}

Group.propTypes = {
  users: React.PropTypes.array.isRequired
}


class DetailCard extends React.Component {
  constructor(props){
    super(props);
  }

  render() {
    return (
      <div>
        <h1> <u>{this.props.count}</u> players</h1>
        <h1> <span><u>{this.props.spies}</u> Spies </span>
             &nbsp;
             <span><u>{this.props.resistance}</u> Resistance </span></h1>
      </div>
    )
  }
}

DetailCard.propTypes = {
  count:      React.PropTypes.number.isRequired,
  spies:      React.PropTypes.number.isRequired,
  resistance: React.PropTypes.number.isRequired
}

class PlayerList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }
  // When a user is selected, add them to
  // selected users, else remove them
  selectUser(id) {
    let users   = this.props.selected;
    let userIdx = users.indexOf(id);
    (userIdx !== -1)? users.splice(userIdx, 1) : users.push(id);

    this.props.update(users);
  }

  // Display selectable users within the group
  users(){
    return this.props.users.map((user, idx) => {
      return ( <PlayerListItem user={user} selectUser={id => this.selectUser(id)} />)
    },this);
  }

  render() {
    return(
      <div>
        <h4>Players:</h4>
        <ul>{this.users()}</ul>
      </div>
    )
  }
}

PlayerList.propTypes = {
  selected: React.PropTypes.array.isRequired,
  update:   React.PropTypes.func.isRequired
}


class PlayerListItem extends React.Component {
  constructor(props){
    super(props);
  }

  clicked(e){
    this.props.selectUser(e.target.value);
  }

  render() {
    return (
      <label>
        <input type="checkbox"
               value={this.props.user.id}
               onChange={(id) => this.clicked(id)} /> {this.props.user.name}
      </label>
    )
  }
}

PlayerListItem.propTypes = {
  user:       React.PropTypes.object.isRequired,
  selectUser: React.PropTypes.func.isRequired
}

class MessageType extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <form onChange={e => this.props.messageType(e)}>
       <h4> Notification Type: </h4>
       <label>
         <input type="radio" name="notification-option" value="slack_message" /> Slack
       </label>
       <label>
         <input type="radio" name="notification-option" value="text_message" /> Texting
       </label>
     </form>
    )
  }
}

MessageType.propTypes = {
  messageType: React.PropTypes.func.isRequired
}
