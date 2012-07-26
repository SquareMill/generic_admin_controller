class Admin::MessagesController < Admin::GenericAdminController
  def model_class
    Message
  end

  def index_columns
    ['body','created_at']
  end

  def default_order
    "created_at DESC"
  end

  # def search
    # query = User

    # unless params[:search].blank?
      # first_name, last_name = params[:search].split(/\s+/)
      # query = query.joins(:employer)
      # q = "%#{first_name.strip}%"
      # if first_name && last_name
        # query = query.where(["(users.first_name LIKE ? AND users.last_name LIKE ?) OR employers.name LIKE ?", q, "%#{last_name.strip}%", "%#{first_name} #{last_name}%"])
      # elsif first_name
        # query = query.where(["users.first_name LIKE ? OR users.last_name LIKE ? OR users.email LIKE ? OR employers.name LIKE ?", q, q, q, q])
      # end
    # end

    # query = query.page(params[:page]) if params[:format] != "csv"
    # @users = query.order(order_sql(params))
  # end
end
