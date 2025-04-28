# 経緯
図書館を事前設定して検索時にどの図書館で借りれるか表示させたい。事前設定には現在検索機能を実装しているが、利便性を考えると現在位置から近くの図書館も表示したい

# 目的
- 検索時に表示する図書館の設定を利用者が出来るようにするために事前設定を可能にしたい。
- 事前設定時、現在位置から近くの図書館を表示したい

# 方針
「Maps JavaScript API」と「Places API」と「Geolocation API」を使用する

# 方法
１、「Maps JavaScript API」と「Places API」と「Geolocation API」の有効化とAPIキーの発行

(1).Google Cloud Consoleでプロジェクト作成

(2).「Maps JavaScript API」と「Places API」と「Geolocation API」を有効化

(3).APIキーを発行し.envファイルに設定

(4)実装のためのスクリプトを入れる
```
<!-- Googleマップ表示用の Javascript -->
<script>
  async function initMap() {
    const { Map } = await google.maps.importLibrary("maps");

    const map = new Map(document.getElementById("map"), {
      center: { lat: <%= @library.geocode.split(",")[1].to_f %>, lng: <%= @library.geocode.split(",")[0].to_f %> }, // 位置を更新
      zoom: 15,
    });
    const marker = new google.maps.Marker({
      position: { lat: <%= @library.geocode.split(",")[1].to_f %>, lng: <%= @library.geocode.split(",")[0].to_f %> },
      map: map,
      title: "tokyo-tower",
    });

    const infoWindow = new google.maps.InfoWindow({ // 吹き出しの追加
      content: '<div class="sample"><%= @library.formal %></div>' // 吹き出しに表示する内容
    });
    marker.addListener('click', function() { // マーカーをクリックしたとき
      infoWindow.open(map, marker); // 吹き出しの表示
    });
  }
</script>

<script async src="https://maps.googleapis.com/maps/api/js?key=<%= ENV['GOOGLE_MAPS_KEY'] %>&callback=initMap"></script>
```
## Googleマップ表示用の JavaScript 解説
### 1. スクリプトの開始
```
<script>
```
- 上記のタグは、JavaScriptコードが始まることを示します。このタグはHTMLドキュメント内にJavaScriptを埋め込むために使用されます。

### 2. 非同期関数の定義
```
async function initMap() {
```
- async キーワードは、この関数が非同期であることを示します。
- initMap は関数の名前で、地図を初期化するために使用されます。

### 3. Google Mapsライブラリのインポート
```
const { Map } = await google.maps.importLibrary("maps");
```
- google.maps.importLibrary("maps") は、Google Mapsライブラリをインポートするためのメソッドです。
- await を使うことで、この処理が完了するまで次の行に進みません。
- { Map } は、インポートしたライブラリから Map オブジェクトを取得します。

### 4. 地図の作成
```
const map = new Map(document.getElementById("map"), {
  center: { lat: <%= @library.geocode.split(",")[1].to_f %>, lng: <%= @library.geocode.split(",")[0].to_f %> },
  zoom: 15,
});
```
- new Map(...) は、新しい地図を作成するためのコンストラクタです。
- document.getElementById("map") は、HTML内の id="map" を持つ要素を取得します。
- center は地図の中心の緯度（lat）と経度（lng）を指定します。ここでは Ruby の ERBを使って、@library.geocode から値を取得しています。
- zoom は地図のズームレベルを指定します。

### 5. マーカーの作成
```const marker = new google.maps.Marker({
  position: { lat: <%= @library.geocode.split(",")[1].to_f %>, lng: <%= @library.geocode.split(",")[0].to_f %> },
  map: map,
  title: "tokyo-tower",
});
```
- google.maps.Marker は地図上にマーカーを表示するためのオブジェクトです。
- position にはマーカーの位置を設定します。
- map プロパティには、先ほど作成した map オブジェクトを指定します。
- title はマーカーにマウスオーバーした際に表示されるタイトルです。

### 6.吹き出しの追加
```
const infoWindow = new google.maps.InfoWindow({
  content: '<div class="sample"><%= @library.formal %></div>'
});
```
- google.maps.InfoWindow は、マーカーをクリックしたときに表示される情報ウィンドウを作成します。
- content には表示する内容を指定します。ここでも Ruby の ERBを使って、@library.formal の値を表示します。

### 7. マーカーのクリックイベント
```
marker.addListener('click', function() {
  infoWindow.open(map, marker);
});
```
- marker.addListener('click', ...) は、マーカーがクリックされたときに実行される関数を定義します。
- infoWindow.open(map, marker) によって、マーカーの位置に情報ウィンドウが表示されます。

### 8.Google Maps APIの読み込み
```
<script async src="https://maps.googleapis.com/maps/api/js?key=<%= ENV['GOOGLE_MAPS_KEY'] %>&callback=initMap"></script>
```
- この行は、Google Maps APIを非同期で読み込むためのスクリプトタグです。
- src 属性にはAPIのURLが指定されています。
- key パラメータには、Google Maps APIのキーが設定されています。
- callback=initMap によって、APIの読み込みが完了した後に initMap 関数が呼び出されます。