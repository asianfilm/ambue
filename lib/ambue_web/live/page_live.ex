defmodule AmbueWeb.PageLive do
  use AmbueWeb, :live_view

  alias AmbueWeb.FormComponent

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def render(assigns),
    do: ~L"""
    <h1>Sign Up!</h1>
    <%= live_component @socket, FormComponent, id: 1 %>
    """
end
