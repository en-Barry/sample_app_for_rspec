require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context 'タスク編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context 'タスクの詳細ページにアクセス' do
        it 'タスクの詳細情報が表示される' do
          visit task_path(task)
          expect(current_path).to eq task_path(task)
          expect(page).to have_content task.title
        end
      end
      context 'タスクの一覧ページにアクセス' do
        it '全てのユーザーのタスク情報が表示される' do
          task_list = create_list(:task, 3)
          visit tasks_path
          expect(current_path).to eq tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).to have_content task_list[2].title
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Content', with: 'test_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(current_path).to eq '/tasks/1'
          expect(page).to have_content 'Title: test_title'
          expect(page).to have_content 'Content: test_content'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2020/6/1 10:30' 
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成に失敗する' do
          
        end
      end
      context '登録済のタイトルを入力' do
        it 'タスクの新規作成に失敗する' do
          
        end
      end
    end

    describe 'タスクの編集' do
      context 'フォームの入力値が正常' do
        it 'タスクの編集に成功する' do
          
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集に失敗する' do
          
        end
      end
      context '登録済のタイトルを入力' do
        it 'タスクの編集に失敗する' do
          
        end
      end
    end

    describe 'タスクの削除' do
      it 'タスクの削除に成功する' do
        
      end
    end
  end
end
