# MyBooks
<img width="1434" alt="toppage_mybooks" src="https://user-images.githubusercontent.com/64352944/97099900-701f2f80-16d1-11eb-91a3-ba0389887139.png">

# URL
**https://mybooks-pf.com**  
ゲストログインボタンより、ゲストユーザとしてログインできます。

# 概要
読んだ本を投稿し、シェアできるサービスです。  
本を選ぶときの参考にしたり、自分が読んだ本を管理したりすることができます。

# 制作背景
ECサイトなどで本を探すときに、特定の本に対する様々な人の評価を目にすることはできますが、  
他人の読んだ本の記録や、他人の「本棚」を見る機会はなかなかありません。  

自分と趣味の近い人の本棚があれば、簡単に面白そうな本を見つけることができ、  
自分とは価値観の違う人の本棚があれば、読む本の幅を広げることができると思い、  
このアプリケーションを開発することにしました。

# 使用技術
#### バックエンド
* Ruby 2.6.6
* Rails 5.2.4.3  

#### フロントエンド
* HTML
* SCSS
* Bootstrap
* JavaScript
* jQuery
* Ajax  

#### DB
* MySQL  

#### テスト
* RSpec
* RuboCop  

#### webサーバー・アプリケーションサーバー
* Nginx
* Puma  

#### 開発環境
* Docker / Docker-Compose  

#### 本番環境
* AWS(VPC,EC2,RDS,Route53,ALB,ACM,S3)  

#### その他
* Git / Github(pull request, issue)
* CircleCI

# 機能一覧
* ユーザ登録、ログイン、ログイン保持機能（devise）
* 新規投稿、投稿編集、投稿削除機能
* ページネーション機能（kaminari）
* 画像アップロード・画像リサイズ機能（carriewave, minimagic, fog, Amazon S3）
* 投稿一覧表示機能（ジャンル別表示・フォローユーザの投稿表示）
* いいね機能（Ajax）
* フォロー・フォロー解除機能（Ajax）
* コメント送信・編集・削除機能（Ajax）
* 通知機能（いいね・フォロー・コメントがあった場合）
* 検索機能
* ゲストログイン機能
* レスポンシブ対応
* RSpec（ModelSpec, RequestSpec, SystemSpec）

# インフラ構成図
![aws_mybooks](https://user-images.githubusercontent.com/64352944/97099922-a9f03600-16d1-11eb-9e40-a7276f6b9c1c.png)

# ER図
<img width="1179" alt="ER図_mybooks" src="https://user-images.githubusercontent.com/64352944/97099934-c1c7ba00-16d1-11eb-9d34-007efe55fdf4.png">
