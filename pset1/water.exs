defmodule ParseMins do
 def parse_minutes do
    mins = IO.gets "minutes: "

    try do
      mins = String.strip(mins) |> String.to_integer

      cond do
        mins > 0 -> mins
        true     -> get_minutes
      end
    rescue
      _error -> get_minutes
    end
  end
end

defmodule SmartWater do
  def calculate(mins) do 
    mins * 1.5 * 128 / 16 |> round
  end

  def wasted_water do 
    get_minutes |> calculate
  end

end

bottles = SmartWater
IO.puts "bottles: #{SmartWater.wasted_water()}"
