defmodule Day1 do
  @moduledoc """
  Day 1 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(calories, opts) when is_list(calories) do
    elfs_to_sum = Keyword.get(opts, :elfs_to_sum, 1)

    calories
    |> Enum.chunk_while(
      [],
      &chunk_while_not_nil/2,
      &leftovers_are_chunks/1
    )
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(elfs_to_sum)
    |> Enum.sum()
  end

  def solve(file_path, opts) do
    calories = read_calories(file_path)

    solve(calories, opts)
  end

  defp read_calories(file_path) do
    file_path
    |> FileReader.read()
    |> Enum.map(&Util.safe_to_integer/1)
  end

  defp chunk_while_not_nil(nil, acc), do: {:cont, acc, []}
  defp chunk_while_not_nil(value, acc), do: {:cont, [value] ++ acc}

  defp leftovers_are_chunks([]), do: {:cont, []}
  defp leftovers_are_chunks(acc), do: {:cont, acc, []}
end
