# Copied in from task tracker spa

defmodule CollabLitReviewWeb.SessionController do
  use CollabLitReviewWeb, :controller

  action_fallback CollabLitReviewWeb.FallbackController

  plug Ueberauth

  alias CollabLitReview.Users.User

  # This is called by Ueberauth when the user signs in
  # For now we won't create accounts this way
  def create(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth do
      %{provider: "google"} ->
        with %User{} = user <- CollabLitReview.Users.get_user_by_email(auth.info.email) do
          create_session(conn, user)
        end
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    with %User{} = user <- CollabLitReview.Users.get_and_auth_user(email, password) do
      create_session(conn, user)
    else
      err -> err
    conn
    |> send_resp(:unprocessable_entity, "Incorrect email/password")
    end
  end

  defp create_session(conn, user) do
    resp = %{
      data: CollabLitReview.Users.session_from_user(user)
    }
    conn
    |> put_session(:user_id, user.id)
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:created, Jason.encode!(resp))
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> send_resp(:ok, "OK")
  end
end
