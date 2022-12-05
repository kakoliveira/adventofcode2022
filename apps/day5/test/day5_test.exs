defmodule Day5Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "    [D]    ",
        "[N] [C]    ",
        "[Z] [M] [P]",
        " 1   2   3 ",
        "move 1 from 2 to 1",
        "move 3 from 1 to 3",
        "move 2 from 2 to 1",
        "move 1 from 1 to 2"
      ]

      assert "CMZ" == Day5.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert "JDTMRWCQJ" == Day5.solve(file_path)
    end
  end
end
