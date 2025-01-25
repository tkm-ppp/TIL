# rexmlライブラリについて
* * *
Ruby標準のrexmlライブラリである。

# 目的
簡単にRubyのプログラムでXMLファイルを扱うこと。

# remxlライブラリを使う方法
* remxlライブラリには幾つかのサブライブラリが含まれており、利用したい機能に合わせてそのサブライブラリを利用します。例えば、XMLを読み込んでそのデータをDOMツリーに変換するには、documentサブライブラリを利用します

* Ruby で XML をパースしたいとき

### 前提条件

xml2 が必要です。
### Ruby Gems
***
表示して
Windows の場合は sudo は要りません。

sudo gem install libxml-ruby

***
### 実際のコード
実際には「LibXML::XML::Document」というパッケージで libxml.rb の中で include していて「LibXML::」を省略することができています*1。

doc = LibXML::XML::Document.string(xml)