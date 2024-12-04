defmodule UtilsTest do
  use ExUnit.Case

  test "parse_string_matrix/1" do
    input = """
    MMMS
    MSAM
    AMXS
    """

    assert {output, 4, 3} = Utils.parse_string_matrix(input)

    assert output == %{
             {0, 0} => "M",
             {1, 0} => "M",
             {2, 0} => "M",
             {3, 0} => "S",
             {0, 1} => "M",
             {1, 1} => "S",
             {2, 1} => "A",
             {3, 1} => "M",
             {0, 2} => "A",
             {1, 2} => "M",
             {2, 2} => "X",
             {3, 2} => "S"
           }
  end

  test "parse_integer_matrix/1" do
    input = """
    1 2 3 4
    5 6 7 8
    9 10 11 12
    """

    assert {output, 4, 3} = Utils.parse_integer_matrix(input)

    assert output == %{
             {0, 0} => 1,
             {1, 0} => 2,
             {2, 0} => 3,
             {3, 0} => 4,
             {0, 1} => 5,
             {1, 1} => 6,
             {2, 1} => 7,
             {3, 1} => 8,
             {0, 2} => 9,
             {1, 2} => 10,
             {2, 2} => 11,
             {3, 2} => 12
           }
  end

  test "parse_integer_list/1" do
    input = "1 2 3 4 5 6 7 8 9 10 11 12"

    assert output = Utils.parse_integer_list(input)

    assert output == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  end

  test "parse_integer_table/2" do
    input = """
    1 2 3 4
    5 6 7 8
    9 10 11 12
    """

    assert output = Utils.parse_integer_table(input)

    assert output == [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]
  end
end
