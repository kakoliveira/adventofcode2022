defmodule FileReaderTest do
  use ExUnit.Case, async: true

  doctest FileReader

  describe "read/1" do
    test "with invalid file" do
      assert_raise File.Error, fn ->
        FileReader.read("invalid")
      end
    end

    test "with valid file" do
      file_path =
        File.cwd!()
        |> Path.join("test")
        |> Path.join("support")
        |> Path.join("test_input")

      assert ["This", "Is a", "Test"] = FileReader.read(file_path)
    end
  end

  describe "clean_content/1" do
    test "cleans irrelevant chars" do
      input = ["valid", nil, "", "valid", "\n", " "]

      expected_output = ["valid", "valid", " "]

      assert expected_output == FileReader.clean_content(input)
    end
  end
end
