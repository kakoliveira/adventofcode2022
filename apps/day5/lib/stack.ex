defmodule Day5.Stack do
  @moduledoc """
  Represents a Stack of crates

  The first element of the `crate_stack` is the top of the stack.
  """

  @type t :: %__MODULE__{
          crate_stack: list(String.t()),
          id: integer()
        }

  defstruct crate_stack: [], id: nil

  @spec new(stack_id :: integer(), stack_config :: list(String.t())) :: t()
  def new(stack_id, stack_config) when is_integer(stack_id) do
    %__MODULE__{
      crate_stack: clean_stack(stack_config),
      id: stack_id
    }
  end

  defp clean_stack(stack_config) do
    Enum.reject(stack_config, &(&1 == " "))
  end

  @doc """
  ## Options

    `bulk_move`: boolean. Defaults to false.
      If true, the crane moves all the `num_crates` at once.
  """
  @spec move(from_stack :: t(), to_stack :: t(), num_crates :: integer(), opts :: keyword()) ::
          {t(), t()}
  def move(from_stack, to_stack, num_crates, opts \\ []) when is_integer(num_crates) do
    bulk_move = Keyword.get(opts, :bulk_move, false)

    {from_stack, crates} = take(from_stack, num_crates)

    to_stack = put(to_stack, crates, bulk_move)

    {from_stack, to_stack}
  end

  defp take(%__MODULE__{crate_stack: crate_stack} = stack, num_crates) do
    {moved_crates, updated_stack} = Enum.reduce(1..num_crates, {[], crate_stack}, &take_crate/2)

    {%{stack | crate_stack: updated_stack}, moved_crates}
  end

  defp take_crate(_crate_number, {moved_crates, crates}) do
    {crate, updated_stack} = List.pop_at(crates, 0)

    {[crate] ++ moved_crates, updated_stack}
  end

  defp put(%__MODULE__{crate_stack: crate_stack} = stack, crates, bulk_move) do
    crates
    |> apply_bulk_move_opt(bulk_move)
    |> then(&%{stack | crate_stack: &1 ++ crate_stack})
  end

  defp apply_bulk_move_opt(crates, true), do: Enum.reverse(crates)
  defp apply_bulk_move_opt(crates, _false), do: crates

  @spec top_crate(stack :: t()) :: String.t()
  def top_crate(%__MODULE__{crate_stack: [top_crate | _]}), do: top_crate
end
