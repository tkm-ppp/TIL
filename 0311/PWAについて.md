# PWAとはどういうものか？
- PWAとは、Webサイトをアプリ化する技術や仕組みのこと
- 「Progressive Web Apps」の頭文字を取ってPWAといわれている。
- PWAは多機能でありながらネイティブアプリよりもコストを抑えて開発できるため、多くの企業が注目している。

具体的にいうと・・・
- Webサイトをアプリ化すると、スマートフォンのアプリのように、ホーム画面にアイコンを設置でき、すぐにアクセスできるようになります。
- 他に、オフラインでの動作を可能にしたり、プッシュ通知を送ったりと、ネイティブアプリのような機能を使えるようになるのが特徴
## PWAとネイティブアプリの違い
` ネイティブアプリ `

- ストアへの登録や審査の有無」や「アップデートの必要性の有無」です。ネイティブアプリを配信する場合、App StoreやGoogle Playといったアプリストアに登録してもらうために審査を通過する必要があります。

`PWA`

- アプリストアを経由する必要がなく、インストールも不要
- ブラウザ上で動作するため、デバイスやOSに依存せずにユーザーはすぐアクセス可能

# なぜ使うか？
- Webサイトをアプリ化すると、スマートフォンのアプリのように、ホーム画面にアイコンを設置でき、すぐにアクセスできるようになるから。

# どうやって使うか？
## 1.アイコンの準備
## 2.manifest.jsonファイルの記述
- manifest.jsonファイルとはPWAの設定を書く場所

`manifest.json.erb`
```
{
  "name": "ReadLink",
  "short_name": "R.Link",
  "icons": [
    {
      "src": "/android-chrome-512x512.png",
      "type": "image/png",
      "sizes": "512x512"
    },
    {
      "src": "/android-chrome-192x192.png",
      "type": "image/png",
      "sizes": "192x192"
    },
  ],
  "start_url": "/",
  "display": "standalone",
  "scope": "/",
  "description": "App.",
  "theme_color": "red",
  "background_color": "#ffffff"
}

```
<details><summary>各項目の解説</summary>

### 各項目の解説
**1.name:**
アプリケーションのフルネーム。
例: "ReadLink"

**2.short_name:**
アプリケーションの短縮名。
例: "R.Link"

**3.icons:**
アプリのアイコン情報を持つ配列。
各アイコンの属性:
src: アイコンの画像ファイルのパス。
type: アイコンの形式（例: image/png）。
sizes: アイコンのサイズ（例: "512x512"）。

**4.start_url:**
アプリが起動する際の初期URL。
例: "/"

**5.display:**
アプリの表示モード。疑似アプリ形式にできる
例: "standalone"

**6.scope:**
アプリが操作できる範囲。
例: "/"

**7.description:**
アプリの簡単な説明。
例: "App."

**8.theme_color:**
アプリのテーマカラー。
例: "red"

**9.background_color:**
アプリの背景色。
例: "#ffffff"（白色）
</details>

## 3.マニフェストファイルの設定
application.html.erbの〈head〉に記述
```
<link rel="manifest" href="./manifest.json"/>
```

## 4.Service Workerの設定
<details open><summary>Service Workerとは</summary>

### Service Workerとは
- Webアプリの制御・動作を記述する場所
- ブラウザにインストールされる
- メインスレッドとは別スレッドで動作

**主な機能**
1. オフライン機能:
- キャッシュを利用して、ユーザーはオフラインでもコンテンツにアクセスできます。

2.プッシュ通知:
  - プッシュ通知を受信することができます。これにより、ユーザーにリアルタイムで情報を提供することが可能になります。
  
3.バックグラウンド同期:
- ネットワーク接続が回復した際に、バックグラウンドでデータを同期することができます。
</details>

## Service Workerの登録
- プロジェクトのルートディレクトリにsw.jsというファイルを作成します。
(この場合のルートディレクトリはpublic)

以下のコードを入れる。
```
const CACHE_NAME = 'my-site-cache-v1';
const urlsToCache = [
  '/',
  '/styles/main.css',
  '/script/main.js'
];

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        return cache.addAll(urlsToCache);
      })
  );
});
  
  self.addEventListener('activate', function(event) {
    console.log('Service Worker activating.');
  });
  
  self.addEventListener('fetch', function(event) {
    event.respondWith(
      caches.match(event.request)
        .then(function(response) {
          if (response) {
            return response;
          }
          return fetch(event.request);
        }
      )
    );
  });
```
### ServiceWorkerで発生するイベント
- ライフサイクル関連：install、activate
- 機能関連イベント：message、fetch、push、sync

**installイベント**
ServiceWorkerの初回登録時と更新時に発生
オフライン時のリソースの収集を行う

**activateイベント**
ServiceWorkerが有効化される時に発生
旧バージョンのキャッシュの削除を行う

**messageイベント**
アプリのJSからメッセージを受信した際に発生
WebアプリとServiceWorker間でのやり取りに利用

**fetchイベント**
WebアプリがHTTP通信を行った際に発生
オフライン時のキャッシュ応答を行う

**pushイベント**
プッシュ通知を受信した際に発生
プッシュ通知を表示する

**syncイベント**
ネットワークがオンラインに復帰した際に発生
オフライン時の操作をオンライン復帰時に実施する

中でもinstall、activate、fetchはよく利用します♪

**キャッシュイベント**
オフラインで動作可能になる
キャッシュしたいURLを記述する。
以下は例
```
const CACHE_NAME = 'my-site-cache-v1';
const urlsToCache = [
  '/',
  '/styles/main.css',
  '/script/main.js'
];
```