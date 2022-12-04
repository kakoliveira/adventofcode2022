defmodule Day4Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "2-4,6-8",
        "2-3,4-5",
        "5-7,7-9",
        "2-8,3-7",
        "6-6,4-6",
        "2-6,4-8"
      ]

      assert 2 == Day4.solve(input, full_overlap: true)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 538 == Day4.solve(file_path, full_overlap: true)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "2-4,6-8",
        "2-3,4-5",
        "5-7,7-9",
        "2-8,3-7",
        "6-6,4-6",
        "2-6,4-8"
      ]

      assert 4 == Day4.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 792 == Day4.solve(file_path)
    end
  end
end
