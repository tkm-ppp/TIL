# APIとは
APIとは「アプリケーション・プログラミング・インターフェース（Application Programming Interface）」の略称です。一言で表すと、ソフトウェアやプログラム、Webサービスの間をつなぐインターフェースのことを指します

* * *
# 実装方法

1. getリクエストを送る(URL)

2.responseが帰ってくる(XML. JSON等のデータ)

3.（XMLのデータをパース(各言語で使えるように変換する）

4.目的のデータを取得する
* * *
# 具体的な実装方法
### getリクエストを送る(URL)
⇨response = Net::HTTP.get(uri)

### responseが帰ってくる(XML. JSON等のデータ)
⇨response

### XMLのデータをパースする
⇨doc_parsed = LibXML::XML::Document.string(response)

### 目的のデータを取得する
⇨
      doc_parsed.find('/rss/channel/item').each do |x|
        @titles = x.find('title').first&.content
        @authors =  x.find('author').first&.content
      end