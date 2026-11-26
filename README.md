# 文字数カウント

[![test](https://github.com/mei36/mojicount/actions/workflows/test.yml/badge.svg)](https://github.com/mei36/mojicount/actions/workflows/test.yml)

日本語の文章の文字数を数えるコマンドです。空白を除いた文字数、行数、400字詰め原稿用紙に換算した枚数が分かります。

レポートや作文の「2000字以内」「原稿用紙5枚」といった条件を、テキストファイルのまま確認するためのコマンドです。

```
$ echo "こんにちは 世界" | ./mojicount
文字数（空白を除く）: 7
総文字数（改行を除く）: 8
行数: 1
原稿用紙（400字詰め）: 1 枚
```

## インストール

```
git clone https://github.com/mei36/mojicount.git
cd mojicount
chmod +x mojicount
```

## 使い方

- 標準入力から文章を読みます。
- 数えた結果を標準出力に表示します。

```
./mojicount < report.txt
cat report.txt | ./mojicount
echo "吾輩は猫である。" | ./mojicount
```

## 出力の見方

| 項目 | 意味 |
| --- | --- |
| 文字数（空白を除く） | 空白（半角スペース、全角スペース、タブ）と改行を除いた文字の数 |
| 総文字数（改行を除く） | 改行以外のすべての文字の数（空白を含む） |
| 行数 | 行の数。最後の行に改行がなくても、1行と数えます |
| 原稿用紙（400字詰め） | 「空白を除く文字数」を400で割って、切り上げた枚数 |


## 注意

- 入力は UTF-8 のテキストを想定しています。
- 原稿用紙の枚数は、単純な換算です。行頭に句読点を置かない決まりなどは、考えていません。
- 1文字は、Unicode の1文字です。漢字、ひらがな、絵文字は、それぞれ1文字です。


## テスト

```
./test.bash
```

GitHub に送るたびに、GitHub Actions が同じテストを自動で実行します。


## 必要なソフトウェア

- Python
  - テスト済みバージョン:3.10～3.14


## テスト環境

- Ubuntu 24.04 LTS


## 著作権とLICENSE
- このソフトウェアパッケージは、3条項BSDライセンスの下、再頒布および使用が許可されます。
- © 2026 Meina Fukazawa
