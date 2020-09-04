require 'rails_helper'

RSpec.describe User, type: :model do

  it "ニックネーム、メール、パスワードがある場合、有効であること" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "ニックネームがnilであれば無効であること" do
    user = FactoryBot.build(:user, nickname: nil)
    user.valid?
    expect(user.errors[:nickname]).to include("を入力してください")
  end

  it "ニックネーム50文字であれば有効であること" do
    char50 = "a" * 50
    user = FactoryBot.build(:user, nickname: char50 )
    expect(user).to be_valid
  end

  it "ニックネーム51文字であれば無効であること" do
    char51 = "a" * 51
    user = FactoryBot.build(:user, nickname: char51 )
    user.valid?
    expect(user.errors[:nickname]).to include("は50文字以内で入力してください")
  end

  it "メールアドレスがnilであれば無効であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end
  
  it "重複したメールアドレスは無効であること" do
    FactoryBot.create(:user, email: "testuser@example.com")
    user = FactoryBot.build(:user, email: "testuser@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end
  
  it "パスワードがnilであれば無効であること" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "パスワードが5文字以下なら無効であること" do
    char5 = "a" * 5
    user = FactoryBot.build(:user, password: char5, password_confirmation: char5 )
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end

  it "パスワードが6文字以上なら有効であること" do
    char6 = "a" * 6
    user = FactoryBot.build(:user, password: char6, password_confirmation: char6 )
    expect(user).to be_valid
  end

  it "パスワードが一致しなければ無効であること" do
    user = FactoryBot.build(:user, password: "password", password_confirmation: "abcdefgh" )
    user.valid?
    expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
  end

end
