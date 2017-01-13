require 'rails_helper'
require 'selenium-webdriver'

describe 'Comment', type: :feature, js: true do
  let(:client) { FactoryGirl.create(:user) }

  let(:comment) { Faker::Lorem.characters(20) }

  let(:overflow_comment) { Faker::Lorem.characters(1200) }

  before(:each) do
    FactoryGirl.create(:product)
    sign_in client
    visit product_path(Product.last)
  end

  it 'correct comment' do
    page.find_by_id('comment_tab').click
    fill_in 'Введіть ваш відгук', with: comment
    click_button 'Відправити'
    expect(page).to have_content 'Коментар успішно добавлений'
  end

  it 'epmty comment' do
    page.find_by_id('comment_tab').click
    click_button 'Відправити'
    expect(page).to have_content 'Заповніть контент коментаря'
  end

  it 'overflow comment' do
    page.find_by_id('comment_tab').click
    fill_in 'Введіть ваш відгук', with: overflow_comment
    click_button 'Відправити'
    expect(page).to have_content 'Максимальна довжина коментаря 1000 символів'
  end

  it 'edit own comment' do
    page.find_by_id('comment_tab').click
    fill_in 'Введіть ваш відгук', with: comment
    click_button 'Відправити'
    
    within('#comments_list') do
      click_link 'Редагувати'
    end  

    fill_in 'Оновлений відгук', with: comment + comment
    click_button 'Оновити'

    expect(page).to have_content comment + comment
  end  

  it 'destroy own comment' do 
    page.find_by_id('comment_tab').click
    fill_in 'Введіть ваш відгук', with: comment
    click_button 'Відправити'

    within('#comments_list') do
      click_link 'Видалити'
    end  

    expect(page).to have_no_content comment
  end  

  context 'when log out' do
    
    before(:each) do 
      FactoryGirl.create(:role, :guest_role)
      sign_out :user 
    end

    it 'create comment and log out' do
      page.find_by_id('comment_tab').click
      fill_in 'Введіть ваш відгук', with: comment
      click_button 'Відправити'
      expect(page).to have_content 'Недостатньо прав для здійснення даної дії'
    end
  end

  context 'when product unpublished' do
    before(:each) { Product.last.update_column(:published, false) }

    it 'create comment in unpublished product' do
      page.find_by_id('comment_tab').click
      fill_in 'Введіть ваш відгук', with: comment
      click_button 'Відправити'
      expect(page).to have_content 'Недостатньо прав для здійснення даної дії'
    end
  end
end
