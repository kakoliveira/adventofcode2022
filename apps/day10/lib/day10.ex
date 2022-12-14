defmodule Day10 do
  @moduledoc """
  Day 10 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(cpu_instructions, draw_crt: true) when is_list(cpu_instructions) do
    cpu_instructions
    |> perform_cycles(1)
    |> Map.get(:cycles)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.chunk_every(40, 40, :discard)
    |> Enum.map(fn row ->
      Enum.map(row, &draw_pixel/1)
    end)
    |> draw_crt()
  end

  def solve(cpu_instructions, _opts) when is_list(cpu_instructions) do
    cpu_instructions
    |> perform_cycles(1)
    |> take_cycles(20, 40, 220)
    |> Enum.map(&calculate_signal_strength/1)
    |> Enum.sum()
  end

  def solve(file_path, opts) do
    file_path
    |> read_cpu_instructions()
    |> solve(opts)
  end

  defp read_cpu_instructions(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp perform_cycles(cpu_instructions, initial_x_value) do
    Enum.reduce(
      cpu_instructions,
      %{
        current_cycle: 1,
        cycles: %{1 => initial_x_value},
        x: initial_x_value
      },
      &perform_instruction/2
    )
  end

  defp perform_instruction(instruction, acc) do
    instruction
    |> parse_instruction()
    |> execute_instruction(acc)
  end

  defp parse_instruction("noop"), do: :noop
  defp parse_instruction("addx " <> value), do: {:add, Util.safe_to_integer(value)}

  defp execute_instruction({:add, value}, acc) do
    acc
    |> then(&execute_instruction(:noop, &1))
    |> bump_current_cycle()
    |> update_x_value(value)
    |> put_cycle()
  end

  defp execute_instruction(:noop, acc) do
    acc
    |> bump_current_cycle()
    |> put_cycle()
  end

  defp put_cycle(%{current_cycle: current_cycle, x: x_value} = acc) do
    Map.update!(acc, :cycles, &Map.put_new(&1, current_cycle, x_value))
  end

  defp bump_current_cycle(acc) do
    Map.update!(acc, :current_cycle, &(&1 + 1))
  end

  defp update_x_value(acc, value) do
    Map.update!(acc, :x, &(&1 + value))
  end

  defp take_cycles(%{cycles: cycles}, initial_cycle, relevant_cycle_period, last_cycle) do
    initial_cycle
    |> get_relevant_cycles(relevant_cycle_period, last_cycle)
    |> then(&Map.take(cycles, &1))
  end

  defp get_relevant_cycles(initial_cycle, relevant_cycle_period, last_cycle) do
    last_cycle
    |> Kernel.-(initial_cycle)
    |> Integer.floor_div(relevant_cycle_period)
    |> then(&generate_relevant_cycles(initial_cycle, &1, relevant_cycle_period))
  end

  defp generate_relevant_cycles(initial_cycle, num_cycles, relevant_cycle_period) do
    Enum.map(0..num_cycles, &(&1 * relevant_cycle_period + initial_cycle))
  end

  defp calculate_signal_strength({cycle, x_value}), do: cycle * x_value

  defp draw_pixel({cycle, x_value}) do
    cycle
    |> get_sprite_position()
    |> draw_pixel(x_value)
  end

  defp draw_pixel(sprite_position, x_value)
       when sprite_position in [x_value - 1, x_value, x_value + 1],
       do: "#"

  defp draw_pixel(_sprite_position, _x_value), do: "."

  defp get_sprite_position(cycle) do
    cycle
    |> Kernel.-(1)
    |> rem(40)
  end

  defp draw_crt(crt_matrix) do
    Enum.map(crt_matrix, &Enum.join/1)
  end
end
