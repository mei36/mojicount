#!/bin/bash
# SPDX-FileCopyrightText: 2026 Meina Fukazawa
# SPDX-License-Identifier: BSD-3-Clause

# どこから実行しても、このファイルがあるフォルダーで動かす
cd "$(dirname "$0")" || exit 1

res=0

# check 名前 入力 空白を除く文字数 総文字数 行数 原稿用紙の枚数
check () {
    expected=$(printf '文字数（空白を除く）: %s\n総文字数（改行を除く）: %s\n行数: %s\n原稿用紙（400字詰め）: %s 枚' "$3" "$4" "$5" "$6")
    out=$(printf '%s' "$2" | ./mojicount)
    status=$?

    if [ "$status" -ne 0 ]; then
        echo "NG: $1 （終了ステータスが $status）"
        res=1
    elif [ "$out" != "$expected" ]; then
        echo "NG: $1"
        echo "  期待: $expected"
        echo "  結果: $out"
        res=1
    else
        echo "OK: $1"
    fi
}

check "ふつうの文章"         $'こんにちは\n'        5 5 1 1
check "半角スペース"         $'こん にちは\n'       5 6 1 1
check "全角スペース"         $'あ\u3000い\n'        2 3 1 1
check "最後に改行がない"     'あい'                 2 2 1 1
check "複数行"               $'あ\nい\nう\n'        3 3 3 1
check "空の入力"             ''                     0 0 0 0
check "Windowsの改行(CRLF)"  $'あい\r\n'            2 2 1 1
check "英数字も数える"       $'abc 123\n'           6 7 1 1
check "400字は1枚"           "$(printf 'あ%.0s' $(seq 400))"  400 400 1 1
check "401字は2枚"           "$(printf 'あ%.0s' $(seq 401))"  401 401 1 2

exit $res
