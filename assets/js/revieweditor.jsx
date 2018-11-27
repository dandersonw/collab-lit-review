import React from "react";
import { connect } from "react-redux";
import { Link } from 'react-router-dom';
import socket from './socket'
import _ from "lodash";
import $ from "jquery";

import { getReviewEditorChannel } from './socket'

import api from "./api"

class ReviewEditor extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      review_id: props.review_id,
      selected_bucket: null,
      review: null,
    };
  }

  gotView(payload) {
    this.setState(state => _.assign(state, payload));
  }

  componentDidMount() {
    let channel = socket.channel("review_editor:" + this.state.review_id.toString(), {});
    this.connectToChannel(channel);
  }

  render() {
    if (!this.state.review) return null;

    console.log("Rendering!", this.state);

    let onBucketClick = (id) => {
      console.log("Clicked ", id);
      this.setState(state => {
        if (state.selected_bucket != null) {
          return _.assign(state, {selected_bucket: null});
        }
        else {
          return _.assign(state, {selected_bucket: id});
        }
      })
    }

    let swimlanes = _.map(this.state.review.swimlanes, (swimlane) => {
      return <Swimlane swimlane={swimlane} buckets={this.state.review.buckets} onBucketClick={onBucketClick}/>;
    });

    if (this.state.selected_bucket == null) {
      return <div className="container-fluid">
        {swimlanes}
      </div>;
    }
    else {
      return <div className="container-fluid">
        <div className="row">
          <div className="col-md-8">
            {swimlanes}
          </div>
          <div className="col-md-4">
            <p>Names of papers will go here</p>
          </div>
        </div>
      </div>;
    }
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

function Swimlane(props) {
  let buckets = _.filter(props.buckets, (bucket) => (bucket.swimlane_id == props.swimlane.id));
  buckets = _.sortBy(buckets, ["position"]);
  buckets = _.map(buckets, (bucket) => <div key={bucket.id} className="col-md-2"><Bucket bucket={bucket} onBucketClick={props.onBucketClick}/></div>)
  return <div key={props.swimlane.id} className="swimlane card">
    <h3 className="card-title">{props.swimlane.name}</h3>
    <div className="row">
      {buckets}
    </div>
  </div>;
}

function Bucket(props) {
  return <button onClick={() => props.onBucketClick(props.bucket.id)} className="bucket card">
    <h4 className="card-title text-center">{props.bucket.name}</h4>
    <h3 className="text-center">{props.bucket.papers.length}</h3>
  </button>
}




function state2props(state, ownProps) {
    return {session: state.session, review_id: ownProps.reviewId};
}

export default connect(state2props)(ReviewEditor);
