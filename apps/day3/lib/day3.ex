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

  def solve(rucksacks, part: 2) when is_list(rucksacks) do
    rucksacks
    |> Enum.chunk_every(3)
    |> Enum.map(&get_badge_priority/1)
    |> Enum.sum()
  end

  def solve(rucksacks, _opts) when is_list(rucksacks) do
    rucksacks
    |> Enum.map(&get_priority/1)
    |> Enum.sum()
  end

  def solve(file_path, opts) do
    file_path
    |> read_rucksacks()
    |> solve(opts)
  end

  defp read_rucksacks(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp get_priority(rucksack) do
    rucksack
    |> split_in_half()
    |> get_shared_item()
    |> calculate_item_priority()
  end

  defp split_in_half(rucksack) do
    rucksack
    |> String.length()
    |> calculate_mid_point()
    |> then(&String.split_at(rucksack, &1))
  end

  defp calculate_mid_point(rucksack_length) when rem(rucksack_length, 2) == 0 do
    Integer.floor_div(rucksack_length, 2)
  end

  defp calculate_mid_point(rucksack_length),
    do:
      raise(ArgumentError,
        message: "expected `rucksack_length` to be even, got: #{rucksack_length}"
      )

  defp get_shared_item({compartment_one, compartment_two}) do
    get_shared_item([compartment_one, compartment_two])
  end

  defp get_shared_item([first_rucksack | other_rucksacks]) do
    initial_set = build_set(first_rucksack)

    other_rucksacks
    |> Enum.reduce(initial_set, &intersect/2)
    |> Enum.at(0)
  end

  defp intersect(rucksack, set) do
    rucksack
    |> build_set()
    |> MapSet.intersection(set)
  end

  defp build_set(compartment) do
    compartment
    |> String.split("", trim: true)
    |> MapSet.new()
  end

  defp calculate_item_priority(item) do
    Enum.find_index(@letters, &(&1 == item)) + 1
  end

  defp get_badge_priority(rucksack_group) do
    rucksack_group
    |> get_shared_item()
    |> calculate_item_priority()
  end
end
