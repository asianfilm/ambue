defmodule AmbueWeb.Router do
  use AmbueWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AmbueWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_session_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AmbueWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  defp assign_session_id(conn, _) do
    if get_session(conn, :session_id) do
      conn
    else
      conn |> put_session(:session_id, Ecto.UUID.generate())
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AmbueWeb.Telemetry
    end
  end
end
