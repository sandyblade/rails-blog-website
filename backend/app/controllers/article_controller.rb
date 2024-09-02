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

require 'json/ext'
require 'faker'

class ArticleController < ApplicationController

    before_action :authorize_request, except: %i[list]

    def list

        user = @current_user
        page = params.has_key?(:page) ? params[:page] : 1
        limit = params.has_key?(:limit) ? params[:limit] : 10
        total = Article.where("status = 1").count
        offset = ((page-1)*limit)
        order_by = params.has_key?(:order) ? params[:order] : 'id'
        order_dir = params.has_key?(:dir) ? params[:dir] : 'desc'
        search = params.has_key?(:search) ? params[:search] : nil
        list = Article.where("status = 1")

        if(search != nil)
            search_key = "%#{search}%"
            list = list.where("title LIKE ? OR description LIKE  ? OR content LIKE  ? OR categories LIKE  ? OR tags LIKE  ?", search_key, search_key, search_key, search_key, search_key)
        end

        list = list.limit(limit).offset(offset).order(order_by+" "+order_dir)
        response = { message: "ok", status: true, data: { total: total, list: list } }
        render :json => response, :status => :ok
        return
    end

    def user

        user = @current_user
        page = params.has_key?(:page) ? params[:page] : 1
        limit = params.has_key?(:limit) ? params[:limit] : 10
        total = Article.where("user_id = ?", user.id).count
        offset = ((page-1)*limit)
        order_by = params.has_key?(:order) ? params[:order] : 'id'
        order_dir = params.has_key?(:dir) ? params[:dir] : 'desc'
        search = params.has_key?(:search) ? params[:search] : nil
        list = Article.where("status = 1")

        if(search != nil)
            search_key = "%#{search}%"
            list = list.where("title LIKE ? OR description LIKE  ? OR content LIKE  ? OR categories LIKE  ? OR tags LIKE  ?", search_key, search_key, search_key, search_key, search_key)
        end

        list = list.limit(limit).offset(offset).order(order_by+" "+order_dir)
        response = { message: "ok", status: true, data: { total: total, list: list } }
        render :json => response, :status => :ok
        return
    end

    def read

        slug = params[:slug]
        user = @current_user
        model = Article.where('slug = ? ', slug).first
       
        if(model == nil)
            payload = {
                message: "The article with slug "+slug+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(model.user_id != user.id)
            check_viewer = Viewer.where('article_id = ? AND user_id = ?', model.id, user.id).count
            if (check_viewer == 0)
                
                viewer = Viewer.new(:user_id => user.id, :article_id=> model.id)
                viewer.save!

                activity = Activity.new(
                    :user_id => user.id,
                    :event=> "Read Article",
                    :description => "The user "+user.email+" add read your article with title `"+model.title+"`."
                )
                activity.save!

                total_viewer = Viewer.where('article_id = ?', model.id).count
                model.total_viewer = total_viewer
                model.save()

            end
        end

        response = {
            message: "ok",
            status: true,
            data: model
        }
        render :json => response, :status => :ok
        return

    end

    def create

        user = @current_user

        if(!params.has_key?(:title))
            payload = {
                message: "The field 'title' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:description))
            payload = {
                message: "The field 'description' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:content))
            payload = {
                message: "The field 'content' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:status))
            payload = {
                message: "The field 'status' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        check_title = Article.find_by("title = ?", params[:title])
        if(check_title != nil)
            payload = {
                message: "The title has already been taken.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        model = Article.new
        model.user_id = user.id
        model.title = params[:title]
        model.slug = params[:title].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        model.status = params[:status].to_i
        model.content = params[:content]
        model.description = params[:description]
        model.categories = params.has_key?(:categories) && params[:categories].length > 0 ? params[:categories].to_json : nil
        model.tags = params.has_key?(:tags) && params[:tags].length > 0 ? params[:categories].to_json : nil
        model.save()

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Create Article",
            :description => "The user create article with title "+model.title
        )
        activity.save!

        response = {
            message: "Yor record has been created !!",
            status: true,
            data: model
        }
        render :json => response, :status => :ok
        return

    end

    def update

        id = params[:id]
        model = Article.where('id = id ', id).first
        user = @current_user

        if(model == nil)
            payload = {
                message: "The article with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:title))
            payload = {
                message: "The field 'title' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:description))
            payload = {
                message: "The field 'description' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:content))
            payload = {
                message: "The field 'content' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:status))
            payload = {
                message: "The field 'status' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        check_title = Article.find_by("title = ? AND id != ?", params[:title],  id)
        if(check_title != nil)
            payload = {
                message: "The title has already been taken.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        model.title = params[:title]
        model.slug = params[:title].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        model.status = params[:status].to_i
        model.content = params[:content]
        model.description = params[:description]
        model.categories = params.has_key?(:categories) && params[:categories].length > 0 ? params[:categories].to_json : nil
        model.tags = params.has_key?(:tags) && params[:tags].length > 0 ? params[:categories].to_json : nil
        model.save()

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Edit Article",
            :description => "The user edited article with title "+model.title
        )
        activity.save!

        response = {
            message: "Yor record has been updated !!",
            status: true,
            data: model
        }
        render :json => response, :status => :ok
        return

    end

    def remove

        id = params[:id]
        user = @current_user
        model = Article.where('id = ? AND user_id = ? ', id, user.id).first

        if(model == nil)
            payload = {
                message: "The record with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        Viewer.find_by("article_id = ? ", id).destroy

        model.destroy

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Delete Article",
            :description => "The user delete article with title "+model.title
        )
        activity.save!

        response = {
            message: "ok",
            status: true,
            data: model
        }
        render :json => response, :status => :ok
        return

    end

    def upload

        id = params[:id]
        user = @current_user
        article = Article.where('id = ? AND id = ? ', id).first

        if(article == nil)
            payload = {
                message: "The record with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        Dir.mkdir(Rails.root.join('storage', 'uploads')) unless Dir.exist?(Rails.root.join('storage', 'uploads'))

        uploaded_io = params[:file]
        file_uuid = SecureRandom.uuid
        file_name = file_uuid.to_s
        # Moving the file to some safe place; as tmp files will be flushed timely
        File.open(Rails.root.join('storage', 'uploads', file_name), 'wb') do |file|
          file.write(uploaded_io.read)
        end

        if(article.image)
            file_exist = Rails.root.join('storage', article.image)
            File.delete(file_exist) if File.exist?(file_exist)
        end

        article.image = "uploads/"+file_uuid
        article.save()

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Upload Image",
            :description => "Upload article image"
        )
        activity.save!

        response = {
            message: "Yor file has been uploaded !!",
            status: true,
            data: "uploads/"+file_uuid
        }
        render :json => response, :status => :ok
        return

    end

    def word
        result = []
        max = params.has_key?(:max) ? params[:max].to_i : 10
        for i in 1..max do 
            index = i - 1
            result[index] = Faker::Lorem.sentence(word_count: 2).capitalize
        end
        response = {
            message: "ok",
            status: true,
            data: result.sort
        }
        render :json => response, :status => :ok
        return
    end

end
