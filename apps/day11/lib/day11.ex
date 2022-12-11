defmodule Day11 do
  @moduledoc """
  Day 11 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(monkeys, opts) when is_list(monkeys) do
    num_rounds = Keyword.get(opts, :rounds, 20)
    apply_relief? = Keyword.get(opts, :relief, true)

    monkeys
    |> Enum.chunk_every(6)
    |> Map.new(&parse_monkey/1)
    |> run_rounds(num_rounds, apply_relief?)
    |> elem(1)
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
       starting_items: parse_starting_items(starting_items),
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

  defp run_rounds(monkeys, num_rounds, apply_relief?) do
    state = {prepare_items(monkeys), monkeys}

    Enum.reduce(1..num_rounds, state, &play_round(&1, &2, apply_relief?))
  end

  defp prepare_items(monkeys) do
    monkeys
    |> Enum.flat_map(&get_items/1)
    |> Enum.with_index()
    |> Map.new(&{elem(&1, 1), elem(&1, 0)})
  end

  defp get_items({monkey_id, %{starting_items: starting_items}}) do
    Enum.map(starting_items, &{monkey_id, &1})
  end

  defp play_round(_round, {items, monkeys}, apply_relief?) do
    Enum.reduce(monkeys, {items, monkeys}, fn {monkey_id, _}, {items, monkeys} ->
      items
      |> take_by_monkey(monkey_id)
      |> Enum.reduce({items, monkeys}, &monkey_round(&1, &2, apply_relief?))
    end)
  end

  defp take_by_monkey(items, monkey_id) do
    Map.filter(items, &(elem(elem(&1, 1), 0) == monkey_id))
  end

  defp monkey_round({key, {monkey_id, worry}}, {items, monkeys}, apply_relief?) do
    %{target_strategy: target_strategy} = monkey = Map.get(monkeys, monkey_id)

    new_worry = inspect_item(worry, monkey, apply_relief?)

    target_monkey = target_strategy.(new_worry)

    {Map.put(items, key, {target_monkey, new_worry}), finish_round_for(monkeys, monkey_id)}
  end

  defp inspect_item(item, %{worry_operation: worry_operation}, apply_relief?) do
    item
    |> worry_operation.()
    |> apply_worry_relief(apply_relief?)
  end

  defp apply_worry_relief(worry, false), do: worry
  defp apply_worry_relief(worry, _true), do: Integer.floor_div(worry, 3)

  defp finish_round_for(monkeys, monkey_id) do
    Map.update!(monkeys, monkey_id, &finish_round/1)
  end

  defp finish_round(monkey) do
    Map.update!(monkey, :inspections, &(&1 + 1))
  end
end
