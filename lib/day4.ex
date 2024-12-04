defmodule Day4 do
  def part1(input) do
    {matrix, x, y} = parse_input(input)

    Enum.reduce(0..(y - 1), 0, fn y, acc ->
      Enum.reduce(0..(x - 1), acc, fn x, acc ->
        process_item(matrix, Map.get(matrix, {x, y}, "_"), x, y, acc)
      end)
    end)
  end

  def part2(input) do
    {matrix, x, y} = parse_input(input)

    Enum.reduce(0..(y - 1), 0, fn y, acc ->
      Enum.reduce(0..(x - 1), acc, fn x, acc ->
        process2_item(matrix, Map.get(matrix, {x, y}, "_"), x, y, acc)
      end)
    end)
  end

  # part 1 ----------------------------------------
  defp process_item(matrix, "X", x, y, acc) do
    acc +
      word_match(get_word(matrix, {x + 1, y}, {x + 2, y}, {x + 3, y})) +
      word_match(get_word(matrix, {x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3})) +
      word_match(get_word(matrix, {x, y + 1}, {x, y + 2}, {x, y + 3})) +
      word_match(get_word(matrix, {x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3})) +
      word_match(get_word(matrix, {x - 1, y}, {x - 2, y}, {x - 3, y})) +
      word_match(get_word(matrix, {x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3})) +
      word_match(get_word(matrix, {x, y - 1}, {x, y - 2}, {x, y - 3})) +
      word_match(get_word(matrix, {x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}))
  end

  defp process_item(_, _, _, _, acc), do: acc

  defp word_match("MAS"), do: 1
  defp word_match(_), do: 0

  defp get_word(matrix, m, a, s) do
    Map.get(matrix, m, "_") <> Map.get(matrix, a, "_") <> Map.get(matrix, s, "_")
  end

  # part2 ----------------------------------------
  defp process2_item(matrix, "A", x, y, acc) do
    acc +
      x_match(
        Map.get(matrix, {x - 1, y - 1}, "_"),
        Map.get(matrix, {x + 1, y - 1}, "_"),
        Map.get(matrix, {x - 1, y + 1}, "_"),
        Map.get(matrix, {x + 1, y + 1}, "_")
      )
  end

  defp process2_item(_, _, _, _, acc), do: acc

  defp x_match("M", "S", "M", "S"), do: 1
  defp x_match("M", "M", "S", "S"), do: 1
  defp x_match("S", "M", "S", "M"), do: 1
  defp x_match("S", "S", "M", "M"), do: 1
  defp x_match(_, _, _, _), do: 0

  # input ----------------------------------------
  defp parse_input(input) do
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
          Map.put(matrix, {x, y}, char)
        end)
      end)

    {matrix, String.length(List.first(lines)), length(lines)}
  end
end
