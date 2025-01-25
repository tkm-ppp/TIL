# requireについて
- 外部ファイルやモジュールを読み込むための関数
- 主にプログラミング言語で使用され、コードの再利用性や保守性を向上させる重要な役割を果たす

# 使い方
1. 外部ファイルの読み込み: `require "ライブラリ名"`
2. 自作コードの読み込み: `require "./パス/ファイル名"`
3. 特定の関数やクラスの読み込み: `const { 関数名, クラス名 } = require('./ファイル名');`

# 実際の例
今回は、以下のようなフォルダ構成でコードを書きましょう。

```
-main.rb
-utils
-hello.rb
-dog.rb
```

hello.rbには、以下の関数を書きます。
```
# utils/hello.rb
def say_hello
    puts "Hello World"
end
```
dog.rbには、クラスを書いてみましょう。
```
# utils/dog.rb
class Dog
    def bark
        puts "wan wan!"
    end
end
```
上の２つをmain.goで呼び出します。以下のように書いて、実行してみてください。

また、dateライブラリも呼び出せるか試してみましょう。
```
# 自分で書いたコードの呼び出し
require './utils/hello'
require './utils/dog'

# 標準ライブラリの呼び出し
require 'date'

# hello.rbからsay_helloを呼び出す
say_hello

# dog.rbからDogクラスのインスタンスを作る
dog = Dog.new
dog.bark

# dateライブラリから今日の日付を出力する
puts Date.today
```
実行結果は以下の通りです。

Hello World

wan wan!

2019-04-22



# 主な特徴
- ファイルを分割して管理できるため、コードの可読性が向上します1
- 標準ライブラリや外部ライブラリを簡単に利用できます
- 依存関係のあるモジュールも自動的に読み込みます3.

# 参考資料
* * *
[Rubyの外部ファイル読み込みとrequireの使い方を現役エンジニアが解説【初心者向け】](https://magazine.techacademy.jp/magazine/21359)