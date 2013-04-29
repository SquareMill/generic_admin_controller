# This is a base controller for admin models It sets up a basic interface to admin models
# It allows customization either by extending a new controller from this controller, or by overriding the rendered
# erb files. See render_custom_template and render_custom_partial
class Admin::GenericAdminController < Admin::AdminController
  helper_method :singular_name, :plural_name, :index_columns, :custom_partial
  helper_method :namespace, :new_path, :edit_path, :index_path, :model_path, :model_class, :model_object
  helper_method :order_param, :pushstate_params

  # GET /admin/<%= plural_name %>
  def index
    if params[:search].present?
      @query = params[:search]
      search
    else
      query = model_class
      query = query.page(params[:page]) if params[:format] != "csv"
      query = query.order(order_sql(params))
      values = model_filter(query)
      instance_variable_set("@#{plural_name}", values)
    end

    respond_to do |format|
      format.html { render_custom_template('index') }
      format.js { render_custom_template('index') }
      format.csv
    end
  end

  def search
    conditions = nil
    search_columns.each do |col|
      if conditions
        conditions = conditions.or( model_class.arel_table[col].matches( "%#{params[:search]}%" ) )
      else
        conditions = model_class.arel_table[col].matches( "%#{params[:search]}%" )
      end
    end
    query = model_class
    query = query.page(params[:page]) if params[:format] != "csv"
    query = query.where(conditions).order(order_sql(params))
    values = model_filter(query)
    instance_variable_set("@#{plural_name}", values)
  end

  # GET /admin/<%= plural_name %>/1
  def show
    instance_variable_set("@#{singular_name}", model_class.find(params[:id]))

    render_custom_template('show')
  end

  # GET /admin/<%= plural_name %>/new
  def new
    instance_variable_set("@#{singular_name}", model_class.new)

    render_custom_template('new')
  end

  # GET /admin/<%= plural_name %>/1/edit
  def edit
    instance_variable_set("@#{singular_name}", model_class.find(params[:id]))

    render_custom_template('edit')
  end

  # POST /admin/<%= plural_name %>
  def create
    model = instance_variable_set("@#{singular_name}", model_class.new(model_params))
    model.updated_by = current_user if model.respond_to?(:updated_by=)

    if model.save
      flash[:notice] = "#{singular_name} was successfully created."
      redirect_to(redirect_on_edit(model))
      return
    end

    render_custom_template('new')
  end

  # PUT /admin/<%= plural_name %>/1
  def update
    model = instance_variable_set("@#{singular_name}", model_class.find(params[:id]))
    model.updated_by = current_user if model.respond_to?(:updated_by=)

    if model.update_attributes(model_params)
      flash[:notice] = "#{singular_name} was successfully updated."
      redirect_to(redirect_on_edit(model))
      return
    end

    render_custom_template('edit')
  end

  # DELETE /admin/<%= plural_name %>/1
  def destroy
    model = instance_variable_set("@#{singular_name}", model_class.find(params[:id]))
    model.updated_by = current_user if model.respond_to?(:updated_by=)
    model.destroy

    redirect_to(index_path)
  end

private
  def model_object
    instance_variable_get("@#{singular_name}")
  end

  def namespace
    [:admin]
  end

  def new_path
    send("new_#{namespace.join('_')}_#{singular_name}_path")
  end

  def index_path(opts = {})
    send("#{namespace.join('_')}_#{plural_name}_path", opts)
  end

  def model_path(model)
    send("#{namespace.join('_')}_#{singular_name}_path", :id => model.id)
  end

  def edit_path(model)
    send("edit_#{namespace.join('_')}_#{singular_name}_path", :id => model.id)
  end

  # Render either the base template for a partial or the overridden version
  def custom_partial(name)
    path = File.join(Rails.root, "/app/views/#{self.controller_path}/_#{name}.html.erb")
    if File.exists?(path)
      "#{self.controller_path}/#{name}"
    else
      "admin/generic_admin/#{name}"
    end
  end

  # Render either the base template for an action or a custom template for that service
  def render_custom_template(name)
    template_extension = request.xhr? ? ".js.erb" : ".html.erb"
    path = File.join(Rails.root, "/app/views/#{self.controller_path}/#{name}#{template_extension}")
    if File.exists?(path)
      render "#{self.controller_path}/#{name}"
    else
      render "admin/generic_admin/#{name}"
    end
  end

  # Where to redirect after create/update a model
  def redirect_on_edit(model)
    # Default to index path
    index_path
  end

  def model_filter(model)
    model
  end

  def default_order
  end

  def order_param(col_name)
    order = params[:order]

    if order == "#{col_name}_asc"
      "#{col_name}_desc"
    elsif order == "#{col_name}_desc"
      "#{col_name}_asc"
    else
      "#{col_name}_asc"
    end
  end

  def order_sql(params)
    if params[:order]
      split = params[:order].split("_")
      order = split.last.upcase
      column = split[0..-2].join("_")
      "#{column} #{order}"
    else
      default_order
    end
  end

  def pushstate_params
    p = params.dup
    p.delete(:action)
    p.delete(:controller)
    p.delete(:utf8)
    p.to_query.html_safe
  end

  def index_columns
    return @columns if @columns
    columns = model_class.columns.find_all do |col|
      ![:binary, :text].include?(col.type)
    end
    columns.insert(1, model_class.columns.find {|c| c.name == 'name'})
    columns.push(model_class.columns.find {|c| c.name == 'updated_at'})
    @columns = columns.compact.collect {|c| c.name }
  end

  def search_columns
    # By default searches all text fields
    accepted_types = [:string, :text]
    model_class.columns.find_all {|col| accepted_types.include?(col.type) }.collect {|col| col.name }
  end

  def singular_name
    model_name.singularize
  end

  def plural_name
    model_name.pluralize
  end

  def model_name
    model_class.name.underscore
  end

  def model_params
    params.require(singular_name).permit(permitted_params)
  end

  def permitted_params
    model_class.column_names - ["id", "created_at", "updated_at"]
  end
end
