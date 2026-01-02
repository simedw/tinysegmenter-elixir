defmodule TinySegmenterTest do
  use ExUnit.Case
  doctest TinySegmenter

  describe "tokenize/1" do
    test "tokenizes simple Japanese sentence" do
      assert TinySegmenter.tokenize("私の名前は中野です") == ["私", "の", "名前", "は", "中野", "です"]
    end

    test "tokenizes text with hiragana" do
      result = TinySegmenter.tokenize("これはペンです")
      assert is_list(result)
      refute Enum.empty?(result)
    end

    test "tokenizes text with katakana" do
      result = TinySegmenter.tokenize("コンピュータ")
      assert is_list(result)
      assert Enum.join(result, "") == "コンピュータ"
    end

    test "tokenizes text with kanji" do
      result = TinySegmenter.tokenize("日本語")
      assert is_list(result)
      assert Enum.join(result, "") == "日本語"
    end

    test "tokenizes mixed Japanese text" do
      result = TinySegmenter.tokenize("今日はいい天気ですね")
      assert is_list(result)
      assert length(result) > 3
    end

    test "handles empty string" do
      assert TinySegmenter.tokenize("") == []
    end

    test "handles nil" do
      assert TinySegmenter.tokenize(nil) == []
    end

    test "tokenizes text with numbers" do
      result = TinySegmenter.tokenize("2023年1月1日")
      assert is_list(result)
      # Numbers may be split into individual digits by the original algorithm
      assert Enum.join(result, "") == "2023年1月1日"
    end

    test "tokenizes text with punctuation" do
      result = TinySegmenter.tokenize("こんにちは、元気ですか。")
      assert is_list(result)
      assert Enum.any?(result, &(&1 == "、" or &1 == "。"))
    end

    test "tokenizes longer text" do
      text = "本日は晴天なり。明日も晴れるでしょう。"
      result = TinySegmenter.tokenize(text)
      assert is_list(result)
      assert length(result) > 5
      # Verify all tokens join back to original text
      assert Enum.join(result, "") == text
    end
  end

  describe "segment/2" do
    test "returns tokens joined by default delimiter" do
      result = TinySegmenter.segment("私の名前は中野です")
      assert is_binary(result)
      assert String.contains?(result, " | ")
    end

    test "returns tokens joined by custom delimiter" do
      result = TinySegmenter.segment("私の名前は中野です", " / ")
      assert is_binary(result)
      assert String.contains?(result, " / ")
    end

    test "handles empty string with segment" do
      assert TinySegmenter.segment("") == ""
    end
  end

  describe "ctype/1" do
    test "identifies hiragana characters" do
      assert TinySegmenter.ctype("あ") == "I"
      assert TinySegmenter.ctype("ん") == "I"
    end

    test "identifies katakana characters" do
      assert TinySegmenter.ctype("ア") == "K"
      assert TinySegmenter.ctype("ン") == "K"
    end

    test "identifies kanji characters" do
      assert TinySegmenter.ctype("日") == "H"
      assert TinySegmenter.ctype("本") == "H"
    end

    test "identifies alphabet characters" do
      assert TinySegmenter.ctype("a") == "A"
      assert TinySegmenter.ctype("Z") == "A"
    end

    test "identifies number characters" do
      assert TinySegmenter.ctype("0") == "N"
      assert TinySegmenter.ctype("9") == "N"
    end

    test "returns 'O' for other characters" do
      assert TinySegmenter.ctype("@") == "O"
      assert TinySegmenter.ctype("!") == "O"
    end
  end

  describe "compatibility with original Python implementation" do
    # These test cases are verified against the original Python TinySegmenter v0.4
    # by Masato Hagiwara (ported from Taku Kudo's JavaScript original)
    test "matches Python TinySegmenter output" do
      test_cases = [
        {"私の名前は中野です", ["私", "の", "名前", "は", "中野", "です"]},
        {"東京都", ["東京都"]},
        {"これはテストです", ["これ", "は", "テスト", "です"]},
        {"今日はいい天気ですね", ["今日", "は", "いい", "天気", "です", "ね"]},
        {"2023年1月1日", ["2", "0", "2", "3", "年", "1月", "1", "日"]},
        {"食べるのことは良い", ["食べる", "の", "こと", "は", "良い"]},
        {"コンピュータサイエンス", ["コンピュータサイエンス"]},
        {"日本語の文章を分割します", ["日本語", "の", "文章", "を", "分割", "し", "ます"]},
        {"私は学生です。あなたは先生ですか？", ["私", "は", "学生", "です", "。", "あなた", "は", "先生", "です", "か", "？"]}
      ]

      Enum.each(test_cases, fn {input, expected} ->
        result = TinySegmenter.tokenize(input)

        assert result == expected,
               "Failed for input: #{input}\nExpected: #{inspect(expected)}\nGot: #{inspect(result)}"
      end)
    end
  end
end
