defmodule AmbueWeb.PageLive do
  use AmbueWeb, :live_view

  alias AmbueWeb.FormComponent

  @impl true
  def mount(_params, %{"session_id" => session_id}, socket) do
    {:ok,
     assign(socket,
       session_id: session_id
     )}
  end

  @impl true
  def render(assigns),
    do: ~L"""
    <h1>Sign Up!</h1>
    <%= live_component @socket, FormComponent, id: @session_id %>
    """
end
