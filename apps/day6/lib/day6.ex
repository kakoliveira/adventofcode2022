defmodule Day6 do
  @moduledoc """
  Day 6 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve([signal | _], maker_size: maker_size) when is_integer(maker_size) do
    signal
    |> String.split("", trim: true)
    |> Enum.chunk_every(maker_size, 1)
    |> Enum.find_index(&marker?(&1, maker_size))
    |> Kernel.+(maker_size)
  end

  def solve(file_path, opts) do
    file_path
    |> read_signal()
    |> solve(opts)
  end

  defp read_signal(file_path) do
    FileReader.read(file_path)
  end

  defp marker?(chunk, maker_size) do
    chunk
    |> MapSet.new()
    |> MapSet.size()
    |> Kernel.==(maker_size)
  end
end
