defmodule Day6 do
  @moduledoc """
  Day 6 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve([signal | _], _opts) do
    signal
    |> String.split("", trim: true)
    |> Enum.chunk_every(4, 1)
    |> Enum.find_index(&marker?/1)
    |> Kernel.+(4)
  end

  def solve(file_path, opts) do
    file_path
    |> read_signal()
    |> solve(opts)
  end

  defp read_signal(file_path) do
    FileReader.read(file_path)
  end

  defp marker?(chunk) do
    chunk
    |> MapSet.new()
    |> MapSet.size()
    |> Kernel.==(4)
  end
end
