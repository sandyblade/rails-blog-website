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

class CommentController < ApplicationController

    before_action :authorize_request, except: %i[list]

    def list

        id = params[:id]
        article = Article.where('id = ? ', id).first

        if(article == nil)
            payload = {
                message: "The article with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        data = build_tree(id, nil)
        response = {
            message: "ok",
            status: true,
            data: data
        }
        render :json => response, :status => :ok

    end

    def create

        id = params[:id]
        article = Article.where('id = ? ', id).first
        user = @current_user

        if(article == nil)
            payload = {
                message: "The article with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:comment))
            payload = {
                message: "The field 'comment' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        comment = Comment.new(
            :article_id => id,
            :user_id => user.id,
            :parent_id => nil,
            :comment=> params[:comment]
        )
        comment.save!

        event = "Reply Comment" 
        description = "reply"

        if(!params.has_key?(:parent_id))
            event = "Create Comment"
            description = "add"
        end

        activity = Activity.new(
            :user_id => user.id,
            :event=> event,
            :description => "The user "+description+" comment of article with title "+article.title
        )
        activity.save!

        if (user.id != article.user_id)
            notification = Notification.new(
                :user_id => user.id,
                :subject=> event,
                :message => "The user "+user.email+" "+description+" comment of article with title "+article.title
            )
            notification.save!
        end
       
        
        total_comment = Comment.where('article_id = ?', article.id).count
        article.total_comment = total_comment
        article.save()

        response = {
            message: "ok",
            status: true,
            data: comment
        }
        render :json => response, :status => :ok
        return

    end

    def remove

        id = params[:id]
        user = @current_user
        comment = Comment.where('id = ? AND user_id = ?', id, user.id).first
       
        if(comment == nil)
            payload = {
                message: "The comment with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        article = Article.where('id = ?', comment.article_id).first
        comment.destroy

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Delete Comment",
            :description => "The user delete comment with title "+article.title
        )
        activity.save!

        total_comment = Comment.where('article_id = ?', article.id).count
        article.total_comment = total_comment
        article.save()

        response = {
            message: "ok",
            status: true,
            data: comment
        }
        render :json => response, :status => :ok
        return

    end

    def build_tree(article_id, parent_id)

        result = Array[]
        comments = Comment.select("
            comments.*,
            users.first_name,
            users.last_name,
            users.gender,
            users.image,
            users.about_me
        ")
        .joins("INNER JOIN users ON users.id = comments.user_id")
        .order("comments.id desc")

        if(parent_id == nil)
            comments = comments.where("comments.article_id = ? AND comments.parent_id IS NULL ", article_id)
        else
            comments = comments.where("comments.article_id = ? AND comments.parent_id = ? ", article_id, parent_id)
        end

        comments.each do |row|
           comment = {
              id: row.id,
              parent_id: row.parent_id,
              comment: row.comment,
              created_at: row.created_at,
              first_name: row.first_name,
              last_name: row.last_name,
              gender: row.gender,
              image: row.image,
              about_me: row.about_me
           }
           comment["children"] = build_tree(article_id, row.id)
           result.push(comment)
        end

        return result

    end

end
