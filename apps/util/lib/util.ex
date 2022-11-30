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
end
