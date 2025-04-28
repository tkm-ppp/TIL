# 経緯（過去）
卒制の

# 目的
市町村ごとに図書館をまとめて表示することで選択しやすくなるが、現状ではcityカラムが入っていないのでまずはカラムを作成したい。

# 方針
データベースに各市町村のデータを保存

# 方法（方針を具体化）
- rakeタスクを動かしてアドレスカラムからシティカラムに市町村のデータを保存

### 1️⃣データベースに各都道府県ごとのデータを入れる
- データがすべて入ったことを確認済み

### 2️⃣rakeタスクを使用し、addressカラムからcityカラムにデータを格納する。
1．update_cities.rakeにrakeタスクを作成

2. 大阪府のみでrakeタスクが実行する
- できたことを確認

3. 全都道府県でrakeタスクを実行する



# 現状の結果
## rakeタスクが実行できていないことを確認
### ① タスクファイルの配置不備
- lib/tasksディレクトリにタスクファイルを入れている為、問題なし。

### ② タスクファイルの名前の不一致
- タスク名とファイル名が一致している為、問題なし。

### ③ タスクが使える状態か確認する。
- rake --tasksを実行したが表示されていない

### ④タスクの進捗を確認するコマンドを付ける

`rake libraries:update_cities --trace`

結果
```
4076668506e2:/app# rake libraries:update_cities --trace
** Invoke libraries:update_cities (first_time)
** Invoke environment (first_time)
** Execute environment
** Execute libraries:update_cities
```
動いてはいそう。

### ⑤ターミナルでログを出力するようにする。

### ⑥パッチ処理でメモリの使用量を減らす
- 160件ほどで止まる

### ⑦各都道府県ごとに実行（奈良県）
10や40件ほどで止まる

### ⑧正確に各都道府県のcityカラムに入っている数を確認する。
```
app(dev)> Library.where("address LIKE ? AND city IS NOT NULL AND city != ?", "%青森県%", "").count
  Library Count (2.4ms)  SELECT COUNT(*) FROM "libraries" WHERE (address LIKE $1 AND city IS NOT NULL AND city != $2)  [[nil, "%青森県%"], [nil, ""]]
=> 75
```

### ⑨入った数をスキップしてその次の図書館からcityカラムにデータを入れる
- 広島は3箇所残っている

### ⑩Addressカラムに読み込めないものがあったため、rakeタスクが実行できない図書館が合った。この問題を修正した。

読み込めないAddressカラムの例
```
・Could not extract city for library ID 3105 with address: 福島県福島県会津若松市城東町2-3
・Could not extract city for library ID 4510 with address: 東京都八丈島八丈町三根26番地6
```
修正方法 

例1
```
library = Library.find(4510)  # IDが4510の図書館を取得
library.update(city: "八丈町")  # cityカラムを「八丈町」に更新
```
例2
```
library = Library.find(5232)  # IDが5232の図書館を取得
new_address = library.address.gsub("神奈川県神奈川県", "神奈川県")  # 重複を削除
library.update(address: new_address)  # addressカラムを更新
library.reload  # 最新のデータを取得
```
### ⑪全都道府県のライブラリの中で、cityカラムが空でないものの数をカウントする。
```
# カウント方法
total_libraries_with_city_count = Library.where.not(city: [nil, ""]).count
# 結果
Total number of libraries with a city: 7470
```
全国の図書館数7473件の為、残り3件

### ⑫rakeタスクが実行できなかった図書館をrails consolesでcityカラムに入れていく


残図書館
```
   id: 7747,
  formal: "熊野町立移動�{��{�館「こぐま号」",
  url_pc: "http://www.town.kumano.hiroshima.jp/www/library/",
  created_at: "2025-03-06 12:05:16.317969000 +0000",
  updated_at: "2025-03-06 12:05:16.317969000 +0000",
  address: "広島県安芸郡熊野町中溝一丁�{�17-1",
  tel: "082-855-6710",
  systemid: nil,
  city: nil>,
 #<Library:0x00007f22891071d0

  id: 7748,
  formal: "熊野町�{��{�館",
  url_pc: "https://www.kumano.library.ne.jp/",
  created_at: "2025-03-06 12:05:16.320838000 +0000",
  updated_at: "2025-03-06 12:05:16.320838000 +0000",
  address: "広島県安芸郡熊野町中溝一丁�{�17-1",
  tel: "082-855-6710",
  post: "731-4214",
  geocode: "132.5862009,34.3351253",
  libkey: "熊野町�{��{�館",
  libid: "101093",
  systemid: nil,
  city: nil>,
 #<Library:0x00007f2289107090

  id: 7749,
  formal: "呉市中央�{��{�館",
  url_pc: "https://www.city.kure.lg.jp/site/library/",
  created_at: "2025-03-06 12:05:16.324069000 +0000",
  updated_at: "2025-03-06 12:05:16.324069000 +0000",
  address: "広島県呉市中央3丁�{�10番3号",
  tel: "0823-21-3014",
  post: "737-0051",
  geocode: "132.5629048,34.2469127",
  libkey: "中央�{��{�館",
  libid: "101095",
  systemid: nil,
  city: nil>]

```

### ⑬ id: 7747の図書館のみ途中で処理が止まる