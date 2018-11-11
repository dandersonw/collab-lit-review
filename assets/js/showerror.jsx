import React from 'react';
import ReactDOM from 'react-dom';
import api from './api';
import { connect } from 'react-redux';


function ShowError(props) {
    let {error} = props;

    return <div>
             <p>{error}</p>
             <button onClick={() => api.clear_error()}
                     className="btn btn-primary">
               OK
             </button>
           </div>;
}

function state2props(state) {
    return {error: state.error};
}

export default connect(state2props)(ShowError);
