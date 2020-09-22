# --------------
# --- ユーザ ---
# --------------
User.create!(
  image: open("#{Rails.root}/db/user_image/user_image1.jpg"),
  nickname: 'ダイチ',
  email: 'firstuser@example.com',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: 30.day.ago
)

User.create!(
  image: open("#{Rails.root}/db/user_image/user_image2.jpg"),
  nickname: 'ゲストユーザ',
  email: 'guestuser@example.com',
  password: Rails.application.credentials.guest_user_password,
  password_confirmation: Rails.application.credentials.guest_user_password,
  confirmed_at: 30.day.ago
)

13.times do |n|
  nickname = Faker::Name.first_name
  email = "example#{n+2}@example.com"
  User.create!(
    image: open("#{Rails.root}/db/user_image/user_image#{n+3}.jpg"),
    nickname: nickname,
    email: email,
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: 30.day.ago
  )
end

15.times do |n|
  nickname = Faker::Name.first_name
  email = "example#{n+15}@example.com"
  User.create!(
    nickname: nickname,
    email: email,
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: 30.day.ago
  )
end

# ----------------
# --- 投稿20件 ---
# ----------------
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image1.jpg"),
  title: 'ナミヤ雑貨店の奇蹟',
  author: '東野圭吾',
  publisher: '角川文庫',
  genre: 'novel',
  rating: 'int4',
  hours: 'to30',
  purchase_date: '2019-10-15',
  post_content: '面白かったです。',
  user_id: 1,
  created_at: 19.day.ago,
  updated_at: 19.day.ago
)

Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image2.jpg"),
  title: 'ゼロからつくるビジネスモデル: 新しい価値を生み出す技術',
  author: '井上 達彦',
  publisher: '東洋経済新報社',
  genre: 'business',
  rating: 'int4_5',
  hours: 'to20',
  purchase_date: '2020-5-20',
  post_content: '”“海外のイノベーション教育プログラム”“学術の先端領域”を数多くの事例とともに一冊に凝縮',
  user_id: 2,
  created_at: 18.day.ago,
  updated_at: 18.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image3.jpg"),
  title: '新・エリート教育 混沌を生き抜くためにつかみたい力とは?',
  author: '竹村 詠美',
  publisher: '日本経済新聞出版',
  genre: 'education',
  rating: 'int3_5',
  hours: 'to20',
  purchase_date: '2020-9-19',
  post_content: 'わが子、次世代の若者に、変化に対応して生き延びる知恵をつけさせるには、どうしたらいいのか、それが書かれています。',
  user_id: 3,
  created_at: 17.day.ago,
  updated_at: 17.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image4.jpg"),
  title: 'SF映画のタイポグラフィとデザイン',
  author: 'デイヴ・アディ(著) 篠儀直子(翻訳)',
  publisher: 'フィルムアート社',
  genre: 'art_ent',
  rating: 'int3',
  hours: 'to10',
  purchase_date: '2018-7-19',
  post_content: 'タイポグラフィとデザインからSFを分析する、面白い本です。',
  user_id: 4,
  created_at: 16.day.ago,
  updated_at: 16.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image5.jpg"),
  title: 'ウチら棺桶まで永遠のランウェ',
  author: 'kemio',
  publisher: 'KADOKAWA',
  genre: 'celebrity',
  rating: 'int2_5',
  hours: 'to10',
  purchase_date: '2019-5-5',
  post_content: '面白かったです。kemioのイメージが変わりました。',
  user_id: 5,
  created_at: 15.day.ago,
  updated_at: 15.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image6.jpg"),
  title: '境遇',
  author: '湊かなえ',
  publisher: '双葉文庫',
  genre: 'novel',
  rating: 'int4',
  hours: 'to20',
  purchase_date: '2020-9-5',
  post_content: 'どんでん返しの展開です。',
  user_id: 6,
  created_at: 14.day.ago,
  updated_at: 14.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image7.jpg"),
  title: '反応しない練習 あらゆる悩みが消えていくブッダの超・合理的な「考え方」',
  author: '草薙龍瞬',
  publisher: 'KADOKAWA/中経出版',
  genre: 'business',
  rating: 'int5',
  hours: 'to20',
  purchase_date: '2020-8-22',
  post_content: '非常にためになりました。これを読むと苦悩に感じていたことも前向きに捉えられそうです。読み返して、書かれていることを実践していきたいと思いました。',
  user_id: 7,
  created_at: 13.day.ago,
  updated_at: 13.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image8.jpg"),
  title: '私たちは子どもに何ができるのか――非認知能力を育み、格差に挑む',
  author: 'ポール・タフ',
  publisher: '英治出版',
  genre: 'education',
  rating: 'int4',
  hours: 'to20',
  purchase_date: '2020-9-10',
  post_content: '子どもの貧困率が日本の4倍近い50%という状況にあるアメリカでは、長年にわたってさまざまな取り組みがなされている。数々の事例と、そこから得られた最新の知見が本書にある。
  本書は子どもに関わる全ての大人に読んで頂きたい。いや、読まなくてはいけない。',
  user_id: 8,
  created_at: 12.day.ago,
  updated_at: 12.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image9.jpg"),
  title: '現代アートとは何か',
  author: '小崎哲哉',
  publisher: '河出書房新社',
  genre: 'art_ent',
  rating: 'int3',
  hours: 'to30',
  purchase_date: '2020-8-20',
  post_content: '現代アートが成立する背景が詳しく書かれていました。',
  user_id: 1,
  created_at: 11.day.ago,
  updated_at: 11.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image10.jpg"),
  title: 'ひとりで生きていく',
  author: 'ヒロシ',
  publisher: '廣済堂出版',
  genre: 'celebrity',
  rating: 'int3_5',
  hours: 'to20',
  purchase_date: '2020-7-23',
  post_content: 'これからの時代の指針になるような本でした。',
  user_id: 2,
  created_at: 10.day.ago,
  updated_at: 10.day.ago
)

Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image11.jpg"),
  title: 'きょうの料理 わたしのいつものごはん',
  author: '栗原 はるみ',
  publisher: 'NHK出版',
  genre: 'others',
  rating: 'int4',
  hours: 'to10',
  purchase_date: '2020-9-16',
  post_content: '見やすく、作る意欲が湧きます。',
  user_id: 3,
  created_at: 9.day.ago,
  updated_at: 9.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image12.jpg"),
  title: 'こども六法',
  author: '山崎 聡一郎',
  publisher: '山崎 聡一郎',
  genre: 'child',
  rating: 'int4_5',
  hours: 'to10',
  purchase_date: '2020-9-10',
  post_content: 'いじめがどのような犯罪にあたるかが分かりやすく書かれています。絵も多く、漢字には振り仮名も付けられて子供向けなのも好印象です。
  いじめは単に倫理的な問題ではなく、刑法上の問題であり犯罪であることを再確認することができると思います。',
  user_id: 4,
  created_at: 8.day.ago,
  updated_at: 8.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image13.jpg"),
  title: '名古屋発 半日旅',
  author: '吉田 友和',
  publisher: 'ワニブックス',
  genre: 'geography',
  rating: 'int3_5',
  hours: 'to10',
  purchase_date: '2020-9-20',
  post_content: '名古屋から「半日」で行って帰ってこられる、おもしろいスポットが満載です。',
  user_id: 5,
  created_at: 7.day.ago,
  updated_at: 7.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image14.jpg"),
  title: 'キャラ絵で学ぶ！ 仏教図鑑',
  author: '山折哲雄 いとうみつる',
  publisher: 'すばる舎',
  genre: 'hobby',
  rating: 'int4',
  hours: 'to10',
  purchase_date: '2020-4-25',
  post_content: '絵本的で面白いです。',
  user_id: 6,
  created_at: 6.day.ago,
  updated_at: 6.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image15.jpg"),
  title: '池袋ウエストゲートパーク',
  author: '石田 衣良',
  publisher: '文藝春秋',
  genre: 'novel',
  rating: 'int4',
  hours: 'to20',
  purchase_date: '2020-9-10',
  post_content: '昔持っていましたが、友達にあげてしまったので、改めて購入しました。
  本当に素晴らしいです。
  都会に暮らす人たちの姿が、いきいきと描かれています。
  続刊も面白いですが、本作はなお面白いです。',
  user_id: 7,
  created_at: 5.day.ago,
  updated_at: 5.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image16.jpg"),
  title: '完訳 7つの習慣 人格主義の回復',
  author: 'スティーブン・R．コヴィー',
  publisher: 'キングベアー出版',
  genre: 'business',
  rating: 'int4_5',
  hours: 'to30',
  purchase_date: '2020-8-2',
  post_content: '名著として名高いですが、そう呼ばれる意味がわかりました。
  今まで読んだ本の中でも最高の本です。
  決して堅いほんという訳ではなく、読んでいて感動するところもあります。
  何回も読み直したい、そう思える一冊でした。',
  user_id: 1,
  created_at: 4.day.ago,
  updated_at: 4.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image17.jpg"),
  title: '表参道のセレブ犬とカバーニャ要塞の野良犬',
  author: '若林 正恭',
  publisher: 'KADOKAWA',
  genre: 'celebrity',
  rating: 'int4',
  hours: 'to10',
  purchase_date: '2020-6-12',
  post_content: 'オードリー若林さんの本ということで、以前から気になっていました。
  文章がうまいなあと思いながら読みすすめ、どんどん読んでしまいました。
  そして、人とのつながりを考えさせられる内容でした。
  この本が胸に刺さる方は多いのではないでしょうか。',
  user_id: 2,
  created_at: 3.day.ago,
  updated_at: 3.day.ago
)
Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image18.jpg"),
  title: '流浪の月',
  author: '凪良 ゆう',
  publisher: '東京創元社',
  genre: 'novel',
  rating: 'int3_5',
  hours: 'to20',
  purchase_date: '2020-9-13',
  post_content: '2020年本屋大賞 大賞受賞作を受賞したということで気になり、読みました。
  あらすじを読んだ段階ではよくわかりませんでしたが、じっくり読み進めていくと、いつしか手が止まらなくなりました。
  若干物足りない感じもしましたが、名作だとは思います。
  人により評価・受け取り方が変わりそうな作品です。
  お時間のあるときに、ゆっくり読むことをお勧めします。',
  user_id: 3,
  created_at: 2.day.ago,
  updated_at: 2.day.ago
)

Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image19.jpg"),
  title: 'ＳＨＯＥ ＤＯＧ ―靴にすべてを。',
  author: 'フィル・ナイト(著) 大田黒奉之(翻訳) ',
  publisher: '東洋経済新報社',
  genre: 'business',
  rating: 'int4_5',
  hours: 'to30',
  purchase_date: '2020-8-10',
  post_content: 'ナイキ創業者フィル・ナイトの自伝です。
  ナイキは、知らない人はいないと言っていいほどの企業だと思いますが、日本と深く関わっていたのは意外でした。
  翻訳が素晴らしく、一気に読めてしまう作品です。
  ナイキを立ち上げ、大きく成長させていく歴史が一人称で語られています。
  ビジネスパーソンだけでなく、様々に人が楽しめる一冊です。
  ',
  user_id: 4,
  created_at: 1.day.ago,
  updated_at: 1.day.ago
)

Post.create!(
  post_image: open("#{Rails.root}/db/post_image/image20.jpg"),
  title: '逆ソクラテス',
  author: '伊坂 幸太郎',
  publisher: '集英社',
  genre: 'novel',
  rating: 'int5',
  hours: 'to20',
  purchase_date: '2020-9-20',
  post_content: '伊坂幸太郎の作品は久しぶりに読みましたが、「面白い」の一言に尽きます。
  五篇の短編集となっていて、サクッと読むことができます。
  また、登場人物がユニークで、読んでいて爽快感があります。
  前向きになる作品で、多くの人にお勧めできます。',
  user_id: 1,
  created_at: Time.zone.now,
  updated_at: Time.zone.now
)

# ----------------
# --- コメント ---
# ----------------
10.times do |n|
  postid = 20 - (n * 2)
  Comment.create!(
    user_id: 9,
    post_id: postid,
    comment_content: '面白そうですね。私も読んでみます。',
    created_at: 1.day.ago,
    updated_at: 1.day.ago
  )
end

8.times do |n|
  postid = 20 - n
  Comment.create!(
    user_id: 8,
    post_id: postid,
    comment_content: '感想、参考になります。ありがとうございます。',
    created_at: 5.hour.ago,
    updated_at: 5.hour.ago
  )
end

8.times do |n|
  postid = 20 - (n * 2)
  Comment.create!(
    user_id: 10,
    post_id: postid,
    comment_content: '最近あまり本を読めていませんでしたが、これは読んでみたいと思いました。',
    created_at: 1.hour.ago,
    updated_at: 1.hour.ago
  )
end

6.times do |n|
  postid = 20 - n
  Comment.create!(
    user_id: 7,
    post_id: postid,
    comment_content: '私も読んで投稿したいと思います！',
    created_at: 40.minute.ago,
    updated_at: 40.minute.ago
  )
end

4.times do |n|
  postid = 20 - (n * 3)
  Comment.create!(
    user_id: 11,
    post_id: postid,
    comment_content: 'この作者の本は読んだことがありませんでしたが、読んでみたいと思いました。',
    created_at: 10.minute.ago,
    updated_at: 10.minute.ago
  )
end

5.times do |n|
  postid = 15 - n
  Comment.create!(
    user_id: 2,
    post_id: postid,
    comment_content: '面白そうですね！感想参考になりました。ありがとうございます。',
    created_at: Time.zone.now,
    updated_at: Time.zone.now
  )
end

# --------------
# --- いいね ---
# --------------
10.times do |n|
  postid = 20 - (n * 2)
  Like.create!(
    user_id: 9,
    post_id: postid,
  )
end
10.times do |n|
  postid = 19 - (n * 2)
  Like.create!(
    user_id: 15,
    post_id: postid,
  )
end
10.times do |n|
  postid = 20 - (n * 2)
  Like.create!(
    user_id: 13,
    post_id: postid,
  )
end
10.times do |n|
  postid = 11 - n
  Like.create!(
    user_id: 11,
    post_id: postid,
  )
end
8.times do |n|
  postid = 10 - n
  Like.create!(
    user_id: 12,
    post_id: postid,
  )
end
6.times do |n|
  postid = 20 - ( n * 2)
  Like.create!(
    user_id: 5,
    post_id: postid,
  )
end
5.times do |n|
  postid = 12 - n
  Like.create!(
    user_id: 3,
    post_id: postid,
  )
end
5.times do |n|
  postid = 10 - n
  Like.create!(
    user_id: 6,
    post_id: postid,
  )
end
3.times do |n|
  postid = 19 - (n * 2)
  Like.create!(
    user_id: 1,
    post_id: postid,
  )
end
3.times do |n|
  postid = 20 - (n * 2)
  Like.create!(
    user_id: 2,
    post_id: postid,
  )
end
10.times do |n|
  postid = 20 - n
  Like.create!(
    user_id: 14,
    post_id: postid,
  )
end

# ----------------
# --- フォロー ---
# ----------------
users = User.all
first_user = users.first
second_user = users.second
third_user = users.third
following = users[4..15]
followers = users[3..25]
following.each { |followed| first_user.follow(followed) }
following.each { |followed| second_user.follow(followed) }
following.each { |followed| third_user.follow(followed) }
followers.each { |follower| follower.follow(first_user) }
followers.each { |follower| follower.follow(second_user) }
followers.each { |follower| follower.follow(third_user) }