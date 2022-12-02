defmodule Day1 do
  @moduledoc """
  Day 1 puzzle solutions
  """

  def solve(file_path: file_path) do
    calories = read_calories(file_path)

    solve(calories: calories)
  end

  def solve(calories: calories) do
    calories
    |> Enum.chunk_while(
      [],
      fn
        nil, acc ->
          {:cont, acc, []}

        value, acc ->
          {:cont, [value] ++ acc}
      end,
      fn
        [] ->
          {:cont, []}

        acc ->
          {:cont, acc, []}
      end
    )
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  defp read_calories(file_path) do
    file_path
    |> FileReader.read()
    |> Enum.map(&Util.safe_to_integer/1)
  end
end
