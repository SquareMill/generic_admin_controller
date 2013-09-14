# Generic Admin Controller

Create customizable CMS's.

Expectations:

- Your project is Rails 4 and has [kaminari](https://github.com/amatsuda/kaminari), [simple_form](https://github.com/plataformatec/simple_form), twitter bootstrap, and jquery
- Your project has a admin namespace and a base `Admin::AdminController`
- You use the simple\_form initializer to set up simple\_form bootstrap html structure

## Sample Controller Example

### Routes

``` ruby
namespace :admin do
  resources :messages
end
```

#### Controller

``` ruby
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
end
```

## Overriding

Override views by creating a view directory for the controller and placing a partial or view file in the directory (`{index,new,edit,\_form,\_model\_table}.html.erb` etc.)
Override controller methods by implementing them in the controller. For example to replace the search:

``` ruby
def search
  query = User

  unless params[:search].blank?
    first_name, last_name = params[:search].split(/\s+/)
    query = query.joins(:employer)
    q = "%#{first_name.strip}%"
    if first_name && last_name
      query = query.where("(users.first_name LIKE ? AND users.last_name LIKE ?) OR employers.name LIKE ?", q, "%#{last_name.strip}%", "%#{first_name} #{last_name}%")
    elsif first_name
      query = query.where("users.first_name LIKE ? OR users.last_name LIKE ? OR users.email LIKE ? OR employers.name LIKE ?", q, q, q, q)
    end
  end

  query = query.page(params[:page]) if params[:format] != "csv"
  @users = query.order(order_sql(params))
end
```
