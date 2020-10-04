require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'タイトル、著者、ユーザIDがある場合、有効であること' do
    post = FactoryBot.build(:post)
    expect(post).to be_valid
  end

  it 'タイトルがnilであれば無効であること' do
    post = FactoryBot.build(:post, title: nil)
    post.valid?
    expect(post.errors[:title]).to include('を入力してください')
  end

  it 'タイトルが100文字以内であれば有効であること' do
    char100 = 'a' * 100
    post = FactoryBot.build(:post, title: char100)
    expect(post).to be_valid
  end

  it 'タイトルが101文字以上であれば無効であること' do
    char101 = 'a' * 101
    post = FactoryBot.build(:post, title: char101)
    post.valid?
    expect(post.errors[:title]).to include('は100文字以内で入力してください')
  end

  it '著者がnilであれば無効であること' do
    post = FactoryBot.build(:post, author: nil)
    post.valid?
    expect(post.errors[:author]).to include('を入力してください')
  end

  it '著者が60文字以内であれば有効であること' do
    char60 = 'a' * 60
    post = FactoryBot.build(:post, author: char60)
    expect(post).to be_valid
  end

  it '著者が61文字以上であれば無効であること' do
    char61 = 'a' * 61
    post = FactoryBot.build(:post, author: char61)
    post.valid?
    expect(post.errors[:author]).to include('は60文字以内で入力してください')
  end

  it '出版社が60文字以内であれば有効であること' do
    char60 = 'a' * 60
    post = FactoryBot.build(:post, publisher: char60)
    expect(post).to be_valid
  end

  it '出版社が61文字以上であれば無効であること' do
    char61 = 'a' * 61
    post = FactoryBot.build(:post, publisher: char61)
    post.valid?
    expect(post.errors[:publisher]).to include('は60文字以内で入力してください')
  end

  it 'ジャンルがnilであれば無効であること' do
    post = FactoryBot.build(:post, genre: nil)
    post.valid?
    expect(post.errors[:genre]).to include('は一覧にありません')
  end

  it 'ジャンルが小説・文学であれば有効であること' do
    post = FactoryBot.build(:post, genre: 'novel')
    expect(post).to be_valid
  end

  it 'ジャンルが自己啓発・ビジネスであれば有効であること' do
    post = FactoryBot.build(:post, genre: 'business')
    expect(post).to be_valid
  end

  it 'ジャンルが教育・教養であれば有効であること' do
    post = FactoryBot.build(:post, genre: 'education')
    expect(post).to be_valid
  end

  it 'ジャンルがアート・エンタメであれば有効であること' do
    post = FactoryBot.build(:post, genre: 'art_ent')
    expect(post).to be_valid
  end

  it 'ジャンルがタレント本であれば有効であること' do
    post = FactoryBot.build(:post, genre: 'celebrity')
    expect(post).to be_valid
  end

  it 'ジャンルが趣味であれば有効であること' do
    post = FactoryBot.build(:post, genre: 'hobby')
    expect(post).to be_valid
  end

  it 'ジャンルが旅行・地理であれば有効であること' do
    post = FactoryBot.build(:post, genre: 'geography')
    expect(post).to be_valid
  end

  it 'ジャンルがこども向けであれば有効であること' do
    post = FactoryBot.build(:post, genre: 'child')
    expect(post).to be_valid
  end

  it 'ジャンルがその他であれば有効であること' do
    post = FactoryBot.build(:post, genre: 'others')
    expect(post).to be_valid
  end

  it '評価がnilであれば無効であること' do
    post = FactoryBot.build(:post, rating: nil)
    post.valid?
    expect(post.errors[:rating]).to include('は一覧にありません')
  end

  it '評価が0.5であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int_5')
    expect(post).to be_valid
  end

  it '評価が1であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int1')
    expect(post).to be_valid
  end

  it '評価が1.5であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int1_5')
    expect(post).to be_valid
  end

  it '評価が2であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int2')
    expect(post).to be_valid
  end

  it '評価が2.5であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int2_5')
    expect(post).to be_valid
  end

  it '評価が3であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int3')
    expect(post).to be_valid
  end

  it '評価が3.5であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int3_5')
    expect(post).to be_valid
  end

  it '評価が4であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int4')
    expect(post).to be_valid
  end

  it '評価が4.5であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int4_5')
    expect(post).to be_valid
  end

  it '評価が5であれば有効であること' do
    post = FactoryBot.build(:post, rating: 'int5')
    expect(post).to be_valid
  end

  it '読書時間がnilであれば無効であること' do
    post = FactoryBot.build(:post, hours: nil)
    post.valid?
    expect(post.errors[:hours]).to include('は一覧にありません')
  end

  it '読書時間が〜10時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to10')
    expect(post).to be_valid
  end

  it '読書時間が10〜20時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to20')
    expect(post).to be_valid
  end

  it '読書時間が20〜30時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to30')
    expect(post).to be_valid
  end

  it '読書時間が30〜40時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to40')
    expect(post).to be_valid
  end

  it '読書時間が40〜50時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to50')
    expect(post).to be_valid
  end

  it '読書時間が50〜70時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to70')
    expect(post).to be_valid
  end

  it '読書時間が70〜100時間であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'to100')
    expect(post).to be_valid
  end

  it '読書時間が100時間以上であれば有効であること' do
    post = FactoryBot.build(:post, hours: 'from100')
    expect(post).to be_valid
  end

  it '購入日がnilであっても有効であること' do
    post = FactoryBot.build(:post, purchase_date: nil)
    expect(post).to be_valid
  end

  it '感想がnilであっても有効であること' do
    post = FactoryBot.build(:post, post_content: nil)
    expect(post).to be_valid
  end

  it '感想が1000文字以内であれば有効であること' do
    char1000 = 'a' * 1000
    post = FactoryBot.build(:post, post_content: char1000)
    expect(post).to be_valid
  end

  it '感想が1001文字以上であれば無効であること' do
    char1001 = 'a' * 1001
    post = FactoryBot.build(:post, post_content: char1001)
    post.valid?
    expect(post.errors[:post_content]).to include('は1000文字以内で入力してください')
  end

  it 'ユーザIDがnilであれば無効であること' do
    post = FactoryBot.build(:post, user_id: nil)
    post.valid?
    expect(post.errors[:user_id]).to include('ユーザIDを取得できませんでした')
  end
end
