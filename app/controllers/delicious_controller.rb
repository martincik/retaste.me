class DeliciousController < ApplicationController
  
  def index
  end
  
  def new
    @delicious = Delicious.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @delicious }
      format.json  { render :json => @delicious }
    end
  end
  
  def create
    if Context.user.delicious
      flash[:warning] = 'You cannot add new delicious! You already have one. Please use edit page.'
      redirect_to edit_delicious_url and return
    end

    @delicious = Delicious.new(params[:delicious])
    @delicious.user = Context.user
    
    respond_to do |format|
      if @delicious.save
        flash[:notice] = 'Your delicious settings were successfully saved.'
        format.html { redirect_to(edit_delicious_url) }
        format.xml  { render :xml => @delicious, :status => :created, :location => @delicious }
        format.json  { render :json => @delicious, :status => :created, :location => @delicious }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @delicious.errors, :status => :unprocessable_entity }
        format.json  { render :json => @delicious.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @delicious = Context.user.delicious
  end

  def update
    unless @delicious = Context.user.delicious
      flash[:warning] = 'You don\'t have delicious settings created. Please use new page.'
      redirect_to new_delicious_url and return
    end
    
    respond_to do |format|
      if @delicious.update_attributes(params[:delicious])
        flash[:notice] = 'Your delicious settings were successfully updated.'
        format.html { redirect_to(edit_delicious_url) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @delicious.errors, :status => :unprocessable_entity }
        format.json  { render :json => @delicious.errors, :status => :unprocessable_entity }
      end
    end
  end

end
