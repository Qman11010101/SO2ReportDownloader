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

puts "ディレクトリを生成します"

# ディレクトリがなければ作成
if Dir.exist?("./so2stockdata") == false then
    Dir.mkdir("./so2stockdata")
end
if Dir.exist?("./so2stockdata/buy_reports") == false then
    Dir.mkdir("./so2stockdata/buy_reports")
end
if Dir.exist?("./so2stockdata/ranking") == false then
    Dir.mkdir("./so2stockdata/ranking")
end
if Dir.exist?("./so2stockdata/ranking/all_top3_monthly") == false then
    Dir.mkdir("./so2stockdata/ranking/all_top3_monthly")
end
if Dir.exist?("./so2stockdata/ranking/top1000_monthly") == false then
    Dir.mkdir("./so2stockdata/ranking/top1000_monthly")
end
if Dir.exist?("./so2stockdata/ranking/top1000_daily") == false then
    Dir.mkdir("./so2stockdata/ranking/top1000_daily")
end
departmentArray = ["point_total", "sale_total", "exp_stock", "exp_sale", "exp_job", "exp_trans", "exp_1", "exp_2", "exp_3", "exp_4", "exp_5", "exp_6", "exp_7", "exp_8", "exp_9", "exp_10", "exp_11", "exp_12", "exp_51", "exp_52", "exp_53", "exp_54", "exp_55", "exp_56", "exp_57", "exp_58", "exp_59", "exp_60", "exp_61", "exp_62", "exp_63", "exp_64", "exp_65", "exp_66", "exp_67", "exp_68", "exp_69", "exp_70"]
(departmentArray.length).times do |element|
    if Dir.exist?("./so2stockdata/ranking/top1000_monthly/#{departmentArray[element]}") == false
        Dir.mkdir("./so2stockdata/ranking/top1000_monthly/#{departmentArray[element]}")
    end
    if Dir.exist?("./so2stockdata/ranking/top1000_daily/#{departmentArray[element]}") == false
        Dir.mkdir("./so2stockdata/ranking/top1000_daily/#{departmentArray[element]}")
    end
end

puts startStr + "から" + endStr + "までのデータを取得します"

# 処理部(DLして保存)
# レポート
(Date.parse(timeStart)..Date.parse(timeEnd)).each do |date|
    ymd = date.strftime("%Y%m%d")
    if File.exist?("./so2stockdata/buy_reports/#{ymd}.json") == false
        begin
            url = "https://so2-api.mutoys.com/json/report/buy#{ymd}.json"
            puts url + "にアクセスしています"
            open(url) do |rep|
                open("./so2stockdata/buy_reports/#{ymd}.json", "w+b") do |save|
                    save.write(rep.read)
                end
            end
            puts "./so2stockdata/buy_reports/#{ymd}.jsonとして保存しました"
        rescue
            puts "エラー: " + url + "にアクセスできませんでした"
        end
        sleep(0.4)
    else
        puts "./so2stockdata/buy_reports/#{ymd}.jsonは既に存在しています"
    end
end

# 月間全部門トップ3
(Date.parse(timeStart)..Date.parse(timeEnd)).each do |date|
    ymd = date.strftime("%Y-%m")
    if date.strftime("%d") == "28"
        if File.exist?("./so2stockdata/ranking/all_top3_monthly/#{ymd}.json") == false
            begin
                url = "https://so2-api.mutoys.com/json/ranking/#{ymd}/summary.json"
                puts url + "にアクセスしています"
                open(url) do |rep|
                    open("./so2stockdata/ranking/all_top3_monthly/#{ymd}.json", "w+b") do |save|
                        save.write(rep.read)
                    end
                end
                puts "./so2stockdata/ranking/all_top3_monthly/#{ymd}.jsonとして保存しました"
                count += 1
            rescue
                puts "エラー: " + url + "にアクセスできませんでした"
                count += 1
            end
            sleep(0.4)
        else
            puts "./so2stockdata/ranking/all_top3_monthly/#{ymd}.jsonは既に存在しています"
        end
    end
end

# 月間部門別トップ1000
(Date.parse(timeStart)..Date.parse(timeEnd)).each do |date|
    ymd = date.strftime("%Y-%m")
    if date.strftime("%d") == "28"
        (departmentArray.length).times do |element|
            if File.exist?("./so2stockdata/ranking/top1000_monthly/#{departmentArray[element]}/#{ymd}.json") == false
                begin
                    url = "https://so2-api.mutoys.com/json/ranking/#{ymd}/#{departmentArray[element]}.json"
                    puts url + "にアクセスしています"
                    open(url) do |rep|
                        open("./so2stockdata/ranking/top1000_monthly/#{departmentArray[element]}/#{ymd}.json", "w+b") do |save|
                            save.write(rep.read)
                        end
                    end
                    puts "./so2stockdata/ranking/top1000_monthly/#{departmentArray[element]}/#{ymd}.jsonとして保存しました"
                rescue
                    puts "エラー: " + url + "にアクセスできませんでした"
                end
                sleep(0.4)
            else
                puts "./so2stockdata/ranking/top1000_monthly/#{departmentArray[element]}/#{ymd}.jsonは既に存在しています"
            end
        end
        sleep(0.4)
    end
end

# デイリートップ1000(部門別)
(Date.parse(timeStart)..Date.parse(timeEnd)).each do |date|
    ymd = date.strftime("%Y-%m-%d")
    (departmentArray.length).times do |element|
        if File.exist?("./so2stockdata/ranking/top1000_daily/#{departmentArray[element]}/#{ymd}.json")
            begin
                url = "https://so2-api.mutoys.com/json/ranking/#{ymd}/#{departmentArray[element]}.json"
                puts url + "にアクセスしています"
                open(url) do |rep|
                    open("./so2stockdata/ranking/top1000_daily/#{departmentArray[element]}/#{ymd}.json", "w+b") do |save|
                        save.write(rep.read)
                   end
                end
                puts "./so2stockdata/ranking/top1000_daily/#{departmentArray[element]}/#{ymd}.jsonとして保存しました"
            rescue
                puts "エラー: " + url + "にアクセスできませんでした"
            end
            sleep(0.4)
        else
            puts "./so2stockdata/ranking/top1000_daily/#{departmentArray[element]}/#{ymd}.jsonは既に存在しています"
        end
    end
end