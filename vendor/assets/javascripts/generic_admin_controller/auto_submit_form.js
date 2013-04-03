// This function makes it so that forms that have the class auto-submit-form 
// use the rails ajax form submit whenever any input in the form is clicked.

function bindAutoSubmitForms() {
  function showLoading(form) {
    // Show the loading animation as soon as the user starts typing
    var loading_id = form.data('loadingAnimation');
    if(loading_id != null) {
      $(loading_id + "-loading").show();
      $(loading_id).hide();
    }
  }

  function submitForm(form, timeout) {
    showLoading(form);
    timeout = timeout || 0;
    clearTimeout(form.data('timeout'));
    form.data('timeout', setTimeout(function() {
      form.trigger('submit.rails');
    }, timeout));
  }

  $(document).on('click', 'form[data-auto-submit="true"] input[type=radio], form[data-auto-submit="true"] input[type=checkbox]', function() {
    var form = $(this).closest('form');
    submitForm(form);
  }).on('change', 'form[data-auto-submit="true"] select', function() {
    var form = $(this).closest('form');
    submitForm(form);
  }).on('keyup', 'form[data-auto-submit="true"] input[type=search], form[data-auto-submit="true"] input[type=text]', function() {
    // As this is an input text box then delay 200ms before submitting the form to wait for multiple key strokes
    var form = $(this).closest('form');
    submitForm(form, 200);
  });
}

