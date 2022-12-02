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
        10000
      ]

      assert 24000 == Day1.solve(part: 1, calories: input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 70613 == Day1.solve(part: 1, file_path: file_path)
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
        10000
      ]

      assert 45000 == Day1.solve(part: 2, calories: input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 205_805 == Day1.solve(part: 2, file_path: file_path)
    end
  end
end
