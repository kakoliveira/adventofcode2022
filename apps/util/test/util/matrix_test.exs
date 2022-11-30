defmodule Util.MatrixTest do
  use ExUnit.Case, async: true

  alias Util.Matrix

  describe "parse_matrix/2" do
    test "default behaviour" do
      input = ["12", "21", "33"]

      matrix = Matrix.parse_matrix(input)

      assert [["1", "2"], ["2", "1"], ["3", "3"]] = matrix
    end

    test "delimiter matrix" do
      input = ["1,2", "2,1", "3,3"]

      matrix = Matrix.parse_matrix(input, delimiter: ",")

      assert [["1", "2"], ["2", "1"], ["3", "3"]] = matrix
    end

    test "integer matrix" do
      input = ["12", "21", "33"]

      matrix = Matrix.parse_matrix(input, to_integer: true)

      assert [[1, 2], [2, 1], [3, 3]] = matrix
    end
  end

  describe "column_size/1" do
    test "gets matrix column size" do
      matrix = [
        [1, 2, 3],
        [1, 2, 3]
      ]

      assert Matrix.column_size(matrix) == 3
    end
  end

  describe "fetch_column/2" do
    test "gets matrix column" do
      matrix = [
        [1, 2, 3],
        [1, 2, 3]
      ]

      assert Matrix.fetch_column(matrix, 1) == [2, 2]
    end
  end

  describe "get_point/3" do
    test "gets full point info" do
      matrix = [
        ["1", "2"],
        ["3", "4"]
      ]

      assert {"4", 1, 1} = Matrix.get_point(matrix, 1, 1)
    end
  end

  describe "set/4" do
    test "updates a point on a matrix" do
      matrix = [
        ["1", "2"],
        ["3", "4"]
      ]

      updated_matrix = Matrix.set(matrix, 1, 1, "0")

      assert [
               ["1", "2"],
               ["3", "0"]
             ] = updated_matrix
    end
  end

  describe "describe/1" do
    test "gets matrix form info" do
      matrix = [
        ["1", "2"],
        ["3", "4"]
      ]

      assert {^matrix, 2, 2} = Matrix.describe(matrix)
    end
  end
end
