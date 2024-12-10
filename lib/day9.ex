defmodule Day9 do
  def part1(input) do
    {map, count} = parse_input(%{}, String.trim(input), 0)
    compute_checksum(map, 0, count - 1, 0, 0)
  end

  def part2(input) do
    {map, count} = parse_input(%{}, String.trim(input), 0)
    compute_checksum2(map, 0, count - 1, 0, 0)
  end

  # part1 ----------------------------------------
  defp compute_checksum(_, file_id, last_id, _, acc) when last_id < file_id, do: acc

  defp compute_checksum(map, file_id, last_id, pos, acc) do
    {blocks, spaces} = Map.get(map, file_id)

    {pos, acc} = expand(file_id, blocks, pos, acc)

    {map, last_id, pos, acc} =
      fill_spaces(map, file_id, last_id, spaces, pos, acc)

    compute_checksum(map, file_id + 1, last_id, pos, acc)
  end

  defp expand(_, 0, pos, acc), do: {pos, acc}

  defp expand(file_id, blocks, pos, acc) do
    expand(file_id, blocks - 1, pos + 1, acc + pos * file_id)
  end

  defp fill_spaces(map, _file_id, last_id, 0, pos, acc), do: {map, last_id, pos, acc}
  defp fill_spaces(map, last_id, last_id, _, pos, acc), do: {map, last_id, pos, acc}

  defp fill_spaces(map, file_id, last_id, spaces, pos, acc) do
    {blocks, _spaces} = Map.get(map, last_id)

    case spaces - blocks do
      n when n < 0 ->
        {pos, acc} = expand(last_id, spaces, pos, acc)
        map = Map.put(map, last_id, {blocks - spaces, 0})
        {map, last_id, pos, acc}

      n when n > 0 ->
        {pos, acc} = expand(last_id, blocks, pos, acc)
        map = Map.put(map, last_id, {0, 0})
        fill_spaces(map, file_id, last_id - 1, n, pos, acc)

      _ ->
        {pos, acc} = expand(last_id, spaces, pos, acc)
        map = Map.put(map, last_id, {0, 0})
        {map, last_id - 1, pos, acc}
    end
  end

  # part2 ----------------------------------------
  defp compute_checksum2(_, file_id, last_id, _, acc) when last_id < file_id, do: acc

  defp compute_checksum2(map, file_id, last_id, pos, acc) do
    {blocks, spaces} = Map.get(map, file_id)
    {pos, acc} = expand(file_id, blocks, pos, acc)
    {map, pos, acc} = move_file(map, spaces, file_id, last_id, pos, acc)
    {_blocks, spaces} = Map.get(map, file_id)
    pos = pos + spaces

    compute_checksum2(map, file_id + 1, last_id, pos, acc)
  end

  defp move_file(map, _, file_id, file_id, pos, acc), do: {map, pos, acc}

  defp move_file(map, size, file_id, new_file_id, pos, acc) do
    {blocks, spaces} = Map.get(map, new_file_id)

    case blocks - size do
      n when n < 0 and blocks > 0 ->
        {pos, acc} = expand(new_file_id, blocks, pos, acc)

        map =
          map
          |> Map.put(new_file_id, {0, spaces + blocks})
          |> Map.put(file_id, {0, -n})

        move_file(map, -n, file_id, new_file_id - 1, pos, acc)

      0 ->
        {pos, acc} = expand(new_file_id, blocks, pos, acc)

        map =
          map
          |> Map.put(new_file_id, {0, spaces + blocks})
          |> Map.put(file_id, {0, 0})

        {map, pos, acc}

      _ ->
        move_file(map, size, file_id, new_file_id - 1, pos, acc)
    end
  end

  # input ----------------------------------------
  defp parse_input(map, <<>>, count), do: {map, count}

  defp parse_input(map, <<block::binary-size(1)>>, count) do
    map =
      map
      |> Map.put(count, {String.to_integer(block), 0})

    {map, count + 1}
  end

  defp parse_input(map, <<block::binary-size(1), space::binary-size(1), rest::binary>>, count) do
    map
    |> Map.put(count, {String.to_integer(block), String.to_integer(space)})
    |> parse_input(rest, count + 1)
  end
end
