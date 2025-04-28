# CSVとはどういうものか？
- **CSV（シーエスブイ）には、次のような意味があります。**
  - コマ区切り（Comma-Separated Values）の略で、データをカンマで区切ったテキストファイルの形式

- **【CSV（Comma-Separated Values）ファイルについて】**
  - 表形式のデータを扱うソフトウェアやデータベース管理システムとの互換性が高い
  - データのサイズが小さく、読み書きの処理が簡素化される
  - Excel、Googleスプレッドシート、メモ帳などのソフトで作成・閲覧・編集できる
  - 基幹システムやデータベースへのファイルのアップロードやダウンロードに利用される
  - Excelファイルを扱えるか不明な相手にデータを送信する際に利用される


# なぜ使うか？
- データベースに入れやすいから

# 経緯
制作しているアプリでは画像の読み込みにあるAPIを使っていたが無料期間が終わった後予想外の請求が来た。そのAPIを使わないようにしようと考えている。

# 目的
美術館の名前と画像リンクを集めているCSVから、予想外の請求が来たAPIから取ってきた部分を消したい。

# 方法（方針を具体化）
## １⃣スクリプトを組んでCSVの一部を消す
- 生成AIに以下のプロンプトを投げる
```
CSVの一部
上記はCSVの一部です。
railsのアプリを作成しています。
googoleAPIのリンクは空白にするスクリプトを組んでください
それ以外のAPIから取ってきた箇所はそのままにしてください
結果は別のCSVとしてdbフォルダに保存してください
```

**結果**
```
require 'csv'

# 入力CSVファイルのパス
input_file = 'db/wiki_google_photo_adding.csv' # ここに実際のファイルパスを入力してください
# 出力CSVファイルのパス
output_file = 'db/museums.csv'

# CSVファイルの読み込みと書き込み
CSV.open(output_file, 'wb') do |csv_out|
  CSV.foreach(input_file, headers: true) do |row|
    # 新しい行を作成
    new_row = {}
    row.each do |header, value|
      if header == 'photo_url'
        # Google Maps APIのURLかどうかを判定し、該当する場合は空白にする
        if value && value.include?('maps.googleapis.com/maps/api/place/photo')
          new_row[header] = ''
        else
          new_row[header] = value
        end
      else
        new_row[header] = value
      end
    end
    # ヘッダー行を最初に書き込む
    if $. == 2
      csv_out << new_row.keys
    end
    # 新しい行をCSVに書き込む
    csv_out << new_row.values
  end
end

puts "処理が完了しました。結果は#{output_file}に保存されました。"
```

### 解説
このRubyスクリプトは、CSVファイルを読み込み、特定の条件に基づいてデータをフィルタリングし、新しいCSVファイルに書き込むものです。以下に、各部分を詳細に解説します。

### 1.必要なライブラリの読み込み
`require 'csv'`
csvライブラリは、CSVファイルの読み書きを行うための標準ライブラリです。このコードでは、CSVファイルを操作するためにこのライブラリを使用します。
### 2. 入力ファイルと出力ファイルのパス設定
```
input_file = 'db/wiki_google_photo_adding.csv' # ここに実際のファイルパスを入力してください
output_file = 'db/museums.csv'
```
input_fileには、読み込む元のCSVファイルのパスを指定します。
output_fileには、処理結果を書き込む新しいCSVファイルのパスを指定します。
### 3. CSVファイルの読み込みと書き込み
```
CSV.open(output_file, 'wb') do |csv_out|
```
CSV.openメソッドを使用して、出力ファイルを開きます。モードは'wb'（バイナリ書き込み）で、書き込み用のCSVオブジェクトcsv_outを作成します。
### 4. 入力CSVファイルの処理
```
CSV.foreach(input_file, headers: true) do |row|
```
CSV.foreachメソッドを使って、指定したinput_fileを行ごとに読み込みます。headers: trueを指定することで、最初の行をヘッダーとして扱い、各行をハッシュとして取得します。
### 5. 新しい行の作成
```
new_row = {}
```
各行のデータを格納するための空のハッシュnew_rowを作成します。
### 6. 各セルの処理
```
row.each do |header, value|
```
各行のヘッダーと値を取得するために、eachメソッドを使用します。
### 7. Google Maps APIのURL判定とフィルタリング
```
if header == 'photo_url'
  if value && value.include?('maps.googleapis.com/maps/api/place/photo')
    new_row[header] = ''
  else
    new_row[header] = value
  end
```
条件分岐:
headerが'photo_url'の場合、valueが存在し、かつその値がGoogle Maps APIのURL（maps.googleapis.com/maps/api/place/photoを含む）であるかを判定します。
該当する場合は、new_rowのphoto_urlを空文字列に設定します（つまり、このURLを除外します）。
該当しない場合は、元のvalueをそのままnew_rowに設定します。
### 8. ヘッダー行の書き込み
```
if $. == 2
  csv_out << new_row.keys
end
```
$.は現在の行数を示す特殊変数です。$. == 2という条件を使って、最初の行（ヘッダー行）を出力するようにしています。
new_row.keysを使って、ヘッダー行を出力します。この部分は実際にはヘッダー行を一度だけ書き込むためのものです。
### 9. 新しい行の書き込み
```
csv_out << new_row.values
```
new_rowの値を新しいCSVファイルに書き込みます。これにより、フィルタリングされたデータが出力ファイルに追加されます。
### 10. 処理完了のメッセージ
```
puts "処理が完了しました。結果は#{output_file}に保存されました。"
```
処理が完了したことを示すメッセージをコンソールに表示します。ここで、出力ファイルのパスも表示されます。
### まとめ
このスクリプトは、指定された入力CSVファイルからデータを読み込み、Google Maps APIの写真URLを除外した新しいCSVファイルを作成します。これにより、特定の条件に基づいてデータをフィルタリングすることができます。各部分の機能を理解することで、CSV操作の基礎を学ぶことができます。何か他に質問があればお知らせください。