defmodule ReleaseAdminWeb.Router do
  use ReleaseAdminWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(ReleaseAdminWeb.Plugs.UserSession)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser_auth do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(ReleaseAdminWeb.Plugs.Authenticate)
    plug(ReleaseAdminWeb.Plugs.UserSession)
  end

  scope "/", ReleaseAdminWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/", ReleaseAdminWeb do
    pipe_through(:browser_auth)

    resources("/repos", RepositoriesController) do
      resources("/tasks", TaskController)
      resources("/poller", PollerController, only: [:create, :delete], singleton: true)
    end
  end

  scope "/auth", ReleaseAdminWeb do
    pipe_through(:browser)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ReleaseAdminWeb do
  #   pipe_through :api
  # end
end
