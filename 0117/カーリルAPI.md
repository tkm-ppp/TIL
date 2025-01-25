# カーリルAPIについて

カーリルAPIは、日本全国の図書館の蔵書情報を取得するためのAPIです。これを使用することで、特定の図書館に所蔵されている本の情報を簡単に取得することができます。

## カーリルAPIの特徴
- 日本全国の図書館の蔵書情報を取得可能
  - 図書館に対して蔵書の有無と貸出状況を問い合わせます。
- 図書館データベース
  - 図書館の一覧を取得します。緯度経度を指定した場合は、その地点から近い図書館を順に出力します
- RESTfulなAPI設計
- JSON形式でデータを取得
- 利用料無料

## Rubyでの実装例(蔵書検索）

以下は、Rubyを使用してカーリルAPIを呼び出し、特定の図書館の蔵書情報を取得する例です。

```ruby
require 'net/http'
require 'json'

# カーリルAPIのエンドポイントとAPIキー
endpoint = 'https://api.calil.jp/check'
api_key = 'YOUR_API_KEY'

# リクエストパラメータ
params = {
    appkey: api_key,
    isbn: '9784048689820', # 例: 書籍のISBNコード
    systemid: 'Tokyo_NDL'  # 例: 図書館のシステムID
}

# URIの作成
uri = URI(endpoint)
uri.query = URI.encode_www_form(params)

# HTTPリクエストの送信
response = Net::HTTP.get(uri)

# JSONレスポンスの解析
result = JSON.parse(response)

# 結果の表示
puts result
```

このスクリプトでは、Net::HTTPライブラリを使用してカーリルAPIにリクエストを送り、JSON形式のレスポンスを解析して表示しています。`YOUR_API_KEY`の部分には、カーリルAPIのAPIキーを入力してください。

# 結果の例
```
callback({
  "session": "11a285036112525afe32b1a3d4c36245", 
  "books": {
    "4334926940": {
      "Tokyo_Setagaya": {"status": "OK", "reserveurl": "http://libweb.tokyo.jp/123", 
        "libkey": {"玉川台": "貸出可", "世田谷": "貸出中", "経堂": "館内のみ"}}
    }, 
    "4088700104": {
      "Tokyo_Setagaya": {"status": "Running", "reserveurl": "", 
        "libkey": {}}
    }
  }, 
  "continue": 1
});
```
貸出状況は、以下の8つに分類されます。

貸出可、 蔵書あり、 館内のみ、 貸出中、 予約中、 準備中、 休館中、 蔵書なし

## カーリルへのリンク
- APIを使って取得された図書館名または「蔵書あり」「貸出可」などの貸出状況を表示するときは、かならずカーリルのページに対してリンクを貼る必要がある
  - 個別の本ページへのリンク：https://calil.jp/book/{ISBN10}
  - 図書館ページへのリンク：https://calil.jp/library/{libid}/{図書館の正式名称}
  - 図書館ページへのリンク2（libkeyとシステムIDから飛ぶ場合）：
https://calil.jp/library/search?s={システムID}&k={図書館のLibkey}

## 利用制限
- 以下のような呼び出し回数の制限がある。
### https://api.calil.jp/check
- IP毎に、1000書籍リクエスト/時
  - 1IP=ほぼ1ユーザー
  - 「1書籍リクエスト」は、１つのISBNを１つの図書館システムに問い合わせるのに発生するリクエスト
### https://api.calil.jp/library
- 各アプリケーションキーにつき、IP毎に、1000リクエスト/時

## 参考リンク
- [カーリルAPI公式ドキュメント](https://calil.jp/doc/api.html)
- [カーリル](https://calil.jp)