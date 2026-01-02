# TinySegmenter

An Elixir port of TinySegmenter, an extremely compact Japanese tokenizer.

TinySegmenter is a compact Japanese word segmentation/tokenization library that was originally written in JavaScript by Taku Kudo in 2008. This is a faithful port to Elixir that maintains compatibility with the original implementation.

## Features

- **Compact**: Extremely small footprint with pre-trained weights compiled into the module
- **Fast**: Uses efficient Elixir data structures and pattern matching
- **Accurate**: Machine learning-based segmentation with pre-trained models
- **No Dependencies**: Pure Elixir implementation with no external dependencies

## Installation

Add `tinysegmenter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tinysegmenter, "~> 0.1.0"}
  ]
end
```

## Usage

### Basic Tokenization

```elixir
# Tokenize Japanese text into a list of words
TinySegmenter.tokenize("私の名前は中野です")
# => ["私", "の", "名前", "は", "中野", "です"]

# Get tokens as a delimited string
TinySegmenter.segment("私の名前は中野です")
# => "私 | の | 名前 | は | 中野 | です"

# Use a custom delimiter
TinySegmenter.segment("私の名前は中野です", " / ")
# => "私 / の / 名前 / は / 中野 / です"
```

### Character Type Classification

```elixir
TinySegmenter.ctype("あ")  # => "I" (Hiragana)
TinySegmenter.ctype("ア")  # => "K" (Katakana)
TinySegmenter.ctype("日")  # => "H" (Kanji)
TinySegmenter.ctype("A")   # => "A" (Alphabet)
TinySegmenter.ctype("1")   # => "N" (Number)
TinySegmenter.ctype("@")   # => "O" (Other)
```

## Examples

```elixir
# Mixed Japanese text
TinySegmenter.tokenize("今日はいい天気ですね")
# => ["今日", "は", "いい", "天気", "です", "ね"]

# Text with numbers and dates
TinySegmenter.tokenize("2023年1月1日")
# => ["2", "0", "2", "3", "年", "1月", "1", "日"]

# Location names
TinySegmenter.tokenize("東京都")
# => ["東京都"]

# Technical terms in Katakana
TinySegmenter.tokenize("コンピュータ")
# => ["コンピュータ"]
```

## API

### `tokenize(text)`

Tokenizes Japanese text into a list of words.

- **Parameters**: `text` - A Japanese text string to be tokenized
- **Returns**: A list of strings, where each string is a token (word)

### `segment(text, delimiter \\ " | ")`

Convenience function that returns a list of tokens separated by a delimiter.

- **Parameters**:
  - `text` - A Japanese text string to be tokenized
  - `delimiter` - The string to use between tokens (default: `" | "`)
- **Returns**: A string with tokens joined by the delimiter

### `ctype(char)`

Returns the character type for a given character.

- **Parameters**: `char` - A single character string
- **Returns**: A string representing the character type:
  - `"H"` - Kanji (漢字)
  - `"I"` - Hiragana (ひらがな)
  - `"K"` - Katakana (カタカナ)
  - `"A"` - Alphabet
  - `"N"` - Number
  - `"M"` - Numeric Kanji (一、二、三、etc.)
  - `"O"` - Other

## How It Works

TinySegmenter uses a machine learning-based approach to segment Japanese text. It:

1. Classifies each character into types (Kanji, Hiragana, Katakana, etc.)
2. Uses pre-trained scoring weights to evaluate potential word boundaries
3. Applies unigram, bigram, and trigram features for accurate segmentation
4. Makes boundary decisions based on cumulative scores

The scoring weights were trained on a Japanese corpus and are embedded directly into the module at compile time for maximum performance.

## Credits

### Original Implementation
- **Original Author**: Taku Kudo (taku@chasen.org)
- **Original JavaScript Version**: (c) 2008 under New BSD License
- **Original URL**: http://chasen.org/~taku/software/TinySegmenter/

### Python Port
- **Author**: Masato Hagiwara
- **URL**: http://lilyx.net/pages/tinysegmenterp.html

### Elixir Port
- **Author**: Simon Edwardsson
- Ported from the Python implementation
- Maintains compatibility with the original algorithm

## License

TinySegmenter is freely distributable under the terms of the New BSD License, following the original implementation by Taku Kudo.

## References

- [TinySegmenter Official Page](https://tinysegmenter.tuxfamily.org/)
- [Original JavaScript Implementation](http://chasen.org/~taku/software/TinySegmenter/)
