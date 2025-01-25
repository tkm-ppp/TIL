## 前提条件
render, amazonS3で本番環境に画像保存機能を実装する。

## 関連資料の収集
- [AWSのS3で本番環境の画像を保存する②Rails、renderでの設定](https://qiita.com/joinus_ibuki/items/774a79e9c828ecdc57b3)
- [Active Storage の概要](https://railsguides.jp/active_storage_overview.html)
- [AWSのS3で本番環境の画像を保存する①AWSの設定](https://qiita.com/joinus_ibuki/items/050816c83234837167bc)
※記事が古い？

### IAMユーザーの作成
[IAMユーザーでAmazon S3にアクセスするために必要な設定](https://www.jpcyber.com/support/create-iam-user-and-iam-policy)

### Active Storageによるデプロイ

[RailsActive Storageの画像をAWS S3へ保存する](https://qiita.com/libra_lt/items/284b2723eaae26c5a39b)


- [AWSのS3で本番環境でも画像を保存できるようにしよう。【vol1】](https://qiita.com/iijima-naoya-45b/items/0bdf75bde960787c9c04)

## 手順のまとめ
- amazonS3の登録・設定
  - IAMユーザーの作成 
  - amazonS3のバケットの作成
  - バケットポリシーの作成
- config/environments/production.rb
- config/storage.ymlの編集
- gem "aws-sdk-s3"の追加

## 手順の具体
### バケットポリシーの作成
#### 概要
バケットポリシーとは、Amazon S3バケットに適用されるアクセス制御ポリシーで、バケットへのアクセスを細かく制御し特定のユーザーやグループ、または一般のインターネットユーザーへの権限を設定することができます。

#### 手順
- AWS Policy Generatorによりポリシーを作成する
- [ポリシージェネレーター](https://awspolicygen.s3.amazonaws.com/policygen.html)
- [AWS のポリシーを楽に作成する方法（ポリシージェネレーター）](https://qiita.com/libra_lt/items/284b2723eaae26c5a39b) 

## 結果
## 課題
## 今後の対応
