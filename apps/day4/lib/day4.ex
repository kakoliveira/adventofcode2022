defmodule Day4 do
  @moduledoc """
  Day 4 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(section_assignments, opts) when is_list(section_assignments) do
    overlap_strategy =
      opts
      |> Keyword.get(:full_overlap, false)
      |> get_overlap_strategy()

    section_assignments
    |> Enum.filter(&overlap?(&1, overlap_strategy))
    |> Enum.count()
  end

  def solve(file_path, opts) do
    file_path
    |> read_section_assignments()
    |> solve(opts)
  end

  defp read_section_assignments(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp get_overlap_strategy(true), do: &fully_overlap?/1
  defp get_overlap_strategy(_false), do: &overlap?/1

  defp overlap?(assignment_pair, overlap_strategy) when is_function(overlap_strategy, 1) do
    assignment_pair
    |> parse_assignment_pair()
    |> overlap_strategy.()
  end

  defp parse_assignment_pair(assignment_pair) do
    assignment_pair
    |> String.split(",")
    |> expand_sections()
  end

  defp expand_sections([first_elf_sections, second_elf_sections]) do
    {expand_sections(first_elf_sections), expand_sections(second_elf_sections)}
  end

  defp expand_sections(sections) do
    [start, finish] =
      sections
      |> String.split("-")
      |> Enum.map(&Util.safe_to_integer/1)

    MapSet.new(start..finish)
  end

  defp fully_overlap?({first_elf_sections, second_elf_sections}) do
    MapSet.subset?(first_elf_sections, second_elf_sections) ||
      MapSet.subset?(second_elf_sections, first_elf_sections)
  end

  defp overlap?({first_elf_sections, second_elf_sections}) do
    first_elf_sections
    |> MapSet.disjoint?(second_elf_sections)
    |> Kernel.not()
  end
end
