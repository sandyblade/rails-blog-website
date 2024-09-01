=begin
 * This file is part of the Sandy Andryanto Blog Application.
 *
 * @author     Sandy Andryanto <sandy.andryanto.blade@gmail.com>
 * @copyright  2024
 *
 * For the full copyright and license information,
 * please view the LICENSE.md file that was distributed
 * with this source code.
=end

require 'faker'

def create_user()

    total_user = User.count
    if total_user === 0

        for i in 1..10 do
        
            gender = rand(1..2)
            email = Faker::Internet.email

            first_name = Faker::Name.male_first_name
            last_name = Faker::Name.last_name
            gender_index = "undefined"

            if gender === 1
                gender_index = "M"
            else
                gender_index = "F"
            end
            
            user = User.new(
                :email => email,
                :password=> "P@ssw0rd!123",
                :phone=> Faker::PhoneNumber.cell_phone,
                :first_name=> first_name,
                :last_name=> last_name,
                :gender=> gender_index,
                :facebook=> Faker::Internet.username,
                :twitter=> Faker::Internet.username,
                :instagram=> Faker::Internet.username,
                :linked_in=> Faker::Internet.username,
                :job_title=> Faker::Job.title,
                :address=> Faker::Address.full_address,
                :about_me=> Faker::Lorem.paragraph,
                :country=> Faker::Address.country,
                :confirmed=> 1
            )
            user.save!
    
        end

    end
    
end

create_user()