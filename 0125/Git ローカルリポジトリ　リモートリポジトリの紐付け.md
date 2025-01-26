# 紐づけ
## 概要
1. リモートリポジトリ(Github)のリポジトリアドレスのコピー
2. ローカルリポジトリとリモートリポジトリを紐づけ
## 方法詳細
1. リモートリポジトリ(Github)のリポジトリアドレスのコピー
![代替テキスト](https://qiita-user-contents.imgix.net/https%3A%2F%2Fqiita-image-store.s3.ap-northeast-1.amazonaws.com%2F0%2F306417%2F082f23de-e137-a096-b2b7-6c04975e70a9.png?ixlib=rb-4.0.0&auto=format&gif-q=60&q=75&s=bbf7c3dc0b9f6be1974246b54aa40c24)

2.ローカルリポジトリとリモートリポジトリを紐づけ

(1)ターミナルにて`$git init`を実行したディレクトリに移動する。

(2)下記コマンドを実行して紐付けを行う。
```
$ git remote add origin コピーしたリポジトリアドレス
```

(3)紐づいているリモートリポジトリアドレスを確認する
```
$ git remote -v
```
>origin  コピーしたリポジトリアドレス (fetch)

>origin  コピーしたリポジトリアドレス (push)

# 紐づけ解除
## 方法
1 リポジトリ内部で下記コマンドを実行して現在のリモートリポジトリアドレスを表示する。
```
git remote -v
```
2 前のコマンドの出力に記載されているリモートブランチ名をコピーする。(デフォルトだとorigin)

3 ローカルリポジトリとリモートリポジトリの紐付けを解除する。
```
$ git remote remove リモートリポジトリ名(デフォルトだとorigin)

まずは
git remote remove origin
```
4 リモートリポジトリのリンクアドレスが表示されなければ紐付けの解除は成功している。
```
$ git remote -v
```

[Github ローカルリポジトリをリモートリポジトリと紐づける](https://qiita.com/miriwo/items/a7be71f6a238b09eda10)

[Git ローカルリポジトリをリモートリポジトリの紐付けを解除する](https://qiita.com/miriwo/items/4fdb5c9371693b70e123)