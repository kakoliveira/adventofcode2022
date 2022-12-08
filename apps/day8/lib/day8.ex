defmodule Day8 do
  @moduledoc """
  Day 8 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(tree_heights, opts) when is_list(tree_heights) do
    tree_heights
    |> Util.Matrix.parse_matrix(to_integer: true)
    |> do_solve(opts)
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

  defp do_solve(tree_heights, scenic_score: true) do
    Util.Matrix.reduce_matrix(tree_heights, &find_best_scenic_view_tree/3)
  end

  defp do_solve(tree_heights, _opts) do
    tree_heights
    |> Util.Matrix.reduce_matrix(&find_visible_trees/3, [])
    |> length()
  end

  defp find_visible_trees(point, acc, {tree_matrix, max_row_index, max_column_index}) do
    point
    |> evaluate_point(tree_matrix, max_row_index, max_column_index, true, &is_visible?/2)
    |> update_acc(point, acc)
  end

  defp evaluate_point(
         {0, _col_index},
         _tree_matrix,
         _max_row_index,
         _max_column_index,
         edge_value,
         _evaluator
       ),
       do: edge_value

  defp evaluate_point(
         {_row_index, 0},
         _tree_matrix,
         _max_row_index,
         _max_column_index,
         edge_value,
         _evaluator
       ),
       do: edge_value

  defp evaluate_point(
         {row_index, col_index},
         _tree_matrix,
         max_row_index,
         max_column_index,
         edge_value,
         _evaluator
       )
       when row_index == max_row_index or col_index == max_column_index,
       do: edge_value

  defp evaluate_point(
         {row_index, col_index},
         tree_matrix,
         _max_row_index,
         _max_column_index,
         _edge_value,
         evaluator
       )
       when is_function(evaluator, 2) do
    tree_matrix
    |> Util.Matrix.get_point(row_index, col_index)
    |> evaluator.(tree_matrix)
  end

  defp is_visible?({tree_to_the_left, tree_to_the_right}, value) do
    with false <- all_smaller?(tree_to_the_left, value) do
      all_smaller?(tree_to_the_right, value)
    end
  end

  defp is_visible?(point, tree_matrix) do
    with false <- is_visible_by_row?(point, tree_matrix) do
      is_visible_by_column?(point, tree_matrix)
    end
  end

  defp all_smaller?(trees, value) do
    Enum.all?(trees, &(elem(&1, 0) < value))
  end

  defp is_visible_by_row?(point, tree_matrix),
    do: evaluate_row(point, tree_matrix, &is_visible?/2)

  defp is_visible_by_column?(point, tree_matrix),
    do: evaluate_column(point, tree_matrix, &is_visible?/2)

  defp evaluate_row({value, row_index, column_index}, tree_matrix, evaluator)
       when is_function(evaluator, 2) do
    tree_matrix
    |> Enum.at(row_index)
    |> Enum.with_index()
    |> Enum.split_while(&(elem(&1, 1) != column_index))
    |> remove_current_point()
    |> evaluator.(value)
  end

  defp evaluate_column({value, row_index, column_index}, tree_matrix, evaluator)
       when is_function(evaluator, 2) do
    tree_matrix
    |> Util.Matrix.fetch_column(column_index)
    |> Enum.with_index()
    |> Enum.split_while(&(elem(&1, 1) != row_index))
    |> remove_current_point()
    |> evaluator.(value)
  end

  defp remove_current_point({tree_to_the_left, [_current_tree | tree_to_the_right]}),
    do: {tree_to_the_left, tree_to_the_right}

  defp update_acc(true, point, acc), do: [point] ++ acc
  defp update_acc(_false, _point, acc), do: acc

  defp find_best_scenic_view_tree(point, acc, {tree_matrix, max_row_index, max_column_index}) do
    point
    |> evaluate_point(tree_matrix, max_row_index, max_column_index, 0, &calculate_scenic_score/2)
    |> keep_best_point(acc)
  end

  defp calculate_scenic_score({tree_to_the_left, tree_to_the_right}, value) do
    tree_to_the_left
    |> Enum.reverse()
    |> calculate_viewing_distance(value)
    |> Kernel.*(calculate_viewing_distance(tree_to_the_right, value))
  end

  defp calculate_scenic_score(point, tree_matrix) do
    calculate_scenic_score_row(point, tree_matrix) *
      calculate_scenic_score_column(point, tree_matrix)
  end

  defp calculate_scenic_score_row(point, tree_matrix),
    do: evaluate_row(point, tree_matrix, &calculate_scenic_score/2)

  defp calculate_scenic_score_column(point, tree_matrix),
    do: evaluate_column(point, tree_matrix, &calculate_scenic_score/2)

  defp calculate_viewing_distance([_one_tree], _value), do: 1

  defp calculate_viewing_distance(trees, value) do
    Enum.reduce_while(trees, 0, &count_visible_tree(&1, &2, value))
  end

  defp count_visible_tree({tree, _index}, acc, value) when value > tree, do: {:cont, acc + 1}
  defp count_visible_tree(_tree, acc, _value), do: {:halt, acc + 1}

  defp keep_best_point(new_score, nil), do: new_score
  defp keep_best_point(new_score, current_score) when new_score > current_score, do: new_score
  defp keep_best_point(_new_score, current_score), do: current_score
end
