defmodule Aoc2024 do
  def day1_part1() do
    input = read_input("day1.input")
    Day1.part1(input)
  end

  def day1_part2() do
    input = read_input("day1.input")
    Day1.part2(input)
  end

  def day2_part1() do
    input = read_input("day2.input")
    Day2.part1(input)
  end

  def day2_part2() do
    input = read_input("day2.input")
    Day2.part2(input)
  end

  defp read_input(file) do
    :code.priv_dir(:adventofcode2024)
    |> Path.join(file)
    |> File.read!()
  end
end
