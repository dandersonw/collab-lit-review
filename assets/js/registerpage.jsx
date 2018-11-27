import React from "react";
import { connect } from "react-redux";
import { Link } from 'react-router-dom';
import _ from "lodash";
import $ from "jquery";

import api from "./api"

function UserRegistration(props) {
  let onRegisterButtonClicked = () => {
    let username = $("#register-email").val();
    let pass1 = $("#register-password");
    let pass2 = $("#register-password-confirm");
    let pass1val = pass1.val();
    let pass2val = pass2.val();
    let validityMessage = "Passwords must match."
    if (pass1val == pass2val) {
      validityMessage = "";
      api.register_user(username, pass1val, pass2val);
    }
    pass1[0].setCustomValidity(validityMessage);
    pass2[0].setCustomValidity(validityMessage);
  }
  let validateLength = (e) => {
    if (e.target.value.length < 8) {
      e.target.setCustomValidity("Your password must be at least 8 characters long.");
    } else {
      e.target.setCustomValidity("");
    }
  }
  return <div className="row">
    <div className="col-12">
      <h2>User Registration</h2>
      <div className="form-group mx-3 my-3">
        <label>Email</label>
        <input className="form-control mb-1" id="register-email" required="required" type="email" />
        <label>Password (must be at least 8 characters long)</label>
        <input className="form-control mb-2" id="register-password" required="required" type="password"
          onChange={validateLength}/>
        <label>Confirm Password</label>
        <input className="form-control mb-2" id="register-password-confirm" required="required" type="password"
          onChange={validateLength}/>
        <button className="btn btn-primary mr-3" onClick={onRegisterButtonClicked}>Register</button>
      </div>
    </div>
  </div>;
}

function state2props(state) {
    return {};
}

export default connect(state2props)(UserRegistration);
