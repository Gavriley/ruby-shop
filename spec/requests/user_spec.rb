require 'rails_helper'
require 'selenium-webdriver'

describe 'User', type: :feature, js: true do
  before(:each) do 
    FactoryGirl.create(:role, :guest_role)
    FactoryGirl.create(:role, :client_role)
    visit new_user_registration_path
  end  

  it 'registration correct user' do 
    fill_in 'Введіть логін', with: 'user'
    fill_in 'Введіть e-mail', with: 'user@exaple.com'
    fill_in 'Введіть імя', with: 'name'
    fill_in 'Введіть пароль', with: 'qwerty'
    fill_in 'Повторіть пароль', with: 'qwerty'

    within '#file_block' do
      page.attach_file('avatar', File.absolute_path('./spec/fixtures/test.jpg'), visible: false)
    end
    
    click_button 'Зареєструватись'

    expect(page).to have_content "Ласкаво просимо! Ви успішно зареєструвалися."
  end  

  it 'incorrect login' do
    fill_in 'Введіть логін', with: 'user$!'
    fill_in 'Введіть e-mail', with: 'user@exaple.com'
    fill_in 'Введіть імя', with: 'name'
    fill_in 'Введіть пароль', with: 'qwerty'
    fill_in 'Повторіть пароль', with: 'qwerty'
    click_button 'Зареєструватись'

    expect(page).to have_content "В логіні присутні недопустимі символи"
  end  

  it 'delete avatar' do
    fill_in 'Введіть логін', with: 'user'
    fill_in 'Введіть e-mail', with: 'user@exaple.com'
    fill_in 'Введіть імя', with: 'name'
    fill_in 'Введіть пароль', with: 'qwerty'
    fill_in 'Повторіть пароль', with: 'qwerty'

    within '#file_block' do
      page.attach_file('avatar', File.absolute_path('./spec/fixtures/test.jpg'), visible: false)
    end

    click_button 'Зареєструватись'
    expect(page).to have_content "Ласкаво просимо! Ви успішно зареєструвалися."
    click_link 'Видалити аватар'
    fill_in 'Введіть поточний пароль', with: 'qwerty'
    click_button 'Редагувати'
    expect(page).to have_content "Ваш обліковий запис змінено."
    expect(page).to have_content "Виберіть аватар"
  end  

  it 'update user without current password' do
    fill_in 'Введіть логін', with: 'user'
    fill_in 'Введіть e-mail', with: 'user@exaple.com'
    fill_in 'Введіть імя', with: 'name'
    fill_in 'Введіть пароль', with: 'qwerty'
    fill_in 'Повторіть пароль', with: 'qwerty'

    within '#file_block' do
      page.attach_file('avatar', File.absolute_path('./spec/fixtures/test.jpg'), visible: false)
    end

    click_button 'Зареєструватись'
    expect(page).to have_content "Ласкаво просимо! Ви успішно зареєструвалися."
    fill_in 'Введіть логін', with: 'another_user'
    click_button 'Редагувати'
    expect(page).to have_content "поле поточний пароль повинне бути заповнене"
  end  

  context 'upload avatar' do
    it 'overflow size' do
      within '#file_block' do
        page.attach_file('avatar', File.absolute_path('./spec/fixtures/overflow.jpg'), visible: false)
      end

      expect(page).to have_content 'Максимальний розмір аватару 1 мегабайт'
    end  

    it 'incorrect format' do
      within '#file_block' do
        page.attach_file('avatar', File.absolute_path('./spec/fixtures/text.txt'), visible: false)
      end

      expect(page).to have_content 'Некоректний формат аватару'
    end  

    it 'correct avatar' do
      within '#file_block' do
        page.attach_file('avatar', File.absolute_path('./spec/fixtures/test.jpg'), visible: false)
      end

      expect(page).to have_no_content 'Максимальний розмір аватару 1 мегабайт'
      expect(page).to have_no_content 'Некоректний формат аватару'
    end  
  end  
end  