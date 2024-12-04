defmodule Day2 do
  def part1(input) do
    input
    |> Utils.parse_integer_table()
    |> Enum.map(&line_safe(&1))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Utils.parse_integer_table()
    |> Enum.map(&line_safe_brute_force(&1))
    |> Enum.sum()
  end

  # part 1 ----------------------------------------
  defp line_safe([a, a | _rest]), do: 0
  defp line_safe([a, b | _rest] = list) when a < b, do: line_safe(:increasing, list)
  defp line_safe(list), do: line_safe(:decreasing, list)

  defp line_safe(_, [_]), do: 1

  defp line_safe(:increasing, [a, b | rest]) when (b - a) in [1, 2, 3],
    do: line_safe(:increasing, [b | rest])

  defp line_safe(:decreasing, [a, b | rest]) when (a - b) in [1, 2, 3],
    do: line_safe(:decreasing, [b | rest])

  defp line_safe(_, _), do: 0

  # part 2 ----------------------------------------
  defp line_safe_brute_force(list) do
    if line_safe(list) == 1 do
      1
    else
      0..(length(list) - 1)
      |> Enum.reduce_while(0, fn index, _ ->
        {left, [_ | right]} = Enum.split(list, index)

        if line_safe(left ++ right) == 1 do
          {:halt, 1}
        else
          {:cont, 0}
        end
      end)
    end
  end

  #  defp line_safe_tolerated([a, a | rest]), do: line_safe([a | rest])
  #
  #  # defp line_safe_tolerated([a, b, c | rest]) when b > a and b > c, do: line_safe([a, c | rest])
  #  # defp line_safe_tolerated([a, b, c | rest]) when b < a and b < c, do: line_safe([a, c | rest])
  #
  #  defp line_safe_tolerated([a, b | rest]) when abs(b - a) > 3, do: line_safe([b | rest])
  #
  #  defp line_safe_tolerated([a, b | _rest] = list) when a < b,
  #    do: line_safe_tolerated(:increasing, list, :one_to_go)
  #
  #  defp line_safe_tolerated(list), do: line_safe_tolerated(:decreasing, list, :one_to_go)
  #
  #  defp line_safe_tolerated(_, [_], _), do: 1
  #
  #  defp line_safe_tolerated(:increasing, [a, b | rest], tolerance) when (b - a) in [1, 2, 3],
  #    do: line_safe_tolerated(:increasing, [b | rest], tolerance)
  #
  #  defp line_safe_tolerated(:decreasing, [a, b | rest], tolerance) when (a - b) in [1, 2, 3],
  #    do: line_safe_tolerated(:decreasing, [b | rest], tolerance)
  #
  #  defp line_safe_tolerated(direction, [a, _ | rest], :one_to_go),
  #    do: line_safe_tolerated(direction, [a | rest], :used)
  #
  #  defp line_safe_tolerated(_, _, :used), do: 0
end
