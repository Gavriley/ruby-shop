# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(name: 'admin', title: 'Адміністратор')
Role.create(name: 'manager', title: 'Менеджер')
Role.create(name: 'client', title: 'Клієнт')
Role.create(name: 'guest', title: 'Гість')

User.create(login: 'Kasumi', email: 'gavrileypetro@gmail.com',
            password: 'qwerty', name: 'Kami', role_id: 1)

args = Array.new

5.times { args << { name: 'Lorem ipsum dolor sit amet', parent_id: 0 } }

categories = Category.create(args)

args_nested = Array.new

categories.each { |category| 7.times { args_nested << {
name: 'Lorem ipsum dolor sit amet', parent_id: category.id } } }

Category.create(args_nested)

# Product.delete_all

12.times do
  Product.create(
    title: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit',
    user_id: 1,
    price: Random.new.rand(10..99) * 100,
    description: %(<p>Lorem ipsum dolor: </p>
    <ul>
      <li>Lorem ipsum dolor sit amet</li>
      <li>Lorem ipsum dolor sit amet</li>
      <li>Lorem ipsum dolor sit amet</li>
      <li>Lorem ipsum dolor sit amet</li>
      <li>Lorem ipsum dolor sit amet</li>
      <li>Lorem ipsum dolor sit amet</li>
    </ul>)
  )
end