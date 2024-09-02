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

class NotificationController < ApplicationController

    before_action :authorize_request

    def list

        user = @current_user
        page = params.has_key?(:page) ? params[:page] : 1
        limit = params.has_key?(:limit) ? params[:limit] : 10
        total = Notification.where("user_id = ?", user.id).count
        offset = ((page-1)*limit)
        order_by = params.has_key?(:order) ? params[:order] : 'id'
        order_dir = params.has_key?(:dir) ? params[:dir] : 'desc'
        search = params.has_key?(:search) ? params[:search] : nil
        list = Notification.where("user_id = ?", user.id)

        if(search != nil)
            search_key = "%#{search}%"
            list = list.where("subject LIKE ? OR message LIKE ?", search_key, search_key)
        end

        list = list.limit(limit).offset(offset).order(order_by+" "+order_dir)
        response = { message: "ok", status: true, data: { total: total, list: list } }
        render :json => response, :status => :ok
        return
    end

    def read

        id = params[:id]
        user = @current_user
        model = Notification.where('id = ? AND user_id = ? ', id, user.id).first

        if(model == nil)
            payload = {
                message: "The record with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        response = {
            message: "ok",
            status: true,
            data: model
        }
        render :json => response, :status => :ok
        return

    end

    
    def remove

        id = params[:id]
        user = @current_user
        model = Notification.where('id = ? AND user_id = ? ', id, user.id).first

        if(model == nil)
            payload = {
                message: "The record with id "+id+" was not found in our record !!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        model.destroy

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Delete Notification",
            :description => "The user delete notification with subject "+model.subject
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

end
