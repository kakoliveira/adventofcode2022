defmodule Day5 do
  @moduledoc """
  Day 5 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: String.t()
  def solve(file_path_or_list, opts \\ [])

  def solve(crate_stack_procedure, opts) when is_list(crate_stack_procedure) do
    {stack_configurations, instructions} = split_stacks_from_instructions(crate_stack_procedure)

    stack_configurations
    |> parse_stacks()
    |> apply_instructions(instructions, opts)
    |> take_top_crates()
  end

  def solve(file_path, opts) do
    file_path
    |> read_crate_stack_procedure()
    |> solve(opts)
  end

  defp read_crate_stack_procedure(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp split_stacks_from_instructions(crate_stack_procedure) do
    crate_stack_procedure
    |> Enum.chunk_by(&String.starts_with?(&1, "move"))
    |> then(fn [stack_config, instructions] ->
      {stack_config, instructions}
    end)
  end

  defp parse_stacks(stack_configurations) do
    stack_configurations
    |> Enum.map(&String.split(&1, ""))
    |> then(fn matrix ->
      num_columns = Util.Matrix.column_size(matrix)

      Enum.reduce(0..num_columns, [], fn column, acc ->
        matrix
        |> Util.Matrix.fetch_column(column)
        |> Enum.reverse()
        |> accumulate_stacks(acc)
      end)
    end)
    |> Enum.reverse()
  end

  defp accumulate_stacks([stack_id | stack_config], acc) do
    stack_id
    |> Util.safe_to_integer()
    |> then(fn
      nil ->
        acc

      id ->
        id
        |> Day5.Stack.new(stack_config)
        |> then(fn stack ->
          [stack] ++ acc
        end)
    end)
  end

  defp apply_instructions(stacks, instructions, opts) do
    stacks = Enum.with_index(stacks)

    instructions
    |> Enum.reduce(stacks, fn instruction, stacks ->
      %{
        "num_crates" => num_crates,
        "from_stack_id" => from_stack_id,
        "to_stack_id" => to_stack_id
      } = parse_instruction(instruction)

      {from_stack, from_stack_index} = get_stack(stacks, from_stack_id)
      {to_stack, to_stack_index} = get_stack(stacks, to_stack_id)

      {from_stack, to_stack} = Day5.Stack.move(from_stack, to_stack, num_crates, opts)

      stacks
      |> update_stacks({from_stack, from_stack_index})
      |> update_stacks({to_stack, to_stack_index})
    end)
    |> Enum.map(&elem(&1, 0))
  end

  defp parse_instruction(instruction) do
    ~r/move\ (?<num_crates>\d+)\ from\ (?<from_stack_id>\d)\ to\ (?<to_stack_id>\d)/
    |> Regex.named_captures(instruction)
    |> Enum.map(fn {key, value} ->
      {key, Util.safe_to_integer(value)}
    end)
    |> Map.new()
  end

  defp get_stack(stacks, stack_id) do
    Enum.find(stacks, &(elem(&1, 0).id == stack_id))
  end

  defp update_stacks(stacks, {_stack, index} = stack) do
    List.replace_at(stacks, index, stack)
  end

  defp take_top_crates(final_stacks) do
    Enum.map_join(final_stacks, &Day5.Stack.top/1)
  end
end
