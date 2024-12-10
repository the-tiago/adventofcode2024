defmodule Day9Test do
  use ExUnit.Case

  test "part 1" do
    input = "2333133121414131402"
    # input = "12345"
    # "11....5555522"
    # "112255555"
    # input = "1014502"

    assert Day9.part1(input) == 1928
  end

  # test "part 2" do
  #  # input = "2333133121414131402"
  #  input = "12345"
  #  assert Day9.part2(input) == 2858
  # end
end
