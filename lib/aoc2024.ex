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

  def day3_part1() do
    input = read_input("day3.input")
    Day3.part1(input)
  end

  def day3_part2() do
    input = read_input("day3.input")
    Day3.part2(input)
  end

  def day4_part1() do
    input = read_input("day4.input")
    Day4.part1(input)
  end

  def day4_part2() do
    input = read_input("day4.input")
    Day4.part2(input)
  end

  def day5_part1() do
    input = read_input("day5.input")
    Day5.part1(input)
  end

  def day5_part2() do
    input = read_input("day5.input")
    Day5.part2(input)
  end

  def day6_part1() do
    input = read_input("day6.input")
    Day6.part1(input)
  end

  def day6_part2() do
    input = read_input("day6.input")
    Day6.part2(input)
  end

  def day7_part1() do
    input = read_input("day7.input")
    Day7.part1(input)
  end

  def day7_part2() do
    input = read_input("day7.input")
    Day7.part2(input)
  end

  def day8_part1() do
    input = read_input("day8.input")
    Day8.part1(input)
  end

  def day8_part2() do
    input = read_input("day8.input")
    Day8.part2(input)
  end

  def day9_part1() do
    input = read_input("day9.input")
    Day9.part1(input)
  end

  defp read_input(file) do
    :code.priv_dir(:adventofcode2024)
    |> Path.join(file)
    |> File.read!()
  end
end
