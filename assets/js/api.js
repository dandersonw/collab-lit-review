import store from './store';

// Shamelessly ripped (in part) from a member's task tracker

class TheServer {
    fetch_path(path, callback) {
        $.ajax(path, {
            method: "get",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: "",
            success: callback,
        });
    }

    send_data(path, method, data, callback) {
        $.ajax(path, {
            method: method,
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: JSON.stringify(data),
            success: callback,
            error: this.error_handler,
        });
    }

    send_post(path, data, callback) { this.send_data(path, "post", data, callback) }
    send_put(path, data, callback) { this.send_data(path, "put", data, callback) }

    error_handler(jqxhr, status, error) {
        store.dispatch({
            type: 'SHOW_ERROR',
            data: error + ": " + JSON.stringify(jqxhr),
        });
    }

    clear_error() {
        store.dispatch({
            type: 'CLEAR_ERROR'
        });
    }

    fetch_reviews() {
      this.fetch_path(
        "/api/v1/reviews",
        (resp) => {
          store.dispatch({
              type: 'REVIEW_LIST',
              data: resp.data,
            });
          }
        );
    }

    fetch_users() {
      console.log("Requesting users...");
      this.fetch_path(
        "/api/v1/users",
        (resp) => {
          console.log("Got users!");
          store.dispatch({
              type: 'USER_LIST',
              data: resp.data,
            });
          }
        );
    }

    // new_task(title, desc, assignee) {
    //     let task = {title, desc, assignee}
    //     this.send_post(
    //         "/api/v1/tasks",
    //         {task},
    //         (resp) => {
    //             store.dispatch({
    //                 type: 'SHOW_TASK',
    //                 data: resp.data,
    //             });
    //         }
    //     );
    // }

    // assign_task(task_id, assignee) {
    //     let task = {assignee};
    //     this.send_put(
    //         "/api/v1/tasks/" + task_id,
    //         {task},
    //         (resp) => {
    //             store.dispatch({
    //                 type: 'SHOW_TASK',
    //                 data: resp.data,
    //             });
    //         }
    //     );
    // }

    // update_task_progress(task_id, time_spent, completed) {
    //     let task = {time_spent, completed};
    //     this.send_put(
    //         "/api/v1/tasks/" + task_id,
    //         {task},
    //         (resp) => {
    //             store.dispatch({
    //                 type: 'SHOW_TASK',
    //                 data: resp.data,
    //             });
    //         }
    //     );
    // }

    // get_task(id) {
    //     this.fetch_path(
    //         "/api/v1/tasks/" + id,
    //         (resp) => {
    //             store.dispatch({
    //                 type: 'SHOW_TASK',
    //                 data: resp.data,
    //             });
    //         }
    //     );
    // }

    create_session(email, password) {
        this.send_post(
            "/api/v1/sessions",
            {email, password},
            (resp) => {
              location.reload();
            }
        );
    }

    delete_session() {
        $.ajax("/api/v1/sessions", {
            method: "delete",
            contentType: "application/json; charset=UTF-8",
            success: (resp) => {
              location.reload();
            }
        });
    }

    register_user(email, password, password_confirmation) {
        let user = {email, password, password_confirmation}
        this.send_post(
            "/api/v1/users",
            { user },
            (resp) => {
                /* This is bad for now. We're sending back the user object when we create a user. Probably shouldn't do that since it
                 contains the hash. */
                /*store.dispatch({
                    type: 'NEW_SESSION',
                    data: resp.data,
                });*/
            }
        );
    }

    check_for_session() {
        store.dispatch({
            type: 'FOUND_SESSION',
            data: window.session,
        });
    }
}

export default new TheServer();
