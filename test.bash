#!/bin/bash
# SPDX-FileCopyrightText: 2026 Meina Fukazawa
# SPDX-License-Identifier: BSD-3-Clause

cd "$(dirname "$0")" || exit 1

res=0

# check 名前 入力 期待する出力 [オプション ...]
check () {
    name=$1
    input=$2
    expected=$3
    shift 3

    out=$(printf '%s' "$input" | ./mojicount "$@")
    status=$?

    if [ "$status" -ne 0 ]; then
        echo "NG: $name （終了ステータスが $status）"
        res=1
    elif [ "$out" != "$expected" ]; then
        echo "NG: $name （期待: $expected / 結果: $out）"
        res=1
    else
        echo "OK: $name"
    fi
}


check_error () {
    name=$1
    shift

    out=$(printf 'あ\n' | ./mojicount "$@" 2> /dev/null)
    status=$?
    err=$(printf 'あ\n' | ./mojicount "$@" 2>&1 > /dev/null)

    if [ "$status" -eq 2 ] && [ -z "$out" ] && [ -n "$err" ]; then
        echo "OK: $name"
    else
        echo "NG: $name （終了ステータス $status、標準出力「$out」）"
        res=1
    fi
}

# オプションなし: 空白を除く文字数
check "ふつうの文章"             $'こんにちは\n'   5
check "半角スペースは数えない"   $'こん にちは\n'  5
check "全角スペースは数えない"   $'あ\u3000い\n'   2
check "最後に改行がない"         'あい'            2
check "空の入力"                 ''                0
check "Windowsの改行(CRLF)"      $'あい\r\n'       2
check "英数字も数える"           $'abc 123\n'      6
check "タブは数えない"           $'あ\tい\n'       2

# -t: 総文字数（改行を除く）
check "-t 空白を含めて数える"    $'こん にちは\n'  6 -t
check "-t 改行は数えない"        $'あ\nい\n'       2 -t

# -l: 行数
check "-l 複数行"                $'あ\nい\nう\n'   3 -l
check "-l 最後に改行がない"      $'あ\nい'         2 -l
check "-l 空の入力"              ''                0 -l

# -s: 原稿用紙の枚数
check "-s 空の入力は0枚"         ''                                 0 -s
check "-s 400字は1枚"            "$(printf 'あ%.0s' $(seq 400))"    1 -s
check "-s 401字は2枚"            "$(printf 'あ%.0s' $(seq 401))"    2 -s

# 間違った使い方
check_error "不明なオプション"       -x
check_error "オプションの同時指定"   -t -l

exit $res
