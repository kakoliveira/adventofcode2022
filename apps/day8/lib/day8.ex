defmodule Day8 do
  @moduledoc """
  Day 8 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(tree_heights, _opts) when is_list(tree_heights) do
    tree_heights
    |> Util.Matrix.parse_matrix(to_integer: true)
    |> Util.Matrix.describe()
    |> convert_to_index()
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
end
