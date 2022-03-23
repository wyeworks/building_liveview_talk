defmodule MyAppWeb.BigElixirChannel do
  use MyAppWeb, :channel

  @impl true
  def join("lv:" <> _, payload, socket) do
    lv_socket = transform_socket(socket)
    {:ok, lv_socket} = MyAppWeb.ThermostatLive.mount(nil, nil, lv_socket)

    %{static: static, dynamic: dynamic} = MyAppWeb.ThermostatLive.render(lv_socket.assigns)
    values = dynamic.(false)

    rendered = %{
      0 => Enum.at(values, 0),
      1 => Enum.at(values, 1),
      2 => Enum.at(values, 2),
      :s => static
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

    %{dynamic: dynamic} = MyAppWeb.ThermostatLive.render(lv_socket.assigns)
    values = dynamic.(false)

    diff = %{
      0 => Enum.at(values, 0),
      1 => Enum.at(values, 1),
      2 => Enum.at(values, 2)
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
