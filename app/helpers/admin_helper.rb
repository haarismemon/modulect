module AdminHelper
  

  # A simple helper method which sets the page title on admin
  def full_title_admin(page_title = '')
      base_title = "Modulect"
      if page_title.empty?
       "Admin | " + base_title
      else
        page_title + " - Admin | " + base_title
      end
  end

    # sort_by is like "name" for unimodule
    # order is either asc or desc (lowercase)
    def sort(table_name, list, sort_by, order, per_page)

      if table_name.has_attribute?(sort_by) && (order == "asc" || order == "desc")
        list.paginate(page: params[:page], :per_page => per_page).order(sort_by + ' ' + order.upcase)
      else
        # default case
        list.paginate(page: params[:page], :per_page => per_page).order('name ASC')
      end

    end

end