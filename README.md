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

- 日々の学習時

### インフラ構成図

![AWS構成図](https://user-images.githubusercontent.com/72193151/108654789-bfa12b00-750c-11eb-9692-db1157505d93.png)

### ER図

[ER図](https://drive.google.com/file/d/1SM3UTrxBLw9H04xEEPTkETF_sXcT-DZi/view?usp=sharing)

### 機能・技術一覧

[機能一覧](https://docs.google.com/spreadsheets/d/1uf71gUTZzam3aA9dKymw8a_ryugLgIWPh6h5TMhJITw/edit?usp=sharing)
- CSSフレームワーク（bootstrap4）
- ユーザー認証機能（devise）
- CRUD処理（学習記録、ToDoリスト）
- いいね（Ajax）、コメント機能
- フォロー機能（Ajax）
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
- シェル：bash
- Ruby：2.6.3
- Ruby on Rails：5.2.4.4
- HTML&CSS(bootstrap,SCSS)
- JavaScript(jQuery)
