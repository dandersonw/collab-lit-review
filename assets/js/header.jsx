import React from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import api from './api';

export function Header(props) {
    let {dispatch, session} = props;

    let session_view = <div className="form-inline col-6">
                         <div className="form-group">
                           <input id="login-email" type="email" placeholder="email" />
                         </div>
                         <div className="form-group">
                           <input id="login-pass" type="password" placeholder="password" />
                         </div>
                         <button id="login-button"
                                 className="btn btn-secondary"
                                 onClick={() =>
                                          api.create_session(document.getElementById("login-email").value,
                                                             document.getElementById("login-pass").value)}>
                           Login
                         </button>
                         <div className="col-2">
                           <p><Link to={"/register"}>Register</Link></p>
                         </div>
                       </div>;

    if (session != null) {
        session_view = <div className="col-sm">
                         User: {session.user_email}
                         <button id="logout-button"
                                 className="btn btn-secondary"
                                 onClick={() => api.delete_session()}>Logout</button>
                       </div>;
    }

    return <div className="row">
             <div className="col"><h2>Collab Review</h2></div>
             <div className="col-sm">
               <Link to={"/"} onClick={() => api.fetch_reviews()} >Reviews</Link>
             </div>
             {session_view}
           </div>;
}

function state2props(state) {
    return {session: state.session};
}

export default connect(state2props)(Header);
