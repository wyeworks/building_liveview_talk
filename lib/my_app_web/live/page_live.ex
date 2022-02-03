defmodule MyAppWeb.PageLive do
  use MyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="phx-hero">
      <h2>Welcome to LiveView from scratch!</h2>
    </section>
    <a href={Routes.live_path(MyAppWeb.Endpoint, MyAppWeb.ThermostatLive)}>Go to thermostat</a>
    """
  end
end
