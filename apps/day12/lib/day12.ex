defmodule Day12 do
  @moduledoc """
  Day 12 puzzle solutions
  """

  @start "S"
  @destination "E"

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(height_map, _opts) when is_list(height_map) do
    height_map
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Util.Matrix.describe()
    |> then(&%{matrix: elem(&1, 0), num_rows: elem(&1, 1), num_columns: elem(&1, 2)})
    |> set_starting_point(@start)
    |> breadth_first_search(@destination)
    |> Enum.sort_by(&length/1)
    |> List.first()
    |> length()
    |> Kernel.-(1)
  end

  def solve(file_path, opts) do
    file_path
    |> read_height_map()
    |> solve(opts)
  end

  defp read_height_map(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp set_starting_point(state, starting_char) do
    state.matrix
    |> Util.Matrix.fetch_column(0)
    |> Enum.find_index(&(&1 == starting_char))
    |> then(&Map.put(state, :current_point, Util.Matrix.get_point(state.matrix, &1, 0)))
  end

  defp breadth_first_search(state, destination) do
    state
    |> Map.update!(:matrix, &transform_matrix_into_map/1)
    |> recursive(state.current_point, destination, visit_point(%{}, state.current_point))
    |> Enum.map(&convert_to_list_of_nodes/1)
    |> Enum.filter(&(destination in &1))
  end

  defp transform_matrix_into_map(matrix) do
    Util.Matrix.reduce_matrix(
      matrix,
      fn {row_index, col_index} = point, acc, {matrix, _max_row_index, _max_column_index} ->
        Map.put(acc, point, Util.Matrix.get_point(matrix, row_index, col_index))
      end,
      %{}
    )
  end

  defp visit_point(visited, {value, row, column}) do
    Map.put_new(visited, {row, column}, {value, row, column})
  end

  defp convert_to_list_of_nodes(visited) do
    visited
    |> Map.values()
    |> Enum.map(&elem(&1, 0))
  end

  defp recursive(state, current_point, destination, visited) do
    current_point
    |> determine_next_possible_points(state)
    |> Enum.reject(&Map.has_key?(visited, {elem(&1, 1), elem(&1, 2)}))
    |> do_it_again(state, destination, visited)
  end

  defp do_it_again([], _, _, visited), do: [visited]

  defp do_it_again(next_points, state, destination, visited) do
    if reached_destination?(next_points, destination) do
      [visit_point(visited, {destination, nil, nil})]
    else
      Enum.flat_map(next_points, &recursive(state, &1, destination, visit_point(visited, &1)))
    end
  end

  defp determine_next_possible_points({value, row, column}, %{
         matrix: matrix,
         num_rows: num_rows,
         num_columns: num_columns
       }) do
    [{row - 1, column}, {row + 1, column}, {row, column - 1}, {row, column + 1}]
    |> Enum.reject(&out_of_bounds?(&1, num_rows, num_columns))
    |> Enum.map(&Map.get(matrix, {elem(&1, 0), elem(&1, 1)}))
    |> Enum.filter(&can_move_to?(value, &1))
  end

  defp out_of_bounds?({row, column}, num_rows, num_columns) do
    row < 0 or column < 0 or column > num_columns - 1 or row > num_rows - 1
  end

  defp can_move_to?(_, {@start, _, _}), do: false
  defp can_move_to?(@start, _), do: true
  defp can_move_to?("z", {@destination, _, _}), do: true

  defp can_move_to?(current_value, {next_value, _, _}) do
    ascii_of_current_value = ascii(current_value)

    ascii(next_value) in [
      ascii_of_current_value,
      ascii_of_current_value + 1
    ]
  end

  defp ascii(<<ascii::utf8>>), do: ascii

  defp reached_destination?(path, destination) do
    Enum.any?(path, &(elem(&1, 0) == destination))
  end
end
