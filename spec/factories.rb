require 'faker'

FactoryGirl.define do
  factory :user do
    sequence(:login) { Faker::Lorem.characters(10) }
    sequence(:email) { Faker::Lorem.characters(10) + '@' + Faker::Lorem.characters(5) + '.com' }
    sequence(:name) { Faker::Name.name }
    association(:role, factory: [:role, :client_role])
    password 'secret'

    trait :manager do
      after :create do |user|
        user.role = create(:role, :manager_role)
      end
    end
  end

  factory :role do
    trait :admin_role do
      name 'admin'
      title 'Адміністратор'
    end

    trait :manager_role do
      name 'manager'
      title 'Менеджер'
    end

    trait :client_role do
      name 'client'
      title 'Клієнт'
    end

    trait :guest_role do
      name 'guest'
      title 'Гість'
    end

    initialize_with { Role.find_or_create_by(name: name) }
  end

  factory :category do
    sequence(:name) { Faker::Lorem.characters(20) }

    trait :sub do
      sequence(:name) { Faker::Lorem.characters(20) }
      association(:parent, factory: [:category])
    end
  end  

  factory :product do
    sequence(:title) { Faker::Lorem.characters(10) }
    association(:user)
    sequence(:price) { Random.new.rand(1..12) * 1000 }
  end
end
