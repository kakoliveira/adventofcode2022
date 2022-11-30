defmodule Util do
  @moduledoc """
  Generic helper functions
  """

  @type optional_default :: any

  @spec safe_to_integer(any, optional_default) :: integer | optional_default
  def safe_to_integer(value, default \\ nil)

  def safe_to_integer(value, _default) when is_integer(value), do: value

  def safe_to_integer(value, default) when is_binary(value) do
    case Integer.parse(value) do
      :error -> default
      {value, _rest} -> value
    end
  end

  def safe_to_integer(_value, default), do: default

  @spec manhattan_distance({number, number}, {number, number}) :: number
  def manhattan_distance({x, y}, {a, b}) do
    abs(x - a) + abs(y - b)
  end

  @spec calculate_median(list(number())) :: integer()
  def calculate_median(list) do
    sorted_list = Enum.sort(list)

    do_calculate_median(sorted_list, length(sorted_list))
  end

  defp do_calculate_median(list, sample_size) when rem(sample_size, 2) == 0 do
    mid_point = sample_size / 2

    Enum.at(list, floor(mid_point))
  end

  defp do_calculate_median(list, sample_size) do
    mid_point = sample_size / 2

    (Enum.at(list, floor(mid_point)) +
       Enum.at(list, ceil(mid_point))) / 2
  end

  @spec calculate_media(list(number()), keyword()) :: integer()
  def calculate_media(list, opts \\ []) do
    num_positions = length(list)

    list
    |> Enum.sum()
    |> Kernel./(num_positions)
    |> round(opts)
  end

  defp round(number, down_on_draw: true) do
    number
    |> Kernel.-(0.1)
    |> round()
  end

  defp round(number, _opts), do: round(number)
end
