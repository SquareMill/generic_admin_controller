# Generic Admin Controller

Create simple and customizable CMS's on Rails 4 apps.

Expectations:

- Your project has Twitter Bootstrap 2 and jQuery 1.7+.
- Your project has an admin namespace and a base `Admin::AdminController`.
- You use the [simple_form](https://github.com/plataformatec/simple_form) initializer to set up simple\_form bootstrap html structure.

## Sample Controller Example

### Routes

``` ruby
namespace :admin do
  resources :messages
end
```

### Controller

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

## Javascript

In order to have the search form submit automatically, you'll need to add a javascript file.

You can add this to a manifest showing in your admin layout:
```
//= require generic_admin_controller/auto_submit_form
```

Or just add the file individually in the layout:
```
<%= javascript_include_tag "generic_admin_controller/auto_submit_form" %>
```

## Overriding

Override views by creating a view directory for the controller and placing a partial or view file in the directory (`{index,new,edit,_form,_model_table}.html.erb` etc.)

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
