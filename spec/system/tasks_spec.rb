require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }
  let(:other_task) { create(:task, user: user) }

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
      before { visit new_task_path }

      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する' do
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
          fill_in 'Title', with: nil
          fill_in 'Content', with: 'test_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content "Title can't be blank"
        end
      end
      context '登録済のタイトルを入力' do
        it 'タスクの新規作成に失敗する' do
          fill_in 'Title', with: task.title
          fill_in 'Content', with: 'test_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
          expect(page).to have_content "Title has already been taken"
        end
      end
    end

    describe 'タスクの編集' do
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        it 'タスクの編集に成功する' do
          fill_in 'Title', with: 'update_title'
          fill_in 'Content', with: 'update_content'
          select 'done', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Update Task'
          expect(current_path).to eq '/tasks/1'
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'Title: update_title'
          expect(page).to have_content 'Status: done'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集に失敗する' do
          fill_in 'Title', with: nil
          fill_in 'Content', with: 'update_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
        end
      end
      context '登録済のタイトルを入力' do
        it 'タスクの編集に失敗する' do
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'update_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Update Task'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content 'Title has already been taken'
        end
      end
    end

    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }
      
      it 'タスクの削除に成功する' do
        visit tasks_path
        click_link 'Destroy'
        expect(page.accept_confirm).to have_content 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
