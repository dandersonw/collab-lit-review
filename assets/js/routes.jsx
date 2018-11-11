import React from 'react';
import ReactDOM from 'react-dom';
import { connect } from 'react-redux';
import { BrowserRouter as Router, Route, Link } from "react-router-dom";
import { Switch } from 'react-router-dom';
import { Provider } from 'react-redux';
import _ from 'lodash';
import $ from 'jquery';

import Header from './header';
import ReviewList from './reviewlist';
import ShowError from './showerror';
import api from './api';


function Routes(props) {
    let {error} = props;
    return <Router>                     
             <div>
               <Header />
               <div className="row">
                 <div className="col-12">
                   <Switch>
                     {error
                      && <Route path="/"
                                component={ShowError}/>}
                     <Route path="/"
                            exact={true}
                            component={ReviewList}/>
                     {/* <Route path="/register" */}
                     {/*        exact={true} */}
                     {/*        component={Register}/> */}
                     {/* <Route path="/new" */}
                     {/*        exact={true} */}
                     {/*        component={NewTask}/> */}
                     {/* <Route path="/progress/:id" */}
                     {/*        exact={true} */}
                     {/*        render={({match}) => */}
                     {/*                <Complete taskId={match.params.id} mode={"progress"}></Complete> */}
                     {/*               }/> */}
                   </Switch>
                 </div>
               </div>
             </div>
           </Router>;
}

function state2props(state) {
    return {session: state.session, error: state.error};
}

export default connect(state2props)(Routes);
