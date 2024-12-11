defmodule Day11 do
  def part1(input) do
    input
    |> Utils.parse_integer_list()
    |> deduplicate(25)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> Utils.parse_integer_list()
    |> compute_linear(75)
  end

  # part1 -----------------------------------------------
  defp deduplicate(lst, 0), do: lst

  defp deduplicate(lst, count) do
    lst
    |> Enum.map(&map_element/1)
    |> List.flatten()
    |> deduplicate(count - 1)
  end

  defp map_element(0), do: 1

  defp map_element(x) do
    str = "#{x}"

    case str
         |> byte_size()
         |> rem(2) do
      0 ->
        {left, right} = String.split_at(str, div(byte_size(str), 2))
        [String.to_integer(left), String.to_integer(right)]

      1 ->
        x * 2024
    end
  end

  # part 2 ------------------------------------------
  defp compute_linear(input, count) do
    # map with number of stones per number
    agg =
      input
      |> Enum.reduce(%{}, fn elem, acc ->
        Map.update(acc, elem, 1, &(&1 + 1))
      end)

    # now process each round
    agg =
      1..count
      |> Enum.reduce(agg, fn _, agg ->
        process_round(agg)
      end)

    # count all the stones
    agg
    |> Enum.reduce(0, fn {_, count}, acc -> acc + count end)
  end

  defp process_round(agg) do
    agg
    |> Enum.reduce(%{}, fn
      {0, count}, acc ->
        acc
        |> Map.update(1, count, &(&1 + count))

      {x, count}, acc ->
        str = "#{x}"

        case str
             |> byte_size()
             |> rem(2) do
          0 ->
            {left, right} = String.split_at(str, div(byte_size(str), 2))

            acc
            |> Map.update(String.to_integer(left), count, &(&1 + count))
            |> Map.update(String.to_integer(right), count, &(&1 + count))

          1 ->
            acc
            |> Map.update(x * 2024, count, &(&1 + count))
        end
    end)
  end
end
