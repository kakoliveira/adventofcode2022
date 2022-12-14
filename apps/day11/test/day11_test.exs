defmodule Day11Test do
  use ExUnit.Case, async: true

  describe "solve part 1" do
    test "base case" do
      input = [
        "Monkey 0:",
        "Starting items: 79, 98",
        "Operation: new = old * 19",
        "Test: divisible by 23",
        "If true: throw to monkey 2",
        "If false: throw to monkey 3",
        "Monkey 1:",
        "Starting items: 54, 65, 75, 74",
        "Operation: new = old + 6",
        "Test: divisible by 19",
        "If true: throw to monkey 2",
        "If false: throw to monkey 0",
        "Monkey 2:",
        "Starting items: 79, 60, 97",
        "Operation: new = old * old",
        "Test: divisible by 13",
        "If true: throw to monkey 1",
        "If false: throw to monkey 3",
        "Monkey 3:",
        "Starting items: 74",
        "Operation: new = old + 3",
        "Test: divisible by 17",
        "If true: throw to monkey 0",
        "If false: throw to monkey 1"
      ]

      assert 10605 == Day11.solve(input)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 54253 == Day11.solve(file_path)
    end
  end

  describe "solve part 2" do
    test "base case" do
      input = [
        "Monkey 0:",
        "Starting items: 79, 98",
        "Operation: new = old * 19",
        "Test: divisible by 23",
        "If true: throw to monkey 2",
        "If false: throw to monkey 3",
        "Monkey 1:",
        "Starting items: 54, 65, 75, 74",
        "Operation: new = old + 6",
        "Test: divisible by 19",
        "If true: throw to monkey 2",
        "If false: throw to monkey 0",
        "Monkey 2:",
        "Starting items: 79, 60, 97",
        "Operation: new = old * old",
        "Test: divisible by 13",
        "If true: throw to monkey 1",
        "If false: throw to monkey 3",
        "Monkey 3:",
        "Starting items: 74",
        "Operation: new = old + 3",
        "Test: divisible by 17",
        "If true: throw to monkey 0",
        "If false: throw to monkey 1"
      ]

      assert 2_713_310_158 == Day11.solve(input, relief: false, rounds: 10000)
    end

    test "challenge" do
      file_path = Path.join(File.cwd!(), "input.txt")

      assert 54253 == Day11.solve(file_path, relief: false, rounds: 10000)
    end
  end
end
