defmodule Day5.Stack do
  @moduledoc """
  Represents a Stack of crates
  """

  @type t :: %__MODULE__{
          crate_stack: list(String.t()),
          id: integer()
        }

  defstruct crate_stack: [], id: nil

  @spec new(stack_id :: integer(), stack_config :: list(String.t())) :: t()
  def new(stack_id, stack_config) do
    %__MODULE__{
      crate_stack: clean_stack(stack_config),
      id: stack_id
    }
  end

  defp clean_stack(stack_config) do
    stack_config
    |> Enum.reject(&(&1 == " "))
    |> Enum.reverse()
  end

  @spec move(from_stack :: t(), to_stack :: t(), num_crates :: integer()) :: {t(), t()}
  def move(from_stack, to_stack, num_crates) do
    {from_stack, crates} = pop(from_stack, num_crates)

    to_stack = put(to_stack, crates)

    {from_stack, to_stack}
  end

  defp pop(%__MODULE__{crate_stack: crate_stack} = stack, num_crates) do
    {moved_crates, updated_stack} =
      Enum.reduce(1..num_crates, {[], crate_stack}, fn _crate_number, {moved_crates, crates} ->
        {crate, updated_stack} = List.pop_at(crates, 0)

        {[crate] ++ moved_crates, updated_stack}
      end)

    {%{stack | crate_stack: updated_stack}, moved_crates}
  end

  defp put(%__MODULE__{crate_stack: crate_stack} = stack, crates) do
    %{stack | crate_stack: crates ++ crate_stack}
  end

  @spec top(stack :: t()) :: String.t()
  def top(%__MODULE__{crate_stack: [top_crate | _]}) do
    top_crate
  end
end
