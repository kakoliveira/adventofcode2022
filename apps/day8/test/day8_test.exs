defmodule Day8Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "30373",
        "25512",
        "65332",
        "33549",
        "35390"
      ]

      assert 21 == Day8.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 1859 == Day8.solve(file_path)
    end
  end
end
