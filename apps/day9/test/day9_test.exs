defmodule Day9Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "R 4",
        "U 4",
        "L 3",
        "D 1",
        "R 4",
        "D 1",
        "L 5",
        "R 2"
      ]

      assert 13 == Day9.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 6498 == Day9.solve(file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "R 5",
        "U 8",
        "L 8",
        "D 3",
        "R 17",
        "D 10",
        "L 25",
        "U 20"
      ]

      assert 36 == Day9.solve(input, knots: 10)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 6498 == Day9.solve(file_path, knots: 10)
    end
  end
end
