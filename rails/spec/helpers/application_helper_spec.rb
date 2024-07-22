require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#page_title' do
    let(:base_title) { 'English Diary' }

    context 'タイトルが空の場合' do
      it 'デフォルトのタイトルを返す' do
        expect(helper.page_title('')).to eq(base_title)
      end
    end

    context 'タイトルが空でない場合' do
      it 'タイトルとデフォルトのタイトルを返す' do
        expect(helper.page_title('Test')).to eq('Test | English Diary')
      end
    end
  end

  describe '#input_error_class' do
    let(:user_with_errors) { User.new.tap {|user| user.errors.add(:name, 'is invalid') } }
    let(:user_without_errors) { User.new }

    it 'エラーがあるときinput-errorを返す' do
      expect(helper.input_error_class(user_with_errors, :name)).to eq('input-error')
    end

    it 'エラーがないときはnilを返す' do
      expect(helper.input_error_class(user_without_errors, :name)).to be_nil
    end
  end

  describe '#flash_class' do
    it 'レベルがnoticeのときはalert-infoを返す' do
      expect(helper.flash_class('notice')).to eq('alert-info')
    end

    it 'レベルがalertのときはalert-errorを返す' do
      expect(helper.flash_class('alert')).to eq('alert-error')
    end

    it 'その他のレベルのときはalertを返す' do
      expect(helper.flash_class('warning')).to eq('alert')
      expect(helper.flash_class('success')).to eq('alert')
      expect(helper.flash_class('')).to eq('alert')
    end
  end
end
