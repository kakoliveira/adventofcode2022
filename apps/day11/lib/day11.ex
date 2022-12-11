defmodule Day11 do
  @moduledoc """
  Day 11 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(monkeys, _opts) when is_list(monkeys) do
    monkeys
    |> Enum.chunk_every(6)
    |> Map.new(&parse_monkey/1)
    |> run_rounds(20)
    |> Enum.map(&elem(&1, 1).inspections)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def solve(file_path, opts) do
    file_path
    |> read_monkeys()
    |> solve(opts)
  end

  defp read_monkeys(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
    |> Enum.map(&String.trim/1)
  end

  defp parse_monkey([monkey_id, starting_items, operation | test]) do
    {parse_monkey_id(monkey_id),
     %{
       items: parse_starting_items(starting_items),
       worry_operation: parse_operation(operation),
       target_strategy: parse_target_strategy(test),
       inspections: 0
     }}
  end

  defp parse_monkey_id("Monkey " <> monkey_id) do
    String.trim_trailing(monkey_id, ":")
  end

  defp parse_starting_items("Starting items: " <> items) do
    items
    |> String.split(", ")
    |> Enum.map(&Util.safe_to_integer/1)
  end

  defp parse_operation("Operation: new = old * old") do
    &power_operation(&1, 2)
  end

  defp parse_operation("Operation: new = old * " <> value) do
    &multiply_operation(&1, Util.safe_to_integer(value))
  end

  defp parse_operation("Operation: new = old + " <> value) do
    &add_operation(&1, Util.safe_to_integer(value))
  end

  defp power_operation(worry, value), do: worry ** value
  defp multiply_operation(worry, value), do: worry * value
  defp add_operation(worry, value), do: worry + value

  defp parse_target_strategy([
         "Test: divisible by " <> value,
         "If true: throw to monkey " <> if_true_monkey_id,
         "If false: throw to monkey " <> if_false_monkey_id
       ]) do
    &pick_target(&1, Util.safe_to_integer(value), if_true_monkey_id, if_false_monkey_id)
  end

  defp pick_target(worry, divisibility_test, if_true_monkey_id, if_false_monkey_id) do
    if rem(worry, divisibility_test) == 0 do
      if_true_monkey_id
    else
      if_false_monkey_id
    end
  end

  defp run_rounds(monkeys, num_rounds) do
    Enum.reduce(1..num_rounds, monkeys, &play_round/2)
  end

  defp play_round(_round, monkeys) do
    Enum.reduce(monkeys, monkeys, &monkey_round/2)
  end

  defp monkey_round({monkey_id, monkey}, monkeys) do
    items = get_items_to_inspect(monkeys, monkey_id)

    items
    |> Enum.map(&inspect_item(&1, monkey))
    |> move_items(monkey, monkeys)
    |> finish_round_for(monkey_id, length(items))
  end

  defp get_items_to_inspect(monkeys, monkey_id) do
    monkeys
    |> Map.get(monkey_id)
    |> Map.get(:items)
  end

  defp inspect_item(item, %{worry_operation: worry_operation}) do
    item
    |> worry_operation.()
    |> apply_worry_relief()
  end

  defp apply_worry_relief(worry), do: Integer.floor_div(worry, 3)

  defp move_items(items, %{target_strategy: target_strategy}, monkeys) do
    items
    |> Enum.reduce(monkeys, fn item, monkeys ->
      item
      |> target_strategy.()
      |> move_item(item, monkeys)
    end)
  end

  defp move_item(target_monkey_id, item, monkeys) do
    Map.update!(monkeys, target_monkey_id, &receive_item(&1, item))
  end

  defp receive_item(monkey, item) do
    Map.update!(monkey, :items, &Enum.concat(&1, [item]))
  end

  defp finish_round_for(monkeys, monkey_id, num_inspections) do
    Map.update!(monkeys, monkey_id, &finish_round(&1, num_inspections))
  end

  defp finish_round(monkey, num_inspections) do
    monkey
    |> Map.put(:items, [])
    |> Map.update!(:inspections, &(&1 + num_inspections))
  end
end
