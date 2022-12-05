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
    |> build_stacks()
  end

  defp build_stacks(matrix) do
    num_columns = Util.Matrix.column_size(matrix)

    Enum.reduce(num_columns..0, [], fn column, stacks ->
      matrix
      |> Util.Matrix.fetch_column(column)
      |> accumulate_stacks(stacks)
    end)
  end

  defp accumulate_stacks(stack_config, stacks) do
    stack_config
    |> List.last()
    |> Util.safe_to_integer()
    |> accumulate_stacks(stack_config, stacks)
  end

  defp accumulate_stacks(nil, _stack_config, stacks), do: stacks

  defp accumulate_stacks(stack_id, stack_config, stacks) do
    stack_config
    |> Enum.drop(-1)
    |> then(&Day5.Stack.new(stack_id, &1))
    |> then(&([&1] ++ stacks))
  end

  defp apply_instructions(stacks, instructions, opts) do
    stacks
    |> Enum.with_index()
    |> then(fn stacks -> Enum.reduce(instructions, stacks, &apply_instruction(&1, &2, opts)) end)
    |> Enum.map(&elem(&1, 0))
  end

  defp apply_instruction(instruction, stacks, opts) do
    %{
      "num_crates" => num_crates,
      "from_stack_id" => from_stack_id,
      "to_stack_id" => to_stack_id
    } = parse_instruction(instruction)

    {from_stack, from_stack_index} = get_stack(stacks, from_stack_id)
    {to_stack, to_stack_index} = get_stack(stacks, to_stack_id)

    {updated_from_stack, updated_to_stack} =
      Day5.Stack.move(from_stack, to_stack, num_crates, opts)

    stacks
    |> update_stacks({updated_from_stack, from_stack_index})
    |> update_stacks({updated_to_stack, to_stack_index})
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
    Enum.map_join(final_stacks, &Day5.Stack.top_crate/1)
  end
end
