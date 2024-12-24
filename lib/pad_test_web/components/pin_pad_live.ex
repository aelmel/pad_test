defmodule PadTestWeb.PinPadLive do
  use PadTestWeb, :live_view

  def mount(_params, _session, socket) do
    # Initialize the PIN to an empty string
    {:ok, assign(socket, pin: "")}
  end

  def render(assigns) do
    ~H"""
    <div style="padding: 1rem; max-width: 300px; margin: auto;">
      <!-- Disabled input, showing the current PIN value -->
      <input
        type="text"
        value={@pin}
        disabled
        style="width: 100%; font-size: 1.5rem; text-align: center;"
      />
      <!-- A simple PIN pad -->
      <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-top: 1rem;">
        <!-- Digits 1-9 -->
        <%= for digit <- ~w(1 2 3 4 5 6 7 8 9) do %>
          <button
            type="button"
            style="font-size: 1.5rem; padding: 1rem;"
            phx-click="digit"
            phx-value-digit={digit}
          >
            <%= digit %>
          </button>
        <% end %>
        <!-- 0 button -->
        <button
          type="button"
          style="font-size: 1.5rem; padding: 1rem;"
          phx-click="digit"
          phx-value-digit="0"
        >
          0
        </button>
        <!-- Delete button -->
        <button type="button" style="font-size: 1.5rem; padding: 1rem;" phx-click="delete">
          Del
        </button>
        <!-- OK / Submit button -->
        <button type="button" style="font-size: 1.5rem; padding: 1rem;" phx-click="submit">
          OK
        </button>
      </div>
    </div>
    """
  end

  # When a digit button is pressed, append that digit to the pin string
  def handle_event("digit", %{"digit" => digit}, socket) do
    {:noreply, update(socket, :pin, &(&1 <> digit))}
  end

  # When the delete button is pressed, remove the last digit
  def handle_event("delete", _params, socket) do
    {:noreply, update(socket, :pin, &String.slice(&1, 0..-2))}
  end

  # When "OK" is pressed, you can do something with the PIN
  def handle_event("submit", _params, socket) do
    IO.puts("PIN Submitted: #{socket.assigns.pin}")

    # For example, reset the PIN or leave it as is
    {:noreply, assign(socket, :pin, "")}
  end
end
