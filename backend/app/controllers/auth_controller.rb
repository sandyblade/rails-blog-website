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

class AuthController < ApplicationController

    before_action :authorize_request, except: %i[login register confirm forgot_password reset_password]

    def login

        if(!params.has_key?(:email))
            payload = {
                message: "The field 'email' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        if(!params.has_key?(:password))
            payload = {
                message: "The field 'password' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end

        cek_user  = User.find_by_email(params[:email])
        if(cek_user == nil)
            payload = {
                message: "These credentials do not match our records.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :unauthorized
            return
        end

        if(cek_user.confirmed.to_i == 0)
            payload = {
                message: "You need to confirm your account. We have sent you an activation code, please check your email.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :unauthorized
            return
        end

        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])

            activity = Activity.new(
                :user_id => @user.id,
                :event=> "Sign In",
                :description => "Sign in to application"
            )
            activity.save!

            token = JsonWebToken.encode(user_id: @user.id)
            time = Time.now.utc + 24.hours.to_i
            render json: { token: token, exp: time }, status: :ok
            return
        end 

        response = {
            message: "Incorrect password please try again !!",
            status: false,
            data: nil
        }
        render :json => response, :status => :unauthorized
        return

    end

    def register

        if(!params.has_key?(:email))
            payload = {
                message: "The field 'email' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
    
        if(!params.has_key?(:password))
            payload = {
                message: "The field 'password' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
        if(!params.has_key?(:password_confirm))
            payload = {
                message: "The field 'password_confirm' can not be empty!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
        email = params[:email]
        password = params[:password]
        password_confirm = params[:password_confirm]
        user_by_email  = User.find_by_email(params[:email])

        if(password.length < 8)
            payload = {
                message: "The password must be at least 8 characters.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
        if(password != password_confirm)
            payload = {
                message: "The password confirmation does not match.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
        if(user_by_email != nil)
            payload = {
                message: "The email has already been taken.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
       
        user = User.new(
            :email => email,
            :password=> password,
            :confirmed => 1,
            :confirm_token=>nil
        )
        user.save!

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Sign Up",
            :description => "Register new user account"
        )
        activity.save!
    
        payload = {
            message: "You need to confirm your account. We have sent you an activation code, please check your email.!",
            status: true,
            data: nil
        }
        render :json => payload, :status => :ok

    end

    def confirm

        token = params[:token]

        user  = User.find_by("confirm_token = ? AND confirmed = 0", params[:token])
        if(user == nil)
            payload = {
                message: "We can't find a user with that  token is invalid.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :unauthorized
            return
        end

        user.confirmed = 1
        user.confirm_token = nil
        user.save()

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Email Verification",
            :description => "Confirm new member registration account"
        )
        activity.save!

        payload = {
            message: "Your e-mail is verified. You can now login.",
            status: true,
            data: nil
        }
        render :json => payload, :status => :ok
        return

    end

    def forgot_password

        if(!params.has_key?(:email))
            payload = {
              message: "The field 'email' can not be empty!",
              status: false,
              data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
        token = Faker::Internet.uuid
        user  = User.find_by_email(params[:email])
        if(user == nil)
            payload = {
                message: "We can't find a user with that e-mail address.!",
                status: false,
                data: nil
            }
            render :json => payload, :status => :bad_request
            return
        end
    
        user.reset_token = token
        user.save()

        activity = Activity.new(
            :user_id => user.id,
            :event=> "Forgot Password",
            :description => "Request reset password link"
        )
        activity.save!
    
        payload = {
            message: "We have e-mailed your password reset link!",
            status: true,
            data: {
                token: token
            }
        }
        render :json => payload, :status => :ok
        return

    end

    def reset_password

      token = params[:token]

      if(!params.has_key?(:email))
        payload = {
          message: "The field 'email' can not be empty!",
          status: false,
          data: nil
        }
        render :json => payload, :status => :bad_request
        return
      end

      if(!params.has_key?(:password))
        payload = {
          message: "The field 'password' can not be empty!",
          status: false,
          data: nil
        }
        render :json => payload, :status => :bad_request
        return
      end

      if(!params.has_key?(:password_confirm))
        payload = {
          message: "The field 'password_confirm' can not be empty!",
          status: false,
          data: nil
        }
        render :json => payload, :status => :bad_request
        return
      end

      email = params[:email]
      password = params[:password]
      password_confirm = params[:password_confirm]

      if(password.length < 8)
        payload = {
          message: "The password must be at least 8 characters.!",
          status: false,
          data: nil
        }
        render :json => payload, :status => :bad_request
        return
      end

      if(password != password_confirm)
        payload = {
          message: "The password confirmation does not match.!",
          status: false,
          data: nil
        }
        render :json => payload, :status => :bad_request
        return
      end

      user  = User.find_by("reset_token = ? AND email = ?", params[:token], params[:email])
      if(user == nil)
        payload = {
          message: "We can't find a user with that e-mail address or password reset token is invalid.!",
          status: false,
          data: nil
        }
        render :json => payload, :status => :unauthorized
        return
      end

      user.reset_token = nil
      user.password = password
      user.save()

      activity = Activity.new(
        :user_id => user.id,
        :event=> "Reset Password",
        :description => "Reset account password"
        )
       activity.save!

      payload = {
        message: "Your password has been reset!",
        status: true,
        data: nil
      }
      render :json => payload, :status => :ok
      return
        
    end

end