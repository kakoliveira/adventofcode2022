defmodule Day3 do
  @moduledoc """
  Day 3 puzzle solutions
  """

  @letters [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ]

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(rucksacks, _opts) when is_list(rucksacks) do
    rucksacks
    |> Enum.map(&get_priority/1)
    |> Enum.sum()
  end

  def solve(file_path, opts) do
    rucksacks = read_rucksacks(file_path)

    solve(rucksacks, opts)
  end

  defp read_rucksacks(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp get_priority(rucksack) do
    rucksack
    |> split_in(2)
    |> get_shared_item()
    |> then(&(Enum.find_index(@letters, fn letter -> &1 == letter end) + 1))
  end

  defp split_in(rucksack, num_compartments) do
    rucksack
    |> String.length()
    |> then(&String.split_at(rucksack, floor(&1 / num_compartments)))
  end

  defp get_shared_item({compartment_one, compartment_two}) do
    compartment_one = build_set(compartment_one)
    compartment_two = build_set(compartment_two)

    compartment_one
    |> MapSet.intersection(compartment_two)
    |> MapSet.to_list()
    |> List.first()
  end

  defp build_set(compartment) do
    compartment
    |> String.split("", trim: true)
    |> MapSet.new()
  end
end
