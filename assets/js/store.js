import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';
import {Socket} from "phoenix"

import _ from 'lodash';

/*
  State
  {
  reviews
  users
  session
  error
  }
*/

function reviews(state = [], action) {
  switch (action.type) {
  case 'REVIEW_LIST':
    return action.data;
  default:
    return state;
  }
}

function users(state = [], action) {
  switch (action.type) {
  case 'USER_LIST':
    return action.data;
  default:
    return state;
  }
}

function session(state = null, action) {
  switch (action.type) {
  case 'FOUND_SESSION':
    return action.data;
  default:
    return state;
  }
}

function error(state = null, action) {
  switch(action.type) {
  case 'SHOW_ERROR':
    return action.data;
  case 'CLEAR_ERROR':
    return null;
  default:
    return state;
  }
}

// copied from course notes

function root_reducer(state0, action) {
  console.log("reducer", state0, action);

  let reducer = combineReducers({reviews, users, session, error});
  let state1 = reducer(state0, action);

  console.log("reducer1", state1);

  return deepFreeze(state1);
}

let store = createStore(root_reducer);
export default store;
