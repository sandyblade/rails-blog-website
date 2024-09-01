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

class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities, :options => 'ENGINE=InnoDB' do |t|
      t.bigint :user_id, null: false
      t.string :event, limit: 255, null: false
      t.string :description, limit: 255, null: false
      t.timestamps
    end
    add_index :activities, :user_id
    add_index :activities, :event
    add_index :activities, :description
    add_index :activities, :created_at
    add_index :activities, :updated_at
    add_foreign_key :activities, :users, column: :user_id
  end
end
