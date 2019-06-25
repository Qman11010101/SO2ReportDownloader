# SO2レポートダウンローダー

SO2のレポートやらランキングやらのデータのダウンロードが面倒くさいので作りました。  
はじめてのRubyプログラムです。

## 使用法

YYYYMMDD形式で日付を入力して期間を設定すると同じディレクトリのso2stockdataフォルダにレポートが全部ぶちこまれます。  
うれしいね。

## 注意点

連続で叩いていいのは初回だけです。詳しくは[SO2のAPI詳細ページ](https://so2-docs.mutoys.com/common/api.html)を読んでください。  
このプログラムは1秒ごとにAPIを叩きます。  
ちなみに私は0.4秒間隔で叩いてたら403食らってプログラム落ちました。403食らったら待機するようにしなきゃダメかこれ？めんど
