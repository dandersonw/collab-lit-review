# Copied in from task tracker spa

defmodule CollabLitReviewWeb.SessionController do
  use CollabLitReviewWeb, :controller

  action_fallback CollabLitReviewWeb.FallbackController

  alias CollabLitReview.Users.User

  def create(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- CollabLitReview.Users.get_and_auth_user(email, password) do
      resp = %{
        data: CollabLitReview.Users.session_from_user(user)
      }

      conn
      |> put_session(:user_id, user.id)
      |> put_resp_header("content-type", "application/json; charset=UTF-8")
      |> send_resp(:created, Jason.encode!(resp))
    else
      err -> err
    conn
    |> send_resp(:unprocessable_entity, "Incorrect email/password")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> send_resp(:ok, "OK")
  end
end
