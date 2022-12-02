defmodule Day1 do
  @moduledoc """
  Day 1 puzzle solutions
  """

  def solve(part: part, file_path: file_path) do
    calories = read_calories(file_path)

    solve(part: part, calories: calories)
  end

  def solve(part: part, calories: calories) do
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
    |> get_result(part)
  end

  defp read_calories(file_path) do
    file_path
    |> FileReader.read()
    |> Enum.map(&Util.safe_to_integer/1)
  end

  defp get_result(total_calories_per_elf, 1) do
    Enum.max(total_calories_per_elf)
  end

  defp get_result(total_calories_per_elf, 2) do
    total_calories_per_elf
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
