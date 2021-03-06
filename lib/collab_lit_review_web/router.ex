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
    get "/register", PageController, :index
    get "/users/:id", PageController, :index
    # Our channel
    get "/reviews/edit/:id", PageController, :index
  end

  # Should this go in our api? It's not strictly JS
  scope "/auth", CollabLitReviewWeb do
    pipe_through :browser

    get "/:provider", SessionController, :request
    get "/:provider/callback", SessionController, :create
  end

  scope "/api/v1", CollabLitReviewWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/authors", AuthorController, only: [:show, :create]
    resources "/papers", PaperController, except: [:new, :edit]
    resources "/reviews", ReviewController, except: [:new, :edit]
    resources "/swimlanes", SwimlaneController, except: [:new, :edit]
    resources "/discoveries", DiscoveryController, except: [:new, :edit]
    resources "/buckets", BucketController, except: [:new, :edit]
    delete "/sessions", SessionController, :delete
    post "/sessions", SessionController, :create
  end
end
