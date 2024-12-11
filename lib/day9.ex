defmodule Day9 do
  def part1(input) do
    {map, count} = parse_input(%{}, String.trim(input), 0)
    compute_checksum(map, 0, count - 1, 0, 0)
  end

  def part2(input) do
    :queue.new()
    |> parse_input_as_queue(String.trim(input), 0)
    |> order_files()
    |> compute_checksum2()
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
  defp compute_checksum2(q) do
    :queue.fold(
      fn {file_id, blocks, spaces}, {pos, acc} ->
        {pos, acc} = expand(file_id, blocks, pos, acc)
        {pos + spaces, acc}
      end,
      {0, 0},
      q
    )
    |> elem(1)
  end

  defp order_files(q) do
    list =
      q
      |> :queue.reverse()
      |> :queue.to_list()

    do_order_files(q, list)
  end

  defp do_order_files(q, []), do: q

  defp do_order_files(q, [{file_id, _, _} = file | rest]) do
    part_queue = split_queue_until(q, file_id)

    case find_fitting_file(part_queue, file) do
      :empty ->
        # not found, keep the file in the same position
        :queue.filtermap(
          fn
            {^file_id, b, s} -> {true, {file_id, b, s}}
            _ -> true
          end,
          q
        )
        |> do_order_files(rest)

      {fit_id, _, _} ->
        move_file(q, file, fit_id)
        |> do_order_files(rest)
    end
  end

  defp split_queue_until(q, file_id) do
    {:found, index} =
      :queue.fold(
        fn
          {^file_id, _, _}, {_, acc} -> {:found, acc}
          _, {:not_found, acc} -> {:not_found, acc + 1}
          _, acc -> acc
        end,
        {:not_found, 0},
        q
      )

    :queue.split(index + 1, q)
    |> elem(0)
  end

  defp find_fitting_file(q, {file_id, blocks, _} = moveable) do
    case :queue.out(q) do
      {:empty, _} ->
        :empty

      {{:value, {new_file_id, _, spaces} = file}, _}
      when new_file_id != file_id and spaces >= blocks ->
        file

      {_, q} ->
        find_fitting_file(q, moveable)
    end
  end

  defp move_file(q, {src_id, src_b, _}, dest_id) do
    # 1 - add space to the left neighbor of src
    # 2 - remove src
    # 3 - zero space from dest
    # 4 - move src to the right of destination
    # 5 - adjust src space

    q = add_space_to_left_neighbor(q, src_id, :queue.new())

    :queue.filter(
      fn
        {^src_id, _, _} ->
          false

        {^dest_id, dest_b, dest_s} ->
          [
            {dest_id, dest_b, 0},
            {src_id, src_b, dest_s - src_b}
          ]

        _ ->
          true
      end,
      q
    )
  end

  defp add_space_to_left_neighbor(q1, file_id, acc) do
    case :queue.out_r(q1) do
      {:empty, _} ->
        acc

      {{:value, {^file_id, blocks, spaces}}, q2} ->
        case :queue.out_r(q2) do
          {{:value, {left_file_id, _, _}}, _} ->
            :queue.filtermap(
              fn
                {^left_file_id, b, s} -> {true, {left_file_id, b, s + blocks + spaces}}
                _ -> true
              end,
              q2
            )
            |> :queue.join(acc)

          _ ->
            :queue.join(q1, acc)
        end

      {{:value, file}, q} ->
        add_space_to_left_neighbor(q, file_id, :queue.in_r(file, acc))
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

  defp parse_input_as_queue(q, <<>>, _), do: q

  defp parse_input_as_queue(q, <<block::binary-size(1)>>, count) do
    :queue.in({count, String.to_integer(block), 0}, q)
  end

  defp parse_input_as_queue(
         q,
         <<block::binary-size(1), space::binary-size(1), rest::binary>>,
         count
       ) do
    q = :queue.in({count, String.to_integer(block), String.to_integer(space)}, q)
    parse_input_as_queue(q, rest, count + 1)
  end
end
