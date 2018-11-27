import React from "react";
import { connect } from "react-redux";
import { Link } from 'react-router-dom';
import socket from './socket'
import _ from "lodash";
import $ from "jquery";

import { getReviewEditorChannel } from './socket'

import api from "./api"
/*
function ReviewEditor(props) {
  console.log("Rendering review editor for", reviewId);
  let channel = socket.channel("review_editor:" + review_id.toString(), {});

  return <p>This will be an editor.</p>;
}*/

class ReviewEditor extends React.Component {
  constructor(props) {
    super(props);

    console.log("ReviewEditor constructed with the following props, ", props)
    this.state = {
      review_id: props.review_id,
      view: null,
    };
  }

  gotView(payload) {
    this.setState(state => _.assigns(state, {view: payload}));
  }

  componentDidMount() {
    console.log("Review editor component mounted with review_id", this.state.review_id);
    let channel = socket.channel("review_editor:" + this.state.review_id.toString(), {});
    this.connectToChannel(channel);
  }

  render() {
    return <p>This will be an editor.</p>
  }

  connectToChannel(channel) {
    if (this.channel != null) {
      this.channel.leave();
    }
    channel.join().receive("ok", resp => { console.log("Join successful,", resp); this.gotView(resp); });
    //this.setState(state => _.assign(state, { channel }) );
    channel.on("update", payload => {
      this.gotView(payload);
    })
    this.channel = channel;
  }

  disconnectFromChannel() {
    if (this.channel != null) {
      this.channel.leave();
      this.channel = null;
    }
  }
}





function state2props(state, ownProps) {
    return {session: state.session, review_id: ownProps.reviewId};
}

export default connect(state2props)(ReviewEditor);
