defmodule MyAppWeb.BigElixirChannel do
  use MyAppWeb, :channel

  @impl true
  def join("lv:" <> _, payload, socket) do
    lv_socket = transform_socket(socket)
    {:ok, lv_socket} = MyAppWeb.ThermostatLive.mount(nil, nil, lv_socket)

    %{mode: mode, val: val} = lv_socket.assigns

    rendered = %{
      0 => "#{mode}",
      1 => "#{mode}",
      2 => "#{val}",
      :s => [
        "<main class=\"container\">\n <div class=\"thermostat\">\n  <div class=\"bar ",
        "\">\n    <a href=\"#\" phx-click=\"toggle-mode\">",
        "</a>\n  </div>\n  <div class=\"controls\">\n    <span class=\"reading\">",
        "</span>\n    <button phx-click=\"dec\" class=\"minus\">-</button>\n    <button phx-click=\"inc\" class=\"plus\">+</button>\n  </div>\n</div>\n</main>"
      ]
    }

    updated_socket = Map.put(socket, :assigns, lv_socket.assigns)
    {:ok, %{rendered: rendered}, updated_socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(event, payload, socket) do
    lv_socket = transform_socket(socket)

    {:noreply, lv_socket} = MyAppWeb.ThermostatLive.handle_event(payload["event"], nil, lv_socket)

    %{mode: mode, val: val} = lv_socket.assigns

    diff = %{
      0 => "#{mode}",
      1 => "#{mode}",
      2 => "#{val}"
    }

    updated_socket = Map.put(socket, :assigns, lv_socket.assigns)
    {:reply, {:ok, %{diff: diff}}, updated_socket}
  end

  @spec transform_socket(%Phoenix.Socket{}) :: %Phoenix.LiveView.Socket{}
  defp transform_socket(socket) do
    %Phoenix.Socket{
      assigns: assigns,
      endpoint: endpoint,
      transport_pid: transport_pid
    } = socket

    %Phoenix.LiveView.Socket{
      assigns: Map.put(assigns, :__changed__, %{}),
      endpoint: endpoint,
      transport_pid: transport_pid
    }
  end
end
