# routes.rbでのasオプション

* routes.rbファイルでasオプションをつけると、名前を指定することができる。
```
 get 'exit', to: 'sessions#destroy', as: :logout 
```
### 結果
* 名前付きヘルパーとしてlogout_pathとlogout_urlが作成される。
* logout_pathを呼び出すと/exitが返される。

# 参考資料
* * *
[【Ruby on Rails】ルーティングの:asについて](https://qiita.com/lemonade_37/items/7c2b755179abe19c1efe)

[【Rails】routes.rbでのasオプション
](https://qiita.com/xusaku_/items/c5c9137d580db1c19a22)