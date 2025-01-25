# RubyでCSV出力！

## CSVとは？
CSVはComma Separated Valueの略で、その名の通り、項目をカンマで区切ったファイルです。データが複数ある場合は、改行して複数行に渡って記述します。

以下は、実際のCSVのサンプルです。
```
id, name, age
1, 山田, 20
10001, 鈴木, 30
3, 伊藤, 40
```
このように、CSVは表形式のデータを扱うことができ、項目（列）をカンマ区切り、レコード（行）を改行で区切ったシンプルなデータ形式のファイルです。

## RubyでCSVファイルを出力するには？
Rubyには、標準で「csvライブラリ」が用意されており、簡単なコードでCSVの入出力ができるようになっています。

CSV出力時に、csvライブラリのopenメソッドを使用し、引数にファイルの出力先と、出力モードを指定します。

そしてopenメソッドで作成したCSV オブジェクトに対し、出力するデータを書き込みます。

```
require "csv"
CSV.open('Sample.csv','w') do |csv|
  csv << ["id","name","age"]        ##ヘッダ
  csv << ["1","山田","20"]           ##データ１行目
  csv << ["10001","鈴木","30"]       ##データ１行目
 end
```

実行すると、次のようなCSVファイルが出力されます。
```
id,name,age
1,山田,20
10001,鈴木,30
```

## 具体的な方法
APIから取得したデータをCSVに保存し、そのCSVからデータを読み込んでビューで表示するためのコードを以下に示します。APIからデータを取得するロジックとCSVに保存するロジックを分け、CSVに保存するロジックとCSVからデータを読み込んでビューで表示するロジックを同じファイルに記述します。
まず、APIからデータを取得するロジックを別ファイルに記述します（例：api_fetcher.rb）:

```
require 'net/http'
require 'libxml'

class ApiFetcher
  def self.fetch_data(base_url, params)
    uri = URI(base_url)
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    doc_parsed = LibXML::XML::Document.string(response)
    
    results = []
    doc_parsed.find('/rss/channel/item').each do |item|
      title = item.find('title').first&.content
      author = item.find('author').first&.content
      results << [title, author]
    end
    
    results
  end
end
```

次に、CSVに保存するロジックとCSVからデータを読み込んでビューで表示するロジックを同じファイルに記述します。
（例：ndl_api.rb）:
```
require 'csv'
require_relative 'api_fetcher'

class Ndl_api
  CSV_DIRECTORY = Rails.root.join('app', 'assets', 'csv')

  def self.save_to_csv(data, filename)
    FileUtils.mkdir_p(CSV_DIRECTORY) unless File.directory?(CSV_DIRECTORY)
    filepath = CSV_DIRECTORY.join(filename)

    CSV.open(filepath, 'w') do |csv|
      csv << ['Title', 'Author']
      data.each do |row|
        csv << row
      end
    end
  end

  def self.read_from_csv(filename)
    filepath = CSV_DIRECTORY.join(filename)
    CSV.read(filepath, headers: true)
  end

  def self.display_data(data)
    data.each do |row|
      puts "Title: #{row['Title']}, Author: #{row['Author']}"
    end
  end
end

# APIからデータを取得
base_url = "https://ndlsearch.ndl.go.jp/api/opensearch"
all_params = ["お疲れ", "地球", "ひいては", "宇宙の皆様"]
all_data = []

all_params.each do |param|
  data = ApiFetcher.fetch_data(base_url, { title: param })
  all_data.concat(data)
end

# CSVにデータを保存
Ndl_api.save_to_csv(all_data, 'search_results.csv')

# CSVからデータを読み込み
csv_data = Ndl_api.read_from_csv('search_results.csv')

# ビューでデータを表示
Ndl_api.display_data(csv_data)
```

### 解説
ライブラリのインポート
```
require 'csv'
require_relative 'api_fetcher'
```
* require 'csv': Rubyの標準ライブラリであるCSVモジュールを読み込みます1。
* require_relative 'api_fetcher': 同じディレクトリにあるapi_fetcher.rbファイルを読み込みます。


ndl_apiクラス
```
  CSV_DIRECTORY = Rails.root.join('app', 'assets', 'csv')
```
* これは定数の定義です。CSVファイルを保存するディレクトリのパスを設定しています。
* Rails.rootはRailsアプリケーションのルートディレクトリを指します。
```
 def self.save_to_csv(data, filename)
    FileUtils.mkdir_p(CSV_DIRECTORY) unless File.directory?(CSV_DIRECTORY)
    filepath = CSV_DIRECTORY.join(filename)
```
* save_to_csvメソッドは、データをCSVファイルに保存します。
* 又、これはクラスメソッドの定義です。data（保存するデータ）とfilename（ファイル名）を引数に取ります。
* CSV_DIRECTORYが存在しない場合、そのディレクトリを作成します。
* `FileUtils.mkdir_p`は、必要に応じて親ディレクトリも含めて作成します。
* `unless`は条件が偽の場合に実行されます。ここでは、ディレクトリが存在しない場合に作成します。
* `filepath = CSV_DIRECTORY.join(filename)`
  
  完全なファイルパスを作成します。CSV_DIRECTORYにfilenameを結合します。
```
CSV.open(filepath, 'w') do |csv|
      csv << ['Title', 'Author']
      data.each do |row|
        csv << row
      end
    end
  end
```
* CSV.open(filename, 'w')で、指定されたファイル名で書き込みモードでCSVファイルを開きます2。
* ヘッダー行として['Title', 'Author']を書き込み、その後各データ行を書き込みます。
```
 def self.read_from_csv(filename)
    filepath = CSV_DIRECTORY.join(filename)
    CSV.read(filepath, headers: true)
  end
```
* read_from_csvメソッドは、CSVファイルからデータを読み込みます。

`filepath = CSV_DIRECTORY.join(filename)`
* 読み込むファイルの完全なパスを作成します。
* headers: trueオプションにより、最初の行をヘッダーとして扱います。
```
  def self.display_data(data)
    data.each do |row|
      puts "Title: #{row['Title']}, Author: #{row['Author']}"
    end
  end
end
```
* display_dataメソッドは、読み込んだデータを表示します。
* 各行のタイトルと著者を整形して出力します。
### メインの処理
```
base_url = "https://ndlsearch.ndl.go.jp/api/opensearch"
all_params = ["お疲れ", "地球", "ひいては", "宇宙の皆様"]
all_data = []

all_params.each do |param|
  data = ApiFetcher.fetch_data(base_url, { title: param })
  all_data.concat(data)
end
```
* APIのベースURLを設定し、検索パラメータの配列を用意します。
* 各パラメータでAPIを呼び出し、結果をall_dataに追加します。
1. `all_params.each do |param|：all_params`
配列の各要素に対してループを実行します13。param変数には、配列の各要素が順番に代入されます。
2. `data = ApiFetcher.fetch_data(base_url, { title: param })：`
* ApiFetcher.fetch_dataメソッドを呼び出し、APIからデータを取得します。
* base_urlは固定のAPIエンドポイントです。
* { title: param }は、現在のループのparamをタイトルパラメータとして使用します。
3. `all_data.concat(data)`
* concatメソッドを使用して、取得したデータ(data)をall_data配列に追加します。
  * [concatメソッドで配列や文字列を結合する方法](https://www.sejuku.net/blog/69942)
* これにより、各APIリクエストの結果がall_data配列に蓄積されていきます。
Ndl_api.save_to_csv(all_data, 'search_results.csv')
取得したデータをCSVファイルに保存します。
```
csv_data = Ndl_api.read_from_csv('search_results.csv')
```
保存したCSVファイルからデータを読み込みます。
```
Ndl_api.display_data(csv_data)
```
読み込んだデータを表示します。

このプログラムは、APIからデータを取得し、CSVファイルを介してデータの保存と読み込みを行い、最終的にデータを表示する一連の流れを示しています。

# 参考資料
* * *
[RubyでCSV出力！エンコーディングの指定方法などを詳しく解説](https://style.potepan.com/articles/27115.html)