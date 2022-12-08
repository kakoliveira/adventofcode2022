defmodule Util.Matrix do
  @moduledoc """
  Helper functions when working with matrices
  """

  @type matrix :: list(list())

  @spec parse_matrix(list(String.t()), keyword()) :: matrix()
  def parse_matrix(lines, opts \\ []) do
    Enum.map(lines, &parse_matrix_row(&1, opts))
  end

  defp parse_matrix_row(matrix_row, opts) do
    delimiter = Keyword.get(opts, :delimiter, "")
    to_integer? = Keyword.get(opts, :to_integer, false)

    matrix_row
    |> String.split(delimiter, trim: true)
    |> to_integer(to_integer?)
  end

  defp to_integer(row, false), do: row

  defp to_integer(row, true) do
    Enum.map(row, &Util.safe_to_integer/1)
  end

  @spec column_size(matrix()) :: non_neg_integer
  def column_size(matrix) do
    matrix
    |> List.first()
    |> length()
  end

  @spec fetch_column(matrix(), non_neg_integer()) :: list()
  def fetch_column(matrix, column) do
    Enum.map(matrix, &Enum.at(&1, column))
  end

  @spec get_point(matrix(), integer(), integer()) :: {any(), integer(), integer()}
  def get_point(matrix, row_index, column_index) do
    value =
      matrix
      |> Enum.at(row_index)
      |> Enum.at(column_index)

    {value, row_index, column_index}
  end

  @spec set(matrix(), integer, integer, any) :: matrix()
  def set(matrix, row_index, column_index, value) do
    matrix
    |> Enum.at(row_index)
    |> List.replace_at(column_index, value)
    |> then(&List.replace_at(matrix, row_index, &1))
  end

  @spec describe(matrix()) :: {matrix(), integer(), integer()}
  def describe(matrix) do
    num_columns = column_size(matrix)
    num_rows = length(matrix)

    {matrix, num_rows, num_columns}
  end

  @spec reduce_matrix(matrix() | {matrix(), integer(), integer()}, function(), any()) :: any()
  def reduce_matrix(matrix, reducer, initial_value \\ nil)

  def reduce_matrix(matrix, reducer, initial_value)
      when is_list(matrix) and is_function(reducer, 3) do
    matrix
    |> describe()
    |> convert_to_index()
    |> reduce_matrix(reducer, initial_value)
  end

  def reduce_matrix({matrix, max_row_index, max_column_index}, reducer, initial_value)
      when is_list(matrix) and is_function(reducer, 3) do
    Enum.reduce(0..max_row_index, initial_value, fn row_index, acc ->
      Enum.reduce(0..max_column_index, acc, fn col_index, acc ->
        reducer.({row_index, col_index}, acc, {matrix, max_row_index, max_column_index})
      end)
    end)
  end

  defp convert_to_index({matrix, num_rows, num_columns}),
    do: {matrix, num_rows - 1, num_columns - 1}
end
