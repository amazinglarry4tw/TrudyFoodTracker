defmodule TrudyFoodTrackerWeb.FoodTrackerLive do
  use TrudyFoodTrackerWeb, :live_view
  alias TrudyFoodTracker.FoodLog

  @food_types ["beef", "turkey", "salmon"]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :update)
    end

    {:ok, assign(socket,
      selected_food: List.first(@food_types),
      entries: FoodLog.get_entries(),
      food_types: @food_types  # Add this line
    )}
  end

  def handle_event("select-food", %{"food" => food}, socket) do
    {:noreply, assign(socket, selected_food: food)}
  end

  def handle_event("feed", _, socket) do
    FoodLog.add_entry(socket.assigns.selected_food)
    {:noreply, assign(socket, entries: FoodLog.get_entries())}
  end

  def handle_info(:update, socket) do
    {:noreply, assign(socket, entries: FoodLog.get_entries())}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-8">
      <h1 class="text-4xl font-bold mb-8 text-purple-600">Trudy's Food Tracker</h1>

      <div class="bg-white rounded-lg shadow-lg p-6 mb-8">
        <div class="flex gap-4 mb-6">
          <%= for food <- @food_types do %>
            <button
              phx-click="select-food"
              phx-value-food={food}
              class={"px-6 py-3 rounded-full transition-all transform hover:scale-105 #{if food == @selected_food, do: 'bg-purple-600 text-white', else: 'bg-gray-100 text-gray-700'}"}>
              <%= String.capitalize(food) %>
            </button>
          <% end %>
        </div>

        <button
          phx-click="feed"
          class="w-full bg-green-500 text-white py-3 rounded-lg font-bold text-lg transition-all hover:bg-green-600 transform hover:scale-102">
          Feed Trudy!
        </button>
      </div>

      <div class="bg-white rounded-lg shadow-lg p-6">
        <h2 class="text-2xl font-semibold mb-4 text-gray-700">Feeding History</h2>
        <div class="space-y-4">
          <%= for entry <- @entries do %>
            <div class="flex items-center gap-4 p-4 bg-gray-50 rounded-lg animate-fade-in">
              <div class="w-3 h-3 rounded-full bg-purple-600"></div>
              <div>
                <span class="font-medium text-gray-700"><%= String.capitalize(entry.food_type) %></span>
                <span class="text-gray-500 text-sm">
                  <%= Calendar.strftime(entry.timestamp, "%I:%M %p") %>
                </span>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
