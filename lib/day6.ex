defmodule Day6 do
  def part1(input) do
    {matrix, cols, rows} =
      input
      |> Utils.parse_string_matrix()

    {pos, dir} = find_guard(matrix)

    matrix
    |> move(cols, rows, pos, dir, MapSet.new())
    |> MapSet.size()
  end

  def part2(input) do
    {matrix, cols, rows} =
      input
      |> Utils.parse_string_matrix()

    {pos, dir} = find_guard(matrix)

    # path =
    #  matrix
    #  |> move_and_colect_path(cols, rows, pos, dir, Map.new())

    find_all_loops(matrix, cols, rows, pos, dir, Map.new(), MapSet.new())
    |> MapSet.delete(pos)
    |> Enum.count()
  end

  # part 1 ----------------------------------------
  defp move(_matrix, cols, rows, {x, y}, _dir, path)
       when x < 0 or x >= cols or y < 0 or y >= rows do
    path
  end

  defp move(matrix, cols, rows, pos, direction, path) do
    {next_pos, direction} = get_next_pos_and_direction(matrix, pos, direction)
    move(matrix, cols, rows, next_pos, direction, MapSet.put(path, pos))
  end

  defp get_next_pos_and_direction(matrix, pos, direction) do
    next_pos = get_next_pos(direction, pos)

    next_symbol =
      Map.get(matrix, next_pos)

    correct_next_pos(next_symbol, direction, next_pos)
  end

  defp get_next_pos("^", {x, y}), do: {x, y - 1}
  defp get_next_pos(">", {x, y}), do: {x + 1, y}
  defp get_next_pos("v", {x, y}), do: {x, y + 1}
  defp get_next_pos("<", {x, y}), do: {x - 1, y}

  defp correct_next_pos("#", "^", {x, y}), do: {{x + 1, y + 1}, ">"}
  defp correct_next_pos("#", ">", {x, y}), do: {{x - 1, y + 1}, "v"}
  defp correct_next_pos("#", "v", {x, y}), do: {{x - 1, y - 1}, "<"}
  defp correct_next_pos("#", "<", {x, y}), do: {{x + 1, y - 1}, "^"}
  defp correct_next_pos(_, direction, {x, y}), do: {{x, y}, direction}

  # part 2 ----------------------------------------
  # defp move_and_colect_path(_matrix, cols, rows, {x, y}, _dir, path)
  #     when x < 0 or x >= cols or y < 0 or y >= rows do
  #  path
  # end

  # defp move_and_colect_path(matrix, cols, rows, pos, direction, path) do
  #  {next_pos, new_direction} =
  #    get_next_pos_and_direction(matrix, pos, direction)

  #  tracker = Map.get(path, pos, [])

  #  path =
  #    Map.put(path, pos, [new_direction | tracker])

  #  move_and_colect_path(
  #    matrix,
  #    cols,
  #    rows,
  #    next_pos,
  #    new_direction,
  #    path
  #  )
  # end

  defp find_all_loops(_matrix, cols, rows, {x, y}, _dir, _path, loops)
       when x < 0 or x >= cols or y < 0 or y >= rows do
    loops
  end

  defp find_all_loops(matrix, cols, rows, pos, direction, path, loops) do
    {next_pos, new_direction} = get_next_pos_and_direction(matrix, pos, direction)

    # insert block in the next position and find if it is a loop
    loops =
      matrix
      |> Map.put(next_pos, "#")
      |> move_until_loop(cols, rows, pos, direction, path, loops, next_pos)

    # move next
    find_all_loops(matrix, cols, rows, next_pos, new_direction, path, loops)
  end

  defp move_until_loop(_matrix, cols, rows, {x, y}, _dir, _path, loops, _)
       when x < 0 or x >= cols or y < 0 or y >= rows do
    loops
  end

  defp move_until_loop(matrix, cols, rows, pos, direction, path, loops, block_pos) do
    {next_pos, new_direction} = get_next_pos_and_direction(matrix, pos, direction)

    tracker = Map.get(path, pos, [])

    if Enum.member?(tracker, new_direction) do
      MapSet.put(loops, block_pos)
    else
      path =
        Map.put(path, pos, [direction | tracker])

      move_until_loop(matrix, cols, rows, next_pos, new_direction, path, loops, block_pos)
    end
  end

  # defp move_and_find_blocks(_matrix, cols, rows, {x, y}, _dir, _path, blocks)
  #     when x < 0 or x >= cols or y < 0 or y >= rows do
  #  blocks
  # end

  # defp move_and_find_blocks(matrix, cols, rows, pos, direction, path, blocks) do
  #  {next_pos, new_direction} = get_next_pos_and_direction(matrix, pos, direction)

  #  # insert block in the next position
  #  {_, direction_with_block} =
  #    matrix
  #    |> Map.put(next_pos, "#")
  #    |> get_next_pos_and_direction(pos, new_direction)

  #  {path, blocks} =
  #    update_path_and_blocks(path, blocks, pos, direction, direction_with_block)

  #  move_and_find_blocks(
  #    matrix,
  #    cols,
  #    rows,
  #    next_pos,
  #    new_direction,
  #    path,
  #    blocks
  #  )
  # end

  # defp update_path_and_blocks(path, blocks, {x, y} = pos, direction, direction_with_block) do
  #  tracker = Map.get(path, pos, [])

  #  blocks =
  #    if Enum.member?(tracker, direction_with_block) do
  #      blocks + 1
  #    else
  #      blocks
  #    end

  #  # IO.inspect("#{x},#{y} #{direction}")

  #  {Map.put(path, pos, [direction | tracker]), blocks}
  # end

  defp find_guard(matrix) do
    matrix
    |> Map.keys()
    |> Enum.reduce_while(0, fn k, _ ->
      v = Map.get(matrix, k)

      case Enum.member?(["^", ">", "<", "v"], v) do
        true -> {:halt, {k, v}}
        false -> {:cont, nil}
      end
    end)
  end
end
