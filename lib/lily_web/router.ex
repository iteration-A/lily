defmodule LilyWeb.Router do
  use LilyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug LilyWeb.Plugs.Auth
  end

  scope "/api", LilyWeb do
    pipe_through :fetch_session
    pipe_through :api

    scope "/v1" do
      get "/settings", SettingsController, :index

      scope "/users" do
        get "/:id", UserController, :show
        post "/", UserController, :create
        patch "/", UserController, :update
        delete "/", UserController, :delete
      end

      post "/login", SessionController, :create
      delete "/logout", SessionController, :delete

      scope "/profiles" do
        pipe_through :auth
        get "/", ProfileController, :show
      end

      scope "/friends" do
        pipe_through :auth
        resources "/", FriendsController, only: ~w(index create delete)a
      end
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LilyWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
