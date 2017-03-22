require 'rails_helper'
require 'selenium-webdriver'

describe 'users', type: :feature, js: true do
  before :each do
    sign_in FactoryGirl.create(:user, :admin)
  end  

  context 'create new user' do
    before :each do
      visit new_admin_user_path
    end  

    it 'create correct user' do
      fill_in 'Введіть логін', with: Faker::Lorem.characters(10)
      fill_in 'Введіть e-mail', with: Faker::Lorem.characters(10) + '@' + Faker::Lorem.characters(5) + '.com'
      fill_in 'Введіть імя', with: Faker::Lorem.characters(10)
      fill_in 'Введіть пароль', with: Faker::Lorem.characters(10)

      click_button 'Створити'

      expect(page).to have_content 'Користувач успішно створений'
    end

    it 'incorrect login' do
      fill_in 'Введіть логін', with: '!@#login'
      fill_in 'Введіть e-mail', with: Faker::Lorem.characters(10) + '@' + Faker::Lorem.characters(5) + '.com'
      fill_in 'Введіть імя', with: Faker::Lorem.characters(10)
      fill_in 'Введіть пароль', with: Faker::Lorem.characters(10)

      click_button 'Створити'

      expect(page).to have_content 'В логіні присутні недопустимі символи'
    end  

    it 'overflow login' do
      fill_in 'Введіть логін', with: Faker::Lorem.characters(1000)
      fill_in 'Введіть e-mail', with: Faker::Lorem.characters(10) + '@' + Faker::Lorem.characters(5) + '.com'
      fill_in 'Введіть імя', with: Faker::Lorem.characters(10)
      fill_in 'Введіть пароль', with: Faker::Lorem.characters(10)

      click_button 'Створити'

      expect(page).to have_content 'Максимальний розмір логіна 25 символів'
    end

    it 'overflow name' do
      fill_in 'Введіть логін', with: Faker::Lorem.characters(10)
      fill_in 'Введіть e-mail', with: Faker::Lorem.characters(10) + '@' + Faker::Lorem.characters(5) + '.com'
      fill_in 'Введіть імя', with: Faker::Lorem.characters(1000)
      fill_in 'Введіть пароль', with: Faker::Lorem.characters(10)

      click_button 'Створити'

      expect(page).to have_content 'Максимальний розмір імені 50 символів'
    end
  end  
  
  context 'with users list' do
    before :each do
      FactoryGirl.create_list(:user, 3)
      visit admin_users_path
    end  

    it 'show all users' do
      User.all.each do |user|
        expect(page).to have_content "Логін: #{user.login}"
        expect(page).to have_content "E-mail: #{user.email}"
        expect(page).to have_content "Імя: #{user.name}"
      end  
    end 

    it 'edit last user' do
      find('a', text: 'Редагувати', match: :prefer_exact).click

      last_user = User.last

      old_login = last_user.login
      old_email = last_user.email
      old_name = last_user.name

      new_login = Faker::Lorem.characters(10)
      new_email = Faker::Lorem.characters(10) + '@' + Faker::Lorem.characters(5) + '.com'
      new_name = Faker::Lorem.characters(10)

      fill_in 'Введіть логін', with: new_login
      fill_in 'Введіть e-mail', with: new_email
      fill_in 'Введіть імя', with: new_name

      click_button 'Змінити'

      expect(page).to have_content 'Користувач успішно оновлений'

      visit admin_users_path

      expect(page).to have_no_content old_login
      expect(page).to have_no_content old_email
      expect(page).to have_no_content old_name

      expect(page).to have_content new_login
      expect(page).to have_content new_email
      expect(page).to have_content new_name
    end 

    it 'edit last user password' do
      find('a', text: 'Редагувати', match: :prefer_exact).click
      fill_in 'Введіть пароль', with: Faker::Lorem.characters(10)
      click_button 'Змінити'
      expect(page).to have_content 'Користувач успішно оновлений'
    end  

    it 'delete last user' do
      last_user = User.last

      old_login = last_user.login
      old_email = last_user.email
      old_name = last_user.name
      
      find('a', text: 'Видалити', match: :prefer_exact).click

      sleep 0.2
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_no_content old_login
      expect(page).to have_no_content old_email
      expect(page).to have_no_content old_name
    end 

    it 'find first user' do
      first_user = User.first.login
      fill_in 'Найти кристувача', with: first_user
      expect(page).to have_content "Логін: #{first_user}"
      expect(page).to have_no_content "Логін: #{User.last.login}"
    end 
  end  
end  