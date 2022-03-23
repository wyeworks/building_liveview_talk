defmodule MyAppWeb.BigElixirChannel do
  use MyAppWeb, :channel

  @impl true
  def join("lv:" <> _, payload, socket) do
    IO.puts("JOIN")
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(event, payload, socket) do
    IO.puts("HANDLE IN")
    {:reply, {:ok, payload}, socket}
  end
end
