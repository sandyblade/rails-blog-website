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

class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications, :options => 'ENGINE=InnoDB' do |t|
      t.bigint :user_id, null: false
      t.string :subject, limit: 255, null: false
      t.string :message, limit: 255, null: false
      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :subject
    add_index :notifications, :message
    add_index :notifications, :created_at
    add_index :notifications, :updated_at
    add_foreign_key :notifications, :users, column: :user_id
  end
end
