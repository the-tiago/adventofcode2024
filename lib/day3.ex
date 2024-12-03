defmodule Day3 do
  def part1(input) do
    input
    |> parse_input(~r/mul\((\d+),(\d+)\)/)
    |> Enum.reduce(0, fn [_, a, b], acc -> acc + String.to_integer(a) * String.to_integer(b) end)
  end

  def part2(input) do
    {_, acc} =
      input
      |> parse_input(~r/mul\((\d+),(\d+)\)|do\(\)|don't\(\)/)
      |> Enum.reduce({:active, 0}, &process_line/2)

    acc
  end

  defp process_line(["mul(" <> _, a, b], {:active, acc}) do
    {:active, acc + String.to_integer(a) * String.to_integer(b)}
  end

  defp process_line(["do()"], {:inactive, acc}), do: {:active, acc}
  defp process_line(["don't()"], {:active, acc}), do: {:inactive, acc}
  defp process_line(_, state), do: state

  # input ----------------------------------------
  defp parse_input(input, regex) do
    Regex.scan(regex, input)
  end
end
