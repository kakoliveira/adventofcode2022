defmodule Day2 do
  @moduledoc """
  Day 2 puzzle solutions
  """

  @lost 0
  @draw 3
  @won 6

  @rock 1
  @paper 2
  @scissors 3

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(rounds, opts) when is_list(rounds) do
    calculate_round_score_fn =
      opts
      |> Keyword.get(:by_outcomes, false)
      |> get_score_calculator()

    rounds
    |> Enum.map(calculate_round_score_fn)
    |> Enum.sum()
  end

  def solve(file_path, opts) do
    rounds = read_rounds(file_path)

    solve(rounds, opts)
  end

  defp read_rounds(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp get_score_calculator(true), do: &calculate_round_score_by_outcome/1

  defp get_score_calculator(_by_outcomes), do: &calculate_round_score/1

  # Rock vs Paper
  defp calculate_round_score("A Y"), do: @won + @paper
  # Rock vs Rock
  defp calculate_round_score("A X"), do: @draw + @rock
  # Rock vs Scissors
  defp calculate_round_score("A Z"), do: @lost + @scissors
  # Paper vs Paper
  defp calculate_round_score("B Y"), do: @draw + @paper
  # Paper vs Rock
  defp calculate_round_score("B X"), do: @lost + @rock
  # Paper vs Scissors
  defp calculate_round_score("B Z"), do: @won + @scissors
  # Scissors vs Paper
  defp calculate_round_score("C Y"), do: @lost + @paper
  # Scissors vs Rock
  defp calculate_round_score("C X"), do: @won + @rock
  # Scissors vs Scissors
  defp calculate_round_score("C Z"), do: @draw + @scissors

  # Rock need to draw (Rock)
  defp calculate_round_score_by_outcome("A Y"), do: calculate_round_score("A X")
  # Rock need to lose (Scissors)
  defp calculate_round_score_by_outcome("A X"), do: calculate_round_score("A Z")
  # Rock need to win (Paper)
  defp calculate_round_score_by_outcome("A Z"), do: calculate_round_score("A Y")
  # Paper need to draw (Paper)
  defp calculate_round_score_by_outcome("B Y"), do: calculate_round_score("B Y")
  # Paper need to lose (Rock)
  defp calculate_round_score_by_outcome("B X"), do: calculate_round_score("B X")
  # Paper need to win (Scissors)
  defp calculate_round_score_by_outcome("B Z"), do: calculate_round_score("B Z")
  # Scissors need to draw (Scissors)
  defp calculate_round_score_by_outcome("C Y"), do: calculate_round_score("C Z")
  # Scissors need to lose (Paper)
  defp calculate_round_score_by_outcome("C X"), do: calculate_round_score("C Y")
  # Scissors need to win (Rock)
  defp calculate_round_score_by_outcome("C Z"), do: calculate_round_score("C X")
end
