require "date"
require "open-uri"

# 日付受け取り
puts "開始日をYYYYMMDDの形で入力してください"
timeStart = gets.chomp
puts "終了日をYYYYMMDDの形で入力してください"
timeEnd = gets.chomp

# timeオブジェクトへ変換
startParsed = Date.parse(timeStart)
endParsed = Date.parse(timeEnd)

if endParsed <= startParsed then
    puts "終了日が開始日より未来になっています"
    exit!
end

# timeオブジェクトを日本語表記に変換
startStr = startParsed.strftime("%Y年%m月%d日")
endStr = endParsed.strftime("%Y年%m月%d日")

puts startStr + "から" + endStr + "までのデータを取得します"

# ディレクトリがなければ作成
if Dir.exist?("./reports") == false then
    Dir.mkdir("./reports")
end

# 処理部(DLして保存)
(Date.parse(timeStart)..Date.parse(timeEnd)).each do |date|
    ymd = date.strftime("%Y%m%d")
    url = "https://so2-api.mutoys.com/json/report/buy#{ymd}.json"
    open(url) do |rep|
        open("./reports/report-#{ymd}.json", "w+b") do |save|
            save.write(rep.read)
        end
    end
    sleep(1)
end