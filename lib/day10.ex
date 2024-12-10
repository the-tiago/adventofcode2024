defmodule Day10 do
  @directions [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

  def part1(input) do
    {matrix, cols, rows} =
      parse_input(input)

    matrix
    |> find_zeros(cols, rows, 0)
  end

  def part2(input) do
    {matrix, cols, rows} =
      parse_input(input)

    matrix
    |> find_zeros2(cols, rows, 0)
  end

  # part 1 ----------------------------------------
  defp find_zeros(matrix, cols, rows, acc) do
    0..(cols - 1)
    |> Enum.reduce(acc, fn x, acc ->
      0..(rows - 1)
      |> Enum.reduce(acc, fn y, acc ->
        case Map.get(matrix, {x, y}) do
          {0, _} ->
            trailheads =
              find_trail_heads(matrix, x, y, 0, cols, rows, MapSet.new())
              |> Enum.count()

            acc + trailheads

          _ ->
            acc
        end
      end)
    end)
  end

  defp find_trail_heads(_, x, y, 9, _, _, acc), do: MapSet.put(acc, {x, y})

  defp find_trail_heads(matrix, x, y, height, cols, rows, acc) do
    @directions
    |> Enum.reduce(acc, fn {dx, dy}, acc ->
      case Map.get(matrix, {x + dx, y + dy}, :out_of_bounds) do
        {new_height, :not_visited} when height + 1 == new_height ->
          # IO.inspect({x + dx, y + dy})

          matrix
          |> Map.put({x, y}, {height, :visited})
          |> find_trail_heads(x + dx, y + dy, new_height, cols, rows, acc)

        _ ->
          acc
      end
    end)
  end

  # part 2 ----------------------------------------
  defp find_zeros2(matrix, cols, rows, acc) do
    0..(cols - 1)
    |> Enum.reduce(acc, fn x, acc ->
      0..(rows - 1)
      |> Enum.reduce(acc, fn y, acc ->
        case Map.get(matrix, {x, y}) do
          {0, _} ->
            find_trail_heads2(matrix, x, y, 0, cols, rows, acc)

          _ ->
            acc
        end
      end)
    end)
  end

  defp find_trail_heads2(_, _, _, 9, _, _, acc), do: acc + 1

  defp find_trail_heads2(matrix, x, y, height, cols, rows, acc) do
    @directions
    |> Enum.reduce(acc, fn {dx, dy}, acc ->
      case Map.get(matrix, {x + dx, y + dy}, :out_of_bounds) do
        {new_height, :not_visited} when height + 1 == new_height ->
          matrix
          |> Map.put({x, y}, {height, :visited})
          |> find_trail_heads2(x + dx, y + dy, new_height, cols, rows, acc)

        _ ->
          acc
      end
    end)
  end

  def parse_input(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    matrix =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, matrix ->
        String.graphemes(line)
        |> Enum.with_index()
        |> Enum.reduce(matrix, fn {char, x}, matrix ->
          Map.put(matrix, {x, y}, {String.to_integer(char), :not_visited})
        end)
      end)

    {matrix, String.length(List.first(lines)), length(lines)}
  end
end
