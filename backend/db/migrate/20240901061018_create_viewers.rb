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

class CreateViewers < ActiveRecord::Migration[7.2]
  def change
    create_table :viewers, :options => 'ENGINE=InnoDB' do |t|
      t.bigint :article_id, null: false
      t.bigint :user_id, null: false
      t.integer :status, :default => 0, :limit => 2
      t.timestamps
    end
    add_index :viewers, :article_id
    add_index :viewers, :user_id
    add_index :viewers, :status
    add_index :viewers, :created_at
    add_index :viewers, :updated_at
    add_foreign_key :viewers, :users, column: :user_id
    add_foreign_key :viewers, :articles, column: :article_id
  end
end
