defmodule Day8 do
  @moduledoc """
  Day 8 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(tree_heights, opts) when is_list(tree_heights) do
    tree_heights
    |> Util.Matrix.parse_matrix(to_integer: true)
    |> Util.Matrix.describe()
    |> convert_to_index()
    |> solve(opts)
  end

  def solve(tree_heights, scenic_score: true) when is_tuple(tree_heights) do
    tree_heights
    |> find_best_scenic_view_tree()
  end

  def solve(tree_heights, _opts) when is_tuple(tree_heights) do
    tree_heights
    |> find_visible_trees()
    |> length()
  end

  def solve(file_path, opts) do
    file_path
    |> read_tree_heights()
    |> solve(opts)
  end

  defp read_tree_heights(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp convert_to_index({tree_matrix, num_rows, num_columns}),
    do: {tree_matrix, num_rows - 1, num_columns - 1}

  defp find_visible_trees({tree_matrix, max_row_index, max_column_index}) do
    0..max_row_index
    |> Enum.reduce([], fn row_index, acc ->
      0..max_column_index
      |> Enum.reduce(acc, fn col_index, acc ->
        point = {row_index, col_index}

        point
        |> is_visible?(tree_matrix, max_row_index, max_column_index)
        |> update_acc(point, acc)
      end)
    end)
  end

  defp is_visible?({0, _col_index}, _tree_matrix, _num_rows, _num_columns), do: true
  defp is_visible?({_row_index, 0}, _tree_matrix, _num_rows, _num_columns), do: true

  defp is_visible?({row_index, col_index}, _tree_matrix, num_rows, num_columns)
       when row_index == num_rows or col_index == num_columns,
       do: true

  defp is_visible?({row_index, col_index}, tree_matrix, _num_rows, _num_columns) do
    tree_matrix
    |> Util.Matrix.get_point(row_index, col_index)
    |> is_visible?(tree_matrix)
  end

  defp is_visible?(point, tree_matrix) do
    with false <- is_visible_by_row?(point, tree_matrix) do
      is_visible_by_column?(point, tree_matrix)
    end
  end

  defp is_visible_by_column?({value, row_index, column_index}, tree_matrix) do
    tree_matrix
    |> Util.Matrix.fetch_column(column_index)
    |> Enum.with_index()
    |> Enum.split_while(&(elem(&1, 1) != row_index))
    |> is_visible_by_row?(value)
  end

  defp is_visible_by_row?({value, row_index, column_index}, tree_matrix) do
    tree_matrix
    |> Enum.at(row_index)
    |> Enum.with_index()
    |> Enum.split_while(&(elem(&1, 1) != column_index))
    |> is_visible_by_row?(value)
  end

  defp is_visible_by_row?({tree_to_the_left, [_current_tree | tree_to_the_right]}, value) do
    with false <- all_smaller?(tree_to_the_left, value) do
      all_smaller?(tree_to_the_right, value)
    end
  end

  defp all_smaller?(trees, value) do
    Enum.all?(trees, &(elem(&1, 0) < value))
  end

  defp update_acc(true, point, acc), do: [point] ++ acc
  defp update_acc(_false, _point, acc), do: acc

  defp find_best_scenic_view_tree({tree_matrix, max_row_index, max_column_index}) do
    0..max_row_index
    |> Enum.reduce(fn row_index, acc ->
      0..max_column_index
      |> Enum.reduce(acc, fn col_index, acc ->
        point = {row_index, col_index}

        point
        |> calculate_scenic_score(tree_matrix, max_row_index, max_column_index)
        |> keep_best_point(acc)
      end)
    end)
  end

  defp calculate_scenic_score({0, _col_index}, _tree_matrix, _num_rows, _num_columns), do: 0
  defp calculate_scenic_score({_row_index, 0}, _tree_matrix, _num_rows, _num_columns), do: 0

  defp calculate_scenic_score({row_index, col_index}, _tree_matrix, num_rows, num_columns)
       when row_index == num_rows or col_index == num_columns,
       do: 0

  defp calculate_scenic_score({row_index, col_index}, tree_matrix, _num_rows, _num_columns) do
    tree_matrix
    |> Util.Matrix.get_point(row_index, col_index)
    |> calculate_scenic_score(tree_matrix)
  end

  defp calculate_scenic_score(point, tree_matrix) do
    calculate_scenic_score_row(point, tree_matrix) *
      calculate_scenic_score_column(point, tree_matrix)
  end

  defp calculate_scenic_score_column({value, row_index, column_index}, tree_matrix) do
    tree_matrix
    |> Util.Matrix.fetch_column(column_index)
    |> Enum.with_index()
    |> Enum.split_while(&(elem(&1, 1) != row_index))
    |> calculate_scenic_score_row(value)
  end

  defp calculate_scenic_score_row({value, row_index, column_index}, tree_matrix) do
    tree_matrix
    |> Enum.at(row_index)
    |> Enum.with_index()
    |> Enum.split_while(&(elem(&1, 1) != column_index))
    |> calculate_scenic_score_row(value)
  end

  defp calculate_scenic_score_row({tree_to_the_left, [_current_tree | tree_to_the_right]}, value) do
    tree_to_the_left
    |> Enum.reverse()
    |> calculate_viewing_distance(value)
    |> Kernel.*(calculate_viewing_distance(tree_to_the_right, value))
  end

  defp calculate_viewing_distance([_one_tree], _value), do: 1

  defp calculate_viewing_distance(trees, value) do
    trees
    |> Enum.reduce_while(0, fn {tree, _index}, acc ->
      if value > tree do
        {:cont, acc + 1}
      else
        {:halt, acc + 1}
      end
    end)
  end

  defp keep_best_point(new_score, nil), do: new_score
  defp keep_best_point(new_score, current_score) when new_score > current_score, do: new_score
  defp keep_best_point(_new_score, current_score), do: current_score
end
