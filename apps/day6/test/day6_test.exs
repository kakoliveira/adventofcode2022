defmodule Day6Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = ["mjqjpqmgbljsphdztnvjfqwrcgsmlb"]

      assert 7 == Day6.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1802 == Day6.solve(file_path)
    end
  end
end
