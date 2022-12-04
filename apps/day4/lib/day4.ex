defmodule Day4 do
  @moduledoc """
  Day 4 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(section_assignments, _opts) when is_list(section_assignments) do
    section_assignments
    |> Enum.filter(&fully_overlap?/1)
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

  defp fully_overlap?({first_elf_sections, second_elf_sections}) do
    MapSet.subset?(first_elf_sections, second_elf_sections) ||
      MapSet.subset?(second_elf_sections, first_elf_sections)
  end

  defp fully_overlap?(assignment_pair) do
    assignment_pair
    |> String.split(",")
    |> expand_sections()
    |> fully_overlap?()
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
end
