defmodule TrudyFoodTracker.FoodLog do
  use Agent

  defmodule Entry do
    defstruct [:food_type, :timestamp]
  end

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_entry(food_type) do
    Agent.update(__MODULE__, fn entries ->
      {:ok, est_time} = DateTime.shift_zone(DateTime.utc_now(), "America/New_York")
      [%Entry{food_type: food_type, timestamp: est_time} | entries]
    end)
  end

  def get_entries do
    Agent.get(__MODULE__, & &1)
  end
end
