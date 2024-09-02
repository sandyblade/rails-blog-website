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

class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments, :options => 'ENGINE=InnoDB' do |t|
      t.bigint :parent_id, null: true
      t.bigint :article_id, null: false
      t.bigint :user_id, null: false
      t.text :comment, limit: 4294967295, null: false
      t.timestamps
    end
    add_index :comments, :parent_id
    add_index :comments, :article_id
    add_index :comments, :user_id
    add_index :comments, :created_at
    add_index :comments, :updated_at
    add_foreign_key :comments, :users, column: :user_id
    add_foreign_key :comments, :articles, column: :article_id
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
