# MyStudy Note

## サイト概要

「学習内容の記録&共有・やることリストの作成」ができるサイトです。

### サイトテーマ

自分だけの学習ノートを作成して勉強を習慣化させよう！

### テーマを選んだ理由

勉強のコツは色々ありますが、何よりもまず「継続すること」が重要だと考えています。<br>
そして、学習を継続するにはモチベーションの維持が大切ですが、モチベーションを保つことは簡単ではないと思います。<br>
特に社会人は勉強時間の確保が難しく、私も勉強のモチベーション維持のために色々と工夫していました。<br>
その経験から学習の継続を支援し、目標に向かって努力する人（もちろん社会人だけでなく学生も）を応援したいと思い、このサービスを作りました。

### ターゲットユーザ

- 資格取得やスキルアップのために勉強を始めようと考えている方
- 学生・社会人問わず勉強を頑張っている方

### 主な利用シーン

日々の学習時

### インフラ構成図

![AWS構成図](https://user-images.githubusercontent.com/72193151/107850593-e0032280-6e46-11eb-8fc8-24441a52a996.png)

### ER図

[ER図](https://drive.google.com/file/d/1SM3UTrxBLw9H04xEEPTkETF_sXcT-DZi/view?usp=sharing)

### 機能一覧

[機能一覧](https://docs.google.com/spreadsheets/d/1uf71gUTZzam3aA9dKymw8a_ryugLgIWPh6h5TMhJITw/edit?usp=sharing)
- CSSフレームワーク（bootstrap4）
- ユーザー認証機能（devise）
- CRUD処理（学習記録、ToDoリスト）
- いいね、コメント機能
- フォロー機能
- テスト（Rspec、capybara、factory_bot）
- コードフォーマット（Rubocop-airbnb、rails_best_pracitces）
- セキュリティチェック（brakeman）
- 過剰アクセス対策（rack-attack）
- 画像アップロード（refile、refile-mini_magick、refile-s3）
- 画像プレビュー
- 検索（ransack）
- メール（ActionMailer）
- グラフ（chartkick）
- ページネーション（kaminari）
- カレンダー（simple_calendar）
- タグ（acts-as-taggable-on）
- パンくずリスト（gretel）
- スライドショー（slick）
- 管理者ログイン（devise）
- N+1問題（bullet、counter_culture）
- バッチ（whenever）

### 開発環境

- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JS ライブラリ：jQuery
- IDE：Cloud9

#### バッチ処理の確認

```
# 定時処理の内容をcronへ反映
RAILS_ENV=production bundle exec whenever --update-crontab

# cronへ反映した内容を削除
RAILS_ENV=production bundle exec whenever --clear-crontab

# cronのログ確認
RAILS_ENV=production crontab  -l
```
