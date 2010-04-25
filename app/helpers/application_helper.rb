# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def select_current_tab(current_tab, tab)
    current_tab.downcase == tab.downcase ? ' class="selected"' : ''
  end

  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end

  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

  # Shorten the string
  def shorten(string, count = 30, end_str=' ...')
    return "" if string.nil? || count < 1
    if string.length >= count
      shortened = string[0, count]
      splitted = shortened.split(/\s+/)
      words = splitted.length
      splitted[0, words-1].join(" ") + end_str
    else
      string
    end
  end

  def accounts_for_html_select
    @accounts = Account.find( :all, :conditions => {:user_id => Context.user.id} )
    @accounts = @accounts.map { |account| [account.name_with_currency, account.id] }
    @accounts << [ t('view.accounts.new'), -1 ]
  end
  
  def context_links(*args)
    links = []
    args.each do |link|
      links << content_tag(:span, (link == args.last) ? link : link + '&nbsp;&raquo;&nbsp;')
    end
    links
  end

  def render_submenu(controller)
    render_shared('submenu', controller)
  end

  def render_sidebar(controller)
    render_shared('sidebar', controller)
  end

  def format_currency(amount)
    number_to_currency(amount, :unit => '&euro;', :separator => '.', :delimiter => '')
  end

  private

    def render_shared(name, controller)
      return if controller.tab_name.blank?

      views_subdir_name = controller.class.to_s.tableize.split('_').first
      if File.exists?(File.join(RAILS_ROOT, 'app', 'views', views_subdir_name, "_#{name}.html.erb"))
        render :partial => name
      elsif File.exists?(File.join(RAILS_ROOT, 'app', 'views', 'shared', controller.tab_name + "_#{name}.html.erb"))
        render :file => 'shared/' + controller.tab_name + '_' + name
      else
        render :file => 'shared/' + name
      end
    end

end