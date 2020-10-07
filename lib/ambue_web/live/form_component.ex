defmodule AmbueWeb.FormComponent do
  use AmbueWeb, :live_component

  alias Ambue.Accounts
  alias Ambue.Accounts.User

  @impl true
  def mount(socket) do
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
        send(self(), "finished")

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

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    {:noreply,
     assign(socket,
       changeset:
         %User{}
         |> Accounts.change_user(params)
         |> Map.put(:action, :insert)
     )}
  end
end