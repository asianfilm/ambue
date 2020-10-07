defmodule AmbueWeb.PageLive do
  use AmbueWeb, :live_view

  alias Ambue.Accounts
  alias Ambue.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       changeset: Accounts.change_user(%User{})
     )}
  end
end
