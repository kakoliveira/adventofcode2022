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

  describe "solve part 2" do
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

      assert "MCD" == Day5.solve(input, bulk_move: true)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert "VHJDDCWRD" == Day5.solve(file_path, bulk_move: true)
    end
  end
end
