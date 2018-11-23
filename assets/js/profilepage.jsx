import React from "react";
import { connect } from "react-redux";
import { Link } from 'react-router-dom';
import _ from "lodash";
import $ from "jquery";

import api from "./api"

function UserProfile(props) {
  return <p>Id is {props.profileId}</p>
}

function state2props(state) {
    return {session: state.session, users: state.users};
}

export default connect(state2props)(UserProfile);
