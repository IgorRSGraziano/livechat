defmodule LivechatWeb.Router do
  use LivechatWeb, :router

  import LivechatWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LivechatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  # Other scopes may use custom stacks.
  # scope "/api", LivechatWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:livechat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LivechatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", LivechatWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/auth/register", UserRegistrationController, :new
    post "/auth/register", UserRegistrationController, :create
  end

  scope "/", LivechatWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :home
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm-email/:token", UserSettingsController, :confirm_email
  end

  scope "/", LivechatWeb do
    pipe_through [:browser]

    get "/login", UserSessionController, :new
    get "/login/:token", UserSessionController, :confirm
    post "/login", UserSessionController, :create
    delete "/logout", UserSessionController, :delete
  end
end
