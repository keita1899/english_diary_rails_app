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
end
