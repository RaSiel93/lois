# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('a.btn-solved').on 'click', ()->
    $.ajax
      dataType: "json"
      url: 'solve/' + $('input').val()
      success:  (data, status, xhr) ->
        if( data.status == 'success')
          $('#solver ul').append('<li>'+data.result+'</li>')
        else
