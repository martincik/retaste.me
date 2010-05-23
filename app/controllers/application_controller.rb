# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :set_locale, :login_required
  prepend_around_filter :set_context # This should run always first!

  helper_method :current_locale?, :current_page_path

  def set_locale
    I18n.locale = I18n.default_locale
  end

  def login_required
    if Context.user.nil?
      if request.request_uri != root_path
        session[:redirect_url] = request.request_uri
      end
      
      redirect_to login_url
    end
  end

  protected

    def set_context
      Context.setup( request, session, params )
      yield
    ensure
      Context.reset
    end

end