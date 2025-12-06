defmodule RideFastWeb.Router do
  use RideFastWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug RideFast.Guardian.AuthPipeline
  end

  scope "/api/v1", RideFastWeb do
    pipe_through :api

    post "/auth/register", AuthController, :register
    post "/auth/login", AuthController, :login
  end

  scope "/api/v1", RideFastWeb do
    pipe_through [:api, :auth]

    resources "/users", UserController, except: [:new, :edit, :create]
    get "/me", UserController, :me

    resources "/drivers", DriverController, except: [:new, :edit, :create] do
      resources "/vehicles", VehicleController, only: [:index, :create]

      get "/profile", DriverProfileController, :show
      post "/profile", DriverProfileController, :create
      put "/profile", DriverProfileController, :update
    end

    resources "/vehicles", VehicleController, only: [:update, :delete]
  end

  if Application.compile_env(:ride_fast, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: RideFastWeb.Telemetry
    end
  end
end
