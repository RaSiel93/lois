# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('a.btn-solved').on 'click', ()->
    text = $('input').val()
    $('#solver ul').append('<li>'+text+'</li>')
    $.ajax
      dataType: "json"
      url: 'solve/ew'
      success:  (data, status, xhr) ->
        alert data.result
