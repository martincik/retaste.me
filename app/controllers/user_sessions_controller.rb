class UserSessionsController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]
  skip_before_filter :verify_authenticity_token, :only => [:create]

  layout 'login'

  def new
  end

  def create
    redirect_to login_path and return unless data = RPXNow.user_data(params[:token])
    
    user = User.find_by_identifier(data[:identifier])
    if user.nil?
      if User.find_by_email(data[:email])
        flash[:notice] = t('controller.user_sessions.create.notice')
        redirect_to login_path and return
      end
      
      user = User.create(data)
    end
    
    session[:user_id] = user.respond_to?(:id) && !user.new_record? ? user.id : nil
    
    if user.email.blank?
      flash[:warning] = t('controller.user_sessions.create.warning')
      redirect_to new_profile_path
    else
      redirect_to root_path
    end
  end

  def destroy
    Context.reset
    session[:user_id] = nil
    redirect_to login_path
  end
end
