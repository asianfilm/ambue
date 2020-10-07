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

  @impl true
  def handle_event("signup", %{"user" => params}, socket) do
    case Accounts.create_user(params) do
      {:ok, _} ->
        {:noreply,
         assign(socket,
           changeset: Accounts.change_user(%User{})
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         assign(socket,
           changeset: changeset
         )}
    end
  end
end
