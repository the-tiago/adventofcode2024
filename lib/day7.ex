defmodule Day7 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn {result, args} -> check_operation(result, args, 0) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn {result, args} -> check_operation2(result, args, 0) end)
    |> Enum.sum()
  end

  # part 1 ----------------------------------------
  defp check_operation(expected, [], expected), do: expected
  defp check_operation(_, [], _), do: 0

  defp check_operation(expected, [arg | args], acc) do
    case check_operation(expected, args, acc + arg) do
      0 -> check_operation(expected, args, acc * arg)
      expected -> expected
    end
  end

  # part 2 ----------------------------------------
  defp check_operation2(expected, [], expected), do: expected
  defp check_operation2(_, [], _), do: 0

  defp check_operation2(expected, [arg | args], acc) do
    case check_operation2(expected, args, acc + arg) do
      0 ->
        case check_operation2(expected, args, acc * arg) do
          0 ->
            check_operation2(expected, args, concatenate(acc, arg))

          expected ->
            expected
        end

      expected ->
        expected
    end
  end

  defp concatenate(arg1, arg2), do: String.to_integer("#{arg1}#{arg2}")

  # parse input ----------------------------------------
  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [result | args] =
      Regex.scan(~r/\d+/, line, trim: true)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {result, args}
  end
end
