import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import ReactTimeAgo from 'react-time-ago';

import _ from 'lodash';

export function ReviewList(props) {
  let {session, reviews} = props;

  let relevantReviews = reviews;

  return <div>
           <div className="row">
             <table className="table table-striped">
               <tbody>
                 <tr key="header">
                 </tr>
                 { _.map(relevantReviews, (review) => <Review review={review}/>)}
               </tbody>
             </table>
             <Link to={"/new"}>New Review</Link>
           </div>
         </div>;

}

function Review(props) {
  let { review } = props;
  //console.log(review);
  return <tr key={review.id}>
         </tr>;
}

function state2props(state) {
  return {
    session: state.session,
    reviews: state.reviews,
  };
}

export default connect(state2props)(ReviewList);
