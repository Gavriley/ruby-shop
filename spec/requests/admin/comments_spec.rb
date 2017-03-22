require 'rails_helper'
require 'selenium-webdriver'

describe 'comments', type: :feature, js: true do
  before :each do
    sign_in FactoryGirl.create(:user, :admin)
    FactoryGirl.create_list(:comment, 3)

    visit admin_comments_path
  end
  
  it 'show all commments' do   
    Comment.all.each do |comment|
      expect(page).to have_content "Продукт: #{comment.product.title}"
      expect(page).to have_content "Автор: #{comment.user.login}"
      expect(page).to have_content comment.content
    end  
  end  

  it 'edit last comment' do
    last_content = Comment.last.content
    find('a', text: 'Редагувати', match: :prefer_exact).click
    new_content = Faker::Lorem.characters(30)

    within '#modal' do
      fill_in 'Введіть відгук', with: new_content
      click_button 'Оновити відгук'
    end  
    
    expect(page).to have_no_content last_content
    expect(page).to have_content new_content
  end 

  it 'destroy last comment' do
    last_content = Comment.last.content
    find('a', text: 'Видалити', match: :prefer_exact).click

    expect(page).to have_no_content last_content
  end 
end  