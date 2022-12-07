defmodule Day7 do
  @moduledoc """
  Day 7 puzzle solutions
  """

  @spec solve(binary() | list(), keyword()) :: number()
  def solve(file_path_or_list, opts \\ [])

  def solve(["$ cd /" | terminal_output], max_dir_size: max_dir_size)
      when is_list(terminal_output) and is_integer(max_dir_size) do
    terminal_output
    |> process_terminal_output(%{name: "/", children: [], size: 0}, "/")
    |> extract_directories_by_size(max_dir_size)
    |> Enum.map(& &1.size)
    |> Enum.sum()
  end

  def solve(file_path, opts) do
    file_path
    |> read_terminal_output()
    |> solve(opts)
  end

  defp read_terminal_output(file_path) do
    file_path
    |> FileReader.read()
    |> FileReader.clean_content()
  end

  defp process_terminal_output([], directory, _current_dir), do: directory

  defp process_terminal_output([terminal_output_line | terminal_output], directory, current_dir) do
    terminal_output_line
    |> parse_output_line()
    |> update_directory(directory, terminal_output)
    |> then(&process_terminal_output(elem(&1, 1), elem(&1, 0), current_dir))
  end

  defp parse_output_line("$ ls"), do: :noop
  defp parse_output_line("$ cd .."), do: :back
  defp parse_output_line("$ cd " <> directory_name), do: {:cd, directory_name}
  defp parse_output_line("dir " <> directory_name), do: {:dir, directory_name}

  defp parse_output_line(file) do
    file
    |> String.split(" ")
    |> parse_file_output()
  end

  defp parse_file_output([size, file_name]) do
    {:file, {file_name, Util.safe_to_integer(size)}}
  end

  defp update_directory(:noop, directory, terminal_output), do: {directory, terminal_output}

  defp update_directory(:back, directory, terminal_output),
    do: {{:end, directory}, terminal_output}

  defp update_directory({:cd, directory_name}, directory, terminal_output) do
    terminal_output
    |> process_subdirectory(
      %{name: directory_name, children: [], size: 0},
      directory_name
    )
    |> update_children(directory)
  end

  defp update_directory({:dir, directory_name}, directory, terminal_output) do
    directory
    |> Map.update!(:children, &append_directory(&1, directory_name))
    |> then(&{&1, terminal_output})
  end

  defp update_directory({:file, file_data}, directory, terminal_output) do
    directory
    |> Map.update!(:children, &append_file(&1, file_data))
    |> Map.update!(:size, &update_directory_size(&1, file_data))
    |> then(&{&1, terminal_output})
  end

  defp append_directory(children, directory_name) do
    [%{name: directory_name, children: [], size: 0}] ++ children
  end

  defp append_file(children, {file_name, size}) do
    [%{file_name: file_name, size: size}] ++ children
  end

  defp update_directory_size(dir_size, {_file_name, file_size}), do: dir_size + file_size
  defp update_directory_size(dir_size, subdirectory_size), do: dir_size + subdirectory_size

  defp process_subdirectory(terminal_output, {:end, directory}, _current_dir),
    do: {directory, terminal_output}

  defp process_subdirectory([], directory, _current_dir),
    do: {directory, []}

  defp process_subdirectory([terminal_output_line | terminal_output], directory, current_dir) do
    terminal_output_line
    |> parse_output_line()
    |> update_directory(directory, terminal_output)
    |> then(&process_subdirectory(elem(&1, 1), elem(&1, 0), current_dir))
  end

  defp update_children({%{name: dir_name, size: size} = child, terminal_output}, directory) do
    directory
    |> Map.update!(:children, fn children ->
      children
      |> Enum.find_index(&(Map.get(&1, :name) == dir_name))
      |> then(&List.replace_at(children, &1, child))
    end)
    |> Map.update!(:size, &update_directory_size(&1, size))
    |> then(&{&1, terminal_output})
  end

  defp extract_directories_by_size(%{children: children}, max_dir_size) do
    children
    |> extract_directories_by_size(max_dir_size, [])
  end

  defp extract_directories_by_size([], _max_dir_size, directories), do: directories

  defp extract_directories_by_size(
         [%{name: _name} = directory | children],
         max_dir_size,
         directories
       ) do
    directory
    |> maybe_add_current_directory(max_dir_size)
    |> Kernel.++(extract_directories_by_size(directory, max_dir_size))
    |> Kernel.++(directories)
    |> then(&extract_directories_by_size(children, max_dir_size, &1))
  end

  defp extract_directories_by_size([_file | children], max_dir_size, directories) do
    extract_directories_by_size(children, max_dir_size, directories)
  end

  defp maybe_add_current_directory(%{size: size} = directory, max_dir_size)
       when size <= max_dir_size do
    [directory]
  end

  defp maybe_add_current_directory(_directory, _max_dir_size), do: []
end
