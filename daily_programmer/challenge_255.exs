
defmodule Parser do 
  def parse_input(input) do
    [number_of_switches | actions] = input |> String.split("\n")

    number_of_switches = parse_number_of_switches(number_of_switches)
    actions = parse_actions(actions)

    [number_of_switches, actions]
  end

  def parse_number_of_switches(number_of_switches) do
    number_of_switches |> String.to_integer
  end

  def parse_actions(actions) do
    case actions do 
      [] -> []
      [action | actions] -> 
        action = String.split(action) |> Enum.map(fn x -> String.to_integer(x) end) 
        [action] ++ parse_actions(actions)
    end
  end
end

defmodule LightSwitches do 
  def init(number_of_switches) do 
    List.duplicate(false, number_of_switches)
  end

  def flip_switch(switches, switch_number) do 
    case Enum.at(switches, switch_number) do 
      false -> List.replace_at(switches, switch_number, true)
      true -> List.replace_at(switches, switch_number, false)
      _ -> switches
    end
  end

  def flip_switch_range(switches, starting, ending) do 
    cond do 
      starting == ending -> 
        switches 
        |> flip_switch(starting) 
      starting > ending -> 
        flip_switch_range(switches, ending, starting)
      true -> 
        switches 
        |> flip_switch(starting) 
        |> flip_switch_range(starting + 1, ending)
    end
  end

  def count_switches(switches) do
    switches |> List.foldl(0, fn (x, acc) -> if x, do: acc + 1, else: acc end)
  end
end

defmodule CrazyKid do
  def act(light_switches, actions) do 
    case actions do 
      [[s, e] | actions] -> light_switches |> LightSwitches.flip_switch_range(s, e) |> act(actions)
      [] -> light_switches
    end
  end
end

simple = 
"10
3 6
0 4
7 3
9 9"

hard = 
"1000
616 293
344 942
27 524
716 291
860 284
74 928
970 594
832 772
343 301
194 882
948 912
533 654
242 792
408 34
162 249
852 693
526 365
869 303
7 992
200 487
961 885
678 828
441 152
394 453"

[number_of_switches | [actions]] = Parser.parse_input(simple)
light_switches = LightSwitches.init(number_of_switches) 
CrazyKid.act(light_switches, actions) |> LightSwitches.count_switches |> IO.puts

[number_of_switches | [actions]] = Parser.parse_input(hard)
light_switches = LightSwitches.init(number_of_switches) 
CrazyKid.act(light_switches, actions) |> LightSwitches.count_switches |> IO.puts
