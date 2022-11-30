defmodule FileReader do
  @moduledoc """
  Tools to handle file reading and parsing
  """

  @spec read(binary) :: [binary]
  def read(file_path) when is_bitstring(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
  end

  @spec clean_content(list) :: list
  def clean_content(content) when is_list(content) do
    Enum.reject(content, &(&1 in [nil, "", "\n"]))
  end
end
