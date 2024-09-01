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

class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles, :options => 'ENGINE=InnoDB' do |t|
      t.bigint :user_id, null: false
      t.string :image, limit: 191, null: true
      t.string :slug, limit: 255, null: false
      t.string :title, limit: 255, null: false
      t.text :description,  null: true
      t.text :content, limit: 4294967295, null: true
      t.text :categories, limit: 4294967295, null: true
      t.text :tags, limit: 4294967295, null: true
      t.integer :total_viewer, :default => 0
      t.integer :total_comment, :default => 0
      t.integer :status, :default => 0, :limit => 2
      t.timestamps
    end
    add_index :articles, :user_id
    add_index :articles, :image
    add_index :articles, :slug
    add_index :articles, :title
    add_index :articles, :total_viewer
    add_index :articles, :total_comment
    add_index :articles, :status
    add_index :articles, :created_at
    add_index :articles, :updated_at
    add_foreign_key :articles, :users, column: :user_id
  end
end
