import React from "react";
import { connect } from "react-redux";
import { Link } from 'react-router-dom';
import _ from "lodash";
import $ from "jquery";

import api from "./api"

function UserProfile(props) {
  let user = _.find(props.users, (user) => { if (user.id == props.profileId) return user; });
  if (user) {
    let onCreateNewButtonClicked = () => {
      let title = $('#reviewTitleField').val();
      api.new_review(title, user.id);
    }
    let onDeleteButtonClicked = (id) => {
      api.delete_review(id);
    }
    let reviews = _.map(props.reviews, (review) => {
      if (_.find(review.collaborators, (collaborator) => { return collaborator.id == user.id })) {
        return <tr key={review.id}>
          <td>{review.title}</td>
          <td>
            <div className="btn-toolbar">
              <Link className="btn btn-danger" to={"/reviews/edit/" + review.id.toString()}>Edit</Link>
              <button className="btn btn-danger" onClick={() => {onDeleteButtonClicked(review.id)}}>Delete</button>
            </div>
          </td>
        </tr>
      }
    })
    return <div className="container-fluid">
      <div className="row">
        <div className="col-6">
          <h2>{user.email}</h2>
          {/* TODO: Create display names for users */}
          <div className="card">
            <p>Maybe users should have something more interesting to display here...
            We should also introduce display names so the user doesn't have to show
            their email on their profile.</p>
          </div>
        </div>
        <div className="col-6">
          <table className="table">
            <thead>
              <tr>
                <th className="col-8">Title</th>
                <th className="col-4">Controls</th>
              </tr>
            </thead>
            <tbody>
              {reviews}
            </tbody>
          </table>
          <div className="row">
            <div className="col-8">
              <input type="text" className="form-control" id="reviewTitleField" placeholder="Title"></input>
            </div>
            <div className="col-4">
              <button className="btn btn-primary" onClick={onCreateNewButtonClicked}>New Review</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  }
  return null;
}

function state2props(state) {
    return {session: state.session, users: state.users, reviews: state.reviews};
}

export default connect(state2props)(UserProfile);
