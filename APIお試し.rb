require 'net/http'
require 'uri'
require 'libxml' # XMLをパースする場合

appkey = "7c854f40b6a4274618da08219f6c60e0"
isbn = "4834000826"
format = "xml" # or "json"

base_url = "https://api.calil.jp/check"
params = { appkey: appkey, isbn: isbn, format: format }
uri = URI.parse(base_url + "?" + URI.encode_www_form(params))

begin
  response = Net::HTTP.get(uri)

  unless response.is_a?(Net::HTTPSuccess)
    raise "HTTP error: #{response.code}"
  end

  if format == "xml"
    doc_parsed = LibXML::XML::Document.string(response)
    # XMLデータの処理を記述
    # 例: puts doc_parsed.find('/ResultSet/books/book/systemname').first&.content
  elsif format == "json"
    json_parsed = JSON.parse(response)
    # JSONデータの処理を記述
    # 例: puts json_parsed["ResultSet"]["books"]["9784798142475"]["systemname"]
  end

rescue => e
  puts "Error: #{e.message}"
end