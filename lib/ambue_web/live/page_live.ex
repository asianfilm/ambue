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
          saved_user

        _ ->
          %User{}
      end

    {:ok,
     assign(socket,
       changeset: Accounts.change_user(user),
       completed: false,
       user: user,
       session_id: session_id
     )}
  end

  @impl true
  def handle_event("signup", %{"user" => params}, socket) do
    user = %User{name: params["name"], email: params["email"]}
    SessionCache.set(socket.assigns.session_id, user)

    case Accounts.create_user(params) do
      {:ok, _} ->
        {:noreply,
         assign(socket,
           completed: true,
           user: user
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
    user = %User{name: params["name"], email: params["email"]}
    SessionCache.set(socket.assigns.session_id, user)

    {:noreply,
     assign(socket,
       changeset:
         %User{}
         |> Accounts.change_user(params)
         |> Map.put(:action, :insert),
       user: user
     )}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>AMBUE</h1>
    <%= if @completed do %>
      <h3>Thanks, <strong><%= @user.name %>!</strong></h3>
    <% else %>
      <h3>Sign Up!</h3>
      <div id="signup">
      <%= f = form_for @changeset, "#",
                phx_submit: "signup",
                phx_change: "validate" %>

        <div class="field">
          <%= text_input f, :name,
                value: @user.name,
                placeholder: "Name",
                autocomplete: "off",
                phx_debounce: "500" %>
          <%= error_tag f, :name %>
        </div>

        <div class="field">
          <%= email_input f, :email,
                value: @user.email,
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
