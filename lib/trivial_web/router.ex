defmodule TrivialWeb.Router do
  use TrivialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrivialWeb do
    pipe_through :browser

    get "/", DashboardController, :index

    resources "/users", UserController, only: [:new, :create]
    resources "/session", SessionController, only: [:new, :create], singleton: true
    resources "/games", GameController
  end
end
