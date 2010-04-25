class ProfileController < ApplicationController

  skip_before_filter :account_required

  def new
    @user = Context.user
    respond_to do |format|
      format.html { render :action => 'new', :layout => 'login' }
    end
  end
  
  def create
    @user = Context.user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t('controller.users.create.notice')
        format.html { redirect_to root_path }
        format.xml { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "new", :layout => 'login' }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @user = Context.user
  end

  def update
    @user = Context.user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash.now[:notice] = t('controller.users.update.notice')
        format.html { render :action => "edit" }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json  { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end