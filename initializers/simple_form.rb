SimpleForm.setup do |config|
  config.wrappers :bootstrap, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, :wrap_with => {:class=>"control-label"} 

    b.wrapper :tag => 'div', :class => 'controls' do |ba|
      ba.use :input,  :wrap_with => {:class => "input"} 
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end
end