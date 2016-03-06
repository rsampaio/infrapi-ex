defmodule Infrapi.Router do
  use Infrapi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureAuthenticated, handler: Infrapi.SessionController
  end

  scope "/", Infrapi do
    post   "/auth", SessionController,  :create, as: :login
  end

  scope "/api", Infrapi do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit, :index]
    resources "/projects", ProjectController do
      resources "/services", ServiceController do
        resources "/volumes", VolumeController
      end
      resources "/ports", PortController
    end
  end
end
