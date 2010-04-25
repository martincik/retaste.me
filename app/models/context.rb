class Context

  class << self

    def setup( request, session, params )
      @request, @session, @params = request, session, params
      extract_user
      log_vitals
    end

    def reset
      @request, @session, @params = nil, nil, nil
      @user = nil
    end

    def user
      @user
    end

    def user=( user )
      @user = user
    end
    
    def account
      @account
    end
    
    def account=( account )
      @account = account
    end

    private

      def logger
        ActiveRecord::Base.logger
      end

      def log( message, marker = "" )
        logger.info "##> #{marker} pid:#{Process.pid} #{message}"
      end

      def log_vitals
        log( "api_token:= #{@params[:api_token]} session:= user_id:#{ @session[ :user_id ] } session:= account_id:#{ @session[ :account_id ] } ")
      end

      def extract_user
        @user = User.find_by_id(@session[:user_id])
      end
      
  end

end
