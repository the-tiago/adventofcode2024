defmodule Day1 do
  def part1(input) do
    {left, right} = parse_input(input)

    left = Enum.sort(left)
    right = Enum.sort(right)

    process_pair(left, right, 0)
  end

  def part2(input) do
    {left, right} = parse_input(input)

    frequencies = Enum.frequencies(right)

    Enum.reduce(left, 0, fn element, acc ->
      count = Map.get(frequencies, element, 0)
      acc + element * count
    end)
  end

  # part 1 ----------------------------------------
  defp process_pair([], [], acc), do: acc

  defp process_pair([a | left], [b | right], acc) do
    process_pair(left, right, acc + abs(a - b))
  end

  # input ----------------------------------------
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> Enum.map(fn [col1, col2] -> {String.to_integer(col1), String.to_integer(col2)} end)
    |> Enum.unzip()
  end
end
