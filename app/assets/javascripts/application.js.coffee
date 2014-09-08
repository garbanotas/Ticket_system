#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require jquery.validate.min
#= require_tree .

$().ready ->
  $('#ticket_form').validate
    errorClass: 'alert-danger'
    validClass: 'alert-success'
    errorElement: 'span'
    highlight: (element) ->
      $(element).closest(".form-group").removeClass("has-success").addClass "has-error"

    success: (element) ->
      element.closest(".form-group").removeClass("has-error").addClass "has-success"
      element.next().html('')

