defmodule Day1Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        1000,
        2000,
        3000,
        nil,
        4000,
        nil,
        5000,
        6000,
        nil,
        7000,
        8000,
        9000,
        nil,
        10_000
      ]

      assert 24_000 == Day1.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 70_613 == Day1.solve(file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        1000,
        2000,
        3000,
        nil,
        4000,
        nil,
        5000,
        6000,
        nil,
        7000,
        8000,
        9000,
        nil,
        10_000
      ]

      assert 45_000 == Day1.solve(input, elfs_to_sum: 3)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 205_805 == Day1.solve(file_path, elfs_to_sum: 3)
    end
  end
end
