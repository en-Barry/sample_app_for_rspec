require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:task) { build(:task) }
  
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規登録が成功する' do
          visit sign_up_path
          fill_in 'Email', with: 'tester@example.com'
          fill_in 'Password', with: '0000'
          fill_in 'Password confirmation', with: '0000'
          click_button 'SignUp'
          expect(current_path).to eq login_path
          expect(page).to have_content "User was successfully created."
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規登録が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: nil
          fill_in 'Password', with: '0000'
          fill_in 'Password confirmation', with: '0000'
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規登録が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: '0000'
          fill_in 'Password confirmation', with: '0000'
          click_button 'SignUp'
          expect(current_path).to eq users_path
          expect(page).to have_content "Email has already been taken"
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'ページへのアクセスが失敗する' do
          visit user_path(:user)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常'do
        it 'ユーザーの編集が成功する' do
          sign_in_as user
          visit edit_user_path(user.id)
          fill_in 'Email', with: 'tester@example.com'
          fill_in 'Password', with: 'xxxx'
          fill_in 'Password confirmation', with: 'xxxx'
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content "User was successfully updated."
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          sign_in_as user
          visit edit_user_path(user.id)
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'xxxx'
          fill_in 'Password confirmation', with: 'xxxx'
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する'  do
          sign_in_as user
          visit edit_user_path(user.id)
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'xxxx'
          fill_in 'Password confirmation', with: 'xxxx'
          click_button 'Update'
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content "Email has already been taken"
        end
      end
      context '他ユーザーの編集ページにアクセスする' do
        it 'ページへのアクセスが失敗する' do
          sign_in_as user
          visit edit_user_path(other_user.id)
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content "Forbidden access."
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
          sign_in_as user
          visit new_task_path
          fill_in "Title", with: task.title
          fill_in "Content", with: task.content
          select task.status, from: "Status"
          click_button "Create Task"
          expect(current_path).to eq task_path(task.id)
          expect(page).to have_content "Task was successfully created."
          expect(page).to have_content task.title
        end
      end
    end
  end
end
