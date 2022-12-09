defmodule Day9 do
  @moduledoc """
  Day 9 puzzle solutions
  """

  # - - -
  # - H -
  # - - -
  defguard head_covers_tail?(head, tail) when head == tail

  # T - -
  # T H -
  # T - -
  defguard is_tail_to_the_left?(head, tail) when elem(head, 0) == elem(tail, 0) + 1

  # - - T
  # - H T
  # - - T
  defguard is_tail_to_the_right?(head, tail) when elem(head, 0) == elem(tail, 0) - 1

  # T T T
  # - H -
  # - - -
  defguard is_tail_above?(head, tail) when elem(head, 1) == elem(tail, 1) - 1

  # - - -
  # - H -
  # T T T
  defguard is_tail_bellow?(head, tail) when elem(head, 1) == elem(tail, 1) + 1

  # - T -
  # - H -
  # - T -
  defguard is_tail_adjacent_up_or_down?(head, tail)
           when elem(head, 0) == elem(tail, 0) and
                  (elem(head, 1) == elem(tail, 1) + 1 or elem(head, 1) == elem(tail, 1) - 1)

  # - - -
  # T H T
  # - - -
  defguard is_tail_adjacent_left_or_right?(head, tail)
           when elem(head, 1) == elem(tail, 1) and
                  (elem(head, 0) == elem(tail, 0) + 1 or elem(head, 0) == elem(tail, 0) - 1)

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(rope_motions, _opts) when is_list(rope_motions) do
    rope_motions
    |> Enum.reduce(
      %{tail_visits: MapSet.new([{0, 0}]), head: {0, 0}, tail: {0, 0}},
      &apply_motion/2
    )
    |> Map.fetch!(:tail_visits)
    |> MapSet.size()
  end

  def solve(file_path, opts) do
    file_path
    |> read_rope_motions()
    |> solve(opts)
  end

  defp read_rope_motions(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp apply_motion({direction, steps}, %{head: head, tail: tail} = acc)
       when head_covers_tail?(head, tail) do
    acc
    |> update_head(direction, steps)
    |> move_tail_straight_line(direction, steps)
    |> update_visited_points(tail)
  end

  defp apply_motion({direction, _steps} = motion, %{head: head, tail: tail} = acc)
       when (is_tail_to_the_left?(head, tail) and direction == :right) or
              (is_tail_to_the_right?(head, tail) and direction == :left) or
              (is_tail_above?(head, tail) and direction == :down) or
              (is_tail_bellow?(head, tail) and direction == :up) do
    acc
    |> Map.update!(:tail, fn _ -> head end)
    |> then(&apply_motion(motion, &1))
  end

  defp apply_motion({direction, steps}, %{head: head, tail: tail} = acc)
       when (is_tail_adjacent_left_or_right?(head, tail) and direction in [:up, :down]) or
              (is_tail_adjacent_up_or_down?(head, tail) and direction in [:right, :left]) do
    acc
    |> update_head(direction, 1)
    |> maybe_move_tail({direction, steps})
  end

  defp apply_motion({direction, 1}, acc), do: update_head(acc, direction, 1)

  defp apply_motion({direction, steps}, acc) do
    acc
    |> update_head(direction, 1)
    |> then(&apply_motion({direction, steps - 1}, &1))
  end

  defp apply_motion(motion, acc) do
    motion
    |> parse_motion()
    |> apply_motion(acc)
  end

  defp parse_motion({direction, steps}), do: {direction, Util.safe_to_integer(steps)}
  defp parse_motion("R " <> steps), do: parse_motion({:right, steps})
  defp parse_motion("L " <> steps), do: parse_motion({:left, steps})
  defp parse_motion("U " <> steps), do: parse_motion({:up, steps})
  defp parse_motion("D " <> steps), do: parse_motion({:down, steps})

  defp update_head(acc, direction, steps), do: update_acc(acc, :head, direction, steps)

  defp move_tail_straight_line(acc, _direction, 1), do: acc

  defp move_tail_straight_line(acc, direction, steps),
    do: update_acc(acc, :tail, direction, steps - 1)

  defp maybe_move_tail(acc, {_direction, 1}), do: acc
  defp maybe_move_tail(acc, {direction, steps}), do: apply_motion({direction, steps - 1}, acc)

  defp update_acc(acc, field, direction, steps) do
    Map.update!(acc, field, &update_point(&1, direction, steps))
  end

  defp update_point({x, y}, :right, steps), do: {x + steps, y}
  defp update_point({x, y}, :left, steps), do: {x - steps, y}
  defp update_point({x, y}, :up, steps), do: {x, y + steps}
  defp update_point({x, y}, :down, steps), do: {x, y - steps}

  defp update_visited_points(
         %{tail: {final_tail_x, final_tail_y}} = acc,
         {start_tail_x, start_tail_y}
       ) do
    Map.update!(acc, :tail_visits, fn tail_visits ->
      start_tail_x..final_tail_x
      |> Enum.reduce(tail_visits, fn x, acc ->
        start_tail_y..final_tail_y
        |> Enum.reduce(acc, fn y, acc ->
          MapSet.put(acc, {x, y})
        end)
      end)
    end)
  end
end
