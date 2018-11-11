defmodule CollabLitReviewWeb.Router do
  use CollabLitReviewWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CollabLitReviewWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug CollabLitReviewWeb.Plugs.FetchSession
  end

  scope "/", CollabLitReviewWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", CollabLitReviewWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end
end
