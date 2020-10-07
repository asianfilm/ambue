defmodule AmbueWeb.PageLive do
  use AmbueWeb, :live_view

  alias Ambue.Accounts
  alias Ambue.Accounts.User
  alias Services.SessionCache

  @impl true
  def mount(_params, %{"session_id" => session_id}, socket) do
    user =
      case SessionCache.get(session_id) do
        {:ok, saved_user} ->
          %User{name: saved_user["name"], email: saved_user["email"]}

        _ ->
          %User{name: "", email: ""}
      end

    {:ok,
     assign(socket,
       changeset: Accounts.change_user(user),
       completed: false,
       email: user.email,
       name: user.name,
       session_id: session_id
     )}
  end

  @impl true
  def handle_event("signup", %{"user" => params}, socket) do
    SessionCache.set(socket.assigns.session_id, params)

    case Accounts.create_user(params) do
      {:ok, _} ->
        {:noreply,
         assign(socket,
           changeset: Accounts.change_user(%User{}),
           completed: true,
           name: params["name"]
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
    SessionCache.set(socket.assigns.session_id, params)

    {:noreply,
     assign(socket,
       changeset:
         %User{}
         |> Accounts.change_user(params)
         |> Map.put(:action, :insert),
       email: params["email"],
       name: params["name"]
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>AMBUE</h1>
    <%= if @completed do %>
      <h3>Thanks, <strong><%= @name %>!</strong></h3>
    <% else %>
      <h3>Sign Up!</h3>
      <div id="signup">
      <%= f = form_for @changeset, "#",
                phx_submit: "signup",
                phx_change: "validate" %>

        <div class="field">
          <%= text_input f, :name,
                value: @name,
                placeholder: "Name",
                autocomplete: "off",
                phx_debounce: "500" %>
          <%= error_tag f, :name %>
        </div>

        <div class="field">
          <%= email_input f, :email,
                value: @email,
                placeholder: "Email",
                autocomplete: "off",
                phx_debounce: "500" %>
          <%= error_tag f, :email %>
        </div>

          <%= submit "Sign Up" %>
        </form>
      </div>
    <% end %>
    """
  end
end
