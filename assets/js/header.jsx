import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import api from './api';

export function Header(props) {
    return Navbar(props);
}

function Navbar(props) {
  let session_view = SessionView(props);
  let profile_link = ProfileLink(props);

  return <nav className="navbar navbar-expand-sm navbar-light bg-white mb-3">
    <Link className="navbar-brand" to={"/"}>CollaberLit</Link>
    <ul className="navbar-nav mr-auto">
      <li className="nav-item">
        <Link className="nav-link" to={"/users"} onClick={() => { api.fetch_users() }}>Users</Link>
      </li>
      <li className="nav-item">
        <Link className="nav-link" to={"/reviews"} onClick={() => { api.fetch_reviews() }}>Reviews</Link>
      </li>
      {profile_link}
    </ul>
    <ul className="navbar-nav navbar-right">
      {session_view}
    </ul>
  </nav>;
}

function SessionView(props) {
  let loggedIn = props.session != null;

  if (loggedIn) {
    return <div className="col-sm">
                Logged in as: {props.session.user_email}
                <button id="logout-button"
                  className="btn btn-secondary"
                  onClick={() => api.delete_session()}>Logout</button>
           </div>;
  }
  else {
    let onLoginButtonClicked = () => {
      let username = $("#login-email").val();
      let password = $("#login-password").val();
      api.create_session(username, password);
    }
    return <li className="dropdown">
      <a className="dropdown-toggle nav-link" href="#" data-toggle="dropdown">Login/Register</a>
      <ul className="dropdown-menu">
        <li>
          <div className="form-inline mx-3 my-3">
            <label>Email</label>
            <input className="form-control mb-1" id="login-email" type="email" />
            <label>Password</label>
            <input className="form-control mb-2" id="login-password" type="password" />
            <button className="btn btn-primary mr-3" onClick={onLoginButtonClicked}>Login</button>
            <Link to={"/register"}>Register</Link>
          </div>
        </li>
      </ul>
    </li>;
  }
}

function ProfileLink(props) {
  if (props.session != null) {
    console.log("Props session is: ", props.session)
    return <li className="nav-item">
      <Link className="nav-link" to={"/users/" + props.session.user_id.toString()}>My Profile</Link>
    </li>
  }
}

function state2props(state) {
    return {session: state.session};
}

export default connect(state2props)(Header);
