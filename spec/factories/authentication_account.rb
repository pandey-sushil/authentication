FactoryBot.define do
  factory :authentication_account, class: 'Authentication::Account' do
    email                 { Faker::Internet.email }
    encrypted_password    { Faker::Internet.password }
    roles                 {[]}
  end
end
