defmodule Utils do
  @doc """
  Parses a matrix of strings.
  Returns a map which keys are the coordinate tupples
  and values are the single character string.
  """
  def parse_string_matrix(input) do
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

  @doc """
  Parses a matrix of integers, separated by blank spaces.
  Returns a map which keys are the coordinate tupples
  and values are the single character string.
  """
  def parse_integer_matrix(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    matrix =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, matrix ->
        String.split(line, ~r/\s+/, trim: true)
        |> Enum.with_index()
        |> Enum.reduce(matrix, fn {char, x}, matrix ->
          Map.put(matrix, {x, y}, String.to_integer(char))
        end)
      end)

    {matrix, Enum.count(String.split(List.first(lines), ~r/\s+/, trim: true)), length(lines)}
  end

  @doc """
  Parses a list of integers, separated by blank spaces.
  """
  def parse_integer_list(input) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Parses a table of integers, separated by blank spaces.
  Returns a list of lists of integers.
  """
  def parse_integer_table(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_integer_list/1)
  end
end
