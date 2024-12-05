defmodule Day5 do
  def part1(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.map(&check_line(&1, rules))
    |> Enum.sum()
  end

  def part2(input) do
    {rules, updates} = parse_input(input)

    invalid =
      updates
      |> Enum.reject(fn line -> check_line(line, rules) > 0 end)

    recursive_order(rules, invalid, [])
    |> Enum.map(&compute_middle/1)
    |> Enum.sum()
  end

  defp check_line(line, rules) do
    middle = compute_middle(line)

    Enum.with_index(line)
    |> Enum.reduce_while(0, fn {element, index}, _ ->
      if check_element(element, index, line, rules) do
        {:cont, middle}
      else
        {:halt, 0}
      end
    end)
  end

  defp compute_middle(line) do
    line
    |> Enum.at(div(Enum.count(line), 2))
    |> String.to_integer()
  end

  defp check_element(element, index, line, rules) do
    Enum.drop(line, index + 1)
    |> Enum.reduce_while(true, fn x, _ ->
      if Enum.member?(rules, "#{x}|#{element}") do
        {:halt, false}
      else
        {:cont, true}
      end
    end)
  end

  # part2 ----------------------------------------

  defp recursive_order(_rules, [], valid), do: valid

  defp recursive_order(rules, invalid, valid) do
    {new_valid, new_invalid} =
      invalid
      |> Enum.map(fn line -> order_line(line, rules, line) end)
      |> Enum.split_with(fn line -> check_line(line, rules) > 0 end)

    recursive_order(rules, new_invalid, valid ++ new_valid)
  end

  defp order_line([], _rules, ordered), do: ordered

  defp order_line([x | rest], rules, ordered) do
    {left, [x | right]} = Enum.split_while(ordered, &(&1 != x))
    ordered = order(x, rules, [], right)
    order_line(rest, rules, left ++ ordered)
  end

  defp order(x, _rules, acc, []), do: acc ++ [x]

  defp order(x, rules, acc, [y | right]) do
    if Enum.member?(rules, "#{y}|#{x}") do
      order(x, rules, acc ++ [y], right)
    else
      acc ++ [x, y | right]
    end
  end

  # input ----------------------------------------
  defp parse_input(input) do
    [rules, updates] = String.split(input, "\n\n", trim: true)

    rules = String.split(rules, "\n", trim: true)

    updates =
      updates
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))

    {rules, updates}
  end
end
