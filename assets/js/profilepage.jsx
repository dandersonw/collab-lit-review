import React from "react";
import { connect } from "react-redux";
import { Link } from 'react-router-dom';
import _ from "lodash";
import $ from "jquery";

import api from "./api"

function UserProfile(props) {
  let user = _.find(props.users, (user) => { if (user.id == props.profileId) return user; });
  if (user) {
    let myProfile = props.session != null && user.id == props.session.user_id;

    let onCreateNewButtonClicked = () => {
      let title = $('#reviewTitleField').val();
      api.new_review(title, user.id);
    }
    let onDeleteButtonClicked = (id) => {
      api.delete_review(id);
    }
    let onAddAsCollaboratorButtonClicked = () => {
      let review_id = $('#selectReviewDropdown').val();
      console.log("Tried to add a collaborator to", review_id, "!");
      api.add_collaborator_to_review(user.id, review_id);
      // make an api call
    }

    let reviews = _.map(props.reviews, (review) => {
      if (_.find(review.collaborators, (collaborator) => { return collaborator.id == user.id })) {
        return <tr key={review.id}>
          <td>{review.title}</td>
          <td>
            <div className="btn-toolbar">
              <Link className="btn btn-danger mr-3" to={"/reviews/edit/" + review.id.toString()}>Edit</Link>
              <button className="btn btn-danger" onClick={() => {onDeleteButtonClicked(review.id)}}>Delete</button>
            </div>
          </td>
        </tr>
      }
    });

    let message = <p>You've stumbled upon another user's profile. To the right you will find
    the literature reviews you are both collaborators on.</p>
    if (myProfile) {
      message = <p>This is your profile. To the right you will find
      the literature reviews you collaborate on.</p>
    }

    let reviewAction = <div className="row">
      <div className="col-8">
        <input type="text" className="form-control" id="reviewTitleField" placeholder="Title"></input>
      </div>
      <div className="col-4">
        <button className="btn btn-primary" onClick={onCreateNewButtonClicked}>New Review</button>
      </div>
    </div>;

    if (props.session == null) {
      reviewAction = null;
    }

    if (!myProfile && props.session != null) {
      let onlyMyReviews = _.filter(props.reviews, (review) => {
        let theyHaveIt = _.find(review.collaborators, (collaborator) => { return collaborator.id == user.id });
        let iHaveIt = _.find(review.collaborators, (collaborator) => { return collaborator.id == props.session.user_id });
        return (iHaveIt && !theyHaveIt);
      });
      let options = _.map(onlyMyReviews, (review) => <option key={review.id} value={review.id}>{review.title}</option>);
      reviewAction = <div className="row">
        <div className="col-8">
          <select className="form-control" id="selectReviewDropdown">
            {options}
          </select>
        </div>
        <div className="col-4">
          <button className="btn btn-primary" onClick={onAddAsCollaboratorButtonClicked}>Add as Collaborator</button>
        </div>
      </div>;
    }

    return <div className="container-fluid">
      <div className="row">
        <div className="col-6">
          <h2>{user.email}</h2>
          <div className="card">
            {message}
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
          {reviewAction}
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
