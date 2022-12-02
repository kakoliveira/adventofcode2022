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
end
