defmodule MyAppWeb.BigElixirChannel do
  use MyAppWeb, :channel

  @impl true
  def join("lv:" <> _, payload, socket) do
    rendered = %{
      0 => "cooling",
      1 => "cooling",
      2 => "60",
      :s => [
        "<main class=\"container\">\n <div class=\"thermostat\">\n  <div class=\"bar ",
        "\">\n    <a href=\"#\" phx-click=\"toggle-mode\">",
        "</a>\n  </div>\n  <div class=\"controls\">\n    <span class=\"reading\">",
        "</span>\n    <button phx-click=\"dec\" class=\"minus\">-</button>\n    <button phx-click=\"inc\" class=\"plus\">+</button>\n  </div>\n</div>\n</main>"
      ]
    }

    {:ok, %{rendered: rendered}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(event, payload, socket) do
    diff = %{
      0 => "heating",
      1 => "heating",
      2 => "72"
    }

    {:reply, {:ok, %{diff: diff}}, socket}
  end
end
