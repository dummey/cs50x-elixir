require IEx

defmodule Fifteen do
  @dim_min 3
  @dim_max 9

  def clear do
    System.cmd "clear", [], into: IO.stream(:stdio, :line)
  end

  def greet do
    clear()
    IO.puts "WELCOME TO GAME OF FIFTEEN\n"
    :timer.sleep(1000)
  end

  def init(d) do 
    :random.seed(:os.timestamp)

    _finished_board(d) 
    |> Enum.shuffle 
    |> List.insert_at(-1, "_")
  end

  def _format_board(board, d) do 
    0..d 
    |> Enum.map(fn x -> Enum.slice(board, x * d, d) end) 
    |> Enum.map(fn row -> Enum.join(_format_cell(row), ", ") end)
  end

  def _format_cell(row) do 
    Enum.map(row, fn cell -> String.rjust(cell, 3) end)
  end

  def draw(board, d) do 
    _format_board(board, d) 
    |> Enum.join("\n") 
    |> IO.puts
  end

  def move(board, move, d) do
    space_location = board |> Enum.find_index fn x -> x == "_" end
    move_location = board |> Enum.find_index fn x -> x == move end

    IO.inspect([space_location, move_location])

    move_distance = abs(move_location - space_location)
    if move_distance == 1 
    or move_distance == d
    do
      board
      |> List.replace_at(space_location, move)
      |> List.replace_at(move_location, "_")
    else 
      board
    end
  end

  def _finished_board(d) do 
    1..(d * d - 1) 
    |> Enum.to_list 
    |> List.delete(d * d) 
    |> Enum.map(fn n -> Integer.to_string(n) end)
  end

  def won(board, d) do 
    won_board = _finished_board(d) |> List.insert_at(-1, "_")
    case List.flatten(board) do
      ^won_board -> true
      _ -> false
    end
  end

  def loop(board, d) do 
    clear
    draw(board, d)

    users_move = IO.gets "Tile to Move: "
    users_move = users_move |> String.strip
    board = move(board, users_move, d)

    unless won(board, d) do 
      loop board, d
    end
  end

  def start do 
    d = case System.argv do
      [x] -> x |> String.to_integer
      _   -> IO.puts "Usage: fifteen d\n"
    end

    if d < @dim_min or d > @dim_max do 
      IO.puts "Board must be between #{@dim_min} x #{@dim_min} and #{@dim_max} x #{@dim_max}, inclusive."
    end

    greet

    init(d) |> loop(d)

    IO.puts "FTW!"
  end
end

Fifteen.start()