require 'json'
require 'net/http'
require 'uri'

def some_api_call
  uri = URI.parse("https://api.calil.jp/check") 
  response = Net::HTTP.get_response(uri)
  response.body
end

# API呼び出し
response = some_api_call()  # ここでAPIを呼び出す

# JSONP形式のレスポンスからJSON部分を抽出
json_data = response.match(/callback\((.*)\);/)[1]  # 正規表現でJSON部分を抽出

# JSON文字列をハッシュに変換
parsed_response = JSON.parse(json_data)

# 必要なデータを取得
puts parsed_response['session']
puts parsed_response['continue']

parsed_response['books'].each do |isbn, book_info|
  puts "ISBN: #{isbn}"
  book_info.each do |library, info|
    puts "Library: #{library}, Status: #{info['status']}, Reserve URL: #{info['reserveurl']}"
    info['libkey'].each do |lib_name, status|
      puts "  #{lib_name}: #{status}"
    end
  end
end
