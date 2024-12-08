defmodule Day8 do
  def part1(input) do
    {matrix, cols, rows} =
      input
      |> Utils.parse_string_matrix()

    build_anthenas_map(matrix)
    |> Enum.reduce(MapSet.new(), fn {_freq, locations}, acc ->
      process_frequency(locations, cols, rows, acc)
    end)
    |> Enum.count()
  end

  def part2(input) do
    {matrix, cols, rows} =
      input
      |> Utils.parse_string_matrix()

    build_anthenas_map(matrix)
    |> Enum.reduce(MapSet.new(), fn {_freq, locations}, acc ->
      process_frequency_with_harmonics(locations, cols, rows, acc)
    end)
    |> Enum.count()
  end

  # part 1 ----------------------------------------
  defp process_frequency(locations, cols, rows, acc) do
    Combination.combine(locations, 2)
    |> Enum.reduce(acc, fn [a, b], acc ->
      compute_antinodes(a, b, cols, rows, acc)
    end)
  end

  defp compute_antinodes({x1, y1}, {x2, y2}, cols, rows, acc) do
    dx = x1 - x2
    dy = y1 - y2

    acc
    |> add_antinode({x1 + dx, y1 + dy}, cols, rows)
    |> add_antinode({x2 - dx, y2 - dy}, cols, rows)
  end

  defp add_antinode(acc, {x, y}, cols, rows) when x >= 0 and x < cols and y >= 0 and y < rows do
    MapSet.put(acc, {x, y})
  end

  defp add_antinode(acc, _, _, _), do: acc

  # part 2 ----------------------------------------
  defp process_frequency_with_harmonics(locations, cols, rows, acc) do
    Combination.combine(locations, 2)
    |> Enum.reduce(acc, fn [a, b], acc ->
      compute_antinodes_with_harmonics(a, b, cols, rows, acc)
    end)
  end

  defp compute_antinodes_with_harmonics({x1, y1}, {x2, y2}, cols, rows, acc) do
    dx = x1 - x2
    dy = y1 - y2

    acc
    |> MapSet.put({x1, y1})
    |> add_antinode_with_harmonics(:up, {x1 + dx, y1 + dy}, dx, dy, cols, rows)
    |> MapSet.put({x2, y2})
    |> add_antinode_with_harmonics(:down, {x2 - dx, y2 - dy}, dx, dy, cols, rows)
  end

  defp add_antinode_with_harmonics(acc, _, {x, y}, _, _, cols, rows)
       when x < 0 or x >= cols or y < 0 or y >= rows,
       do: acc

  defp add_antinode_with_harmonics(acc, :up, {x, y}, dx, dy, cols, rows) do
    acc
    |> MapSet.put({x, y})
    |> add_antinode_with_harmonics(:up, {x + dx, y + dy}, dx, dy, cols, rows)
  end

  defp add_antinode_with_harmonics(acc, :down, {x, y}, dx, dy, cols, rows) do
    acc
    |> MapSet.put({x, y})
    |> add_antinode_with_harmonics(:down, {x - dx, y - dy}, dx, dy, cols, rows)
  end

  # input ----------------------------------------
  defp build_anthenas_map(matrix) do
    Enum.reduce(matrix, %{}, fn {pos, value}, acc ->
      case value do
        "." ->
          acc

        freq ->
          frequencies = Map.get(acc, freq, [])
          Map.put(acc, freq, frequencies ++ [pos])
      end
    end)
  end
end
