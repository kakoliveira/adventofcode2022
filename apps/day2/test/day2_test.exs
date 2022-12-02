defmodule Day2Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "A Y",
        "B X",
        "C Z"
      ]

      assert 15 == Day2.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 13_809 == Day2.solve(file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "A Y",
        "B X",
        "C Z"
      ]

      assert 12 == Day2.solve(input, by_outcomes: true)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 12_316 == Day2.solve(file_path, by_outcomes: true)
    end
  end
end
