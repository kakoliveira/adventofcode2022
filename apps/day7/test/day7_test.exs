defmodule Day7Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "$ cd /",
        "$ ls",
        "dir a",
        "14848514 b.txt",
        "8504156 c.dat",
        "dir d",
        "$ cd a",
        "$ ls",
        "dir e",
        "29116 f",
        "2557 g",
        "62596 h.lst",
        "$ cd e",
        "$ ls",
        "584 i",
        "$ cd ..",
        "$ cd ..",
        "$ cd d",
        "$ ls",
        "4060174 j",
        "8033020 d.log",
        "5626152 d.ext",
        "7214296 k"
      ]

      assert 95437 == Day7.solve(input, max_dir_size: 100_000)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1_428_881 == Day7.solve(file_path, max_dir_size: 100_000)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "$ cd /",
        "$ ls",
        "dir a",
        "14848514 b.txt",
        "8504156 c.dat",
        "dir d",
        "$ cd a",
        "$ ls",
        "dir e",
        "29116 f",
        "2557 g",
        "62596 h.lst",
        "$ cd e",
        "$ ls",
        "584 i",
        "$ cd ..",
        "$ cd ..",
        "$ cd d",
        "$ ls",
        "4060174 j",
        "8033020 d.log",
        "5626152 d.ext",
        "7214296 k"
      ]

      assert 24_933_642 ==
               Day7.solve(input, disk_space: 70_000_000, min_needed_free_space: 30_000_000)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 10_475_598 ==
               Day7.solve(file_path, disk_space: 70_000_000, min_needed_free_space: 30_000_000)
    end
  end
end
