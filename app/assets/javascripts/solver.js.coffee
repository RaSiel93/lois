$ ->
  $('#add-rule').easyModal()
  $('#add-fact').easyModal()
  $('a.btn-solved').on 'click', ()->
    $.ajax
      type: 'post'
      dataType: "json"
      url: 'solve/' + $('input').val()
      success:  (data, status, xhr) ->
        if(data.status == 'success')
          $('#solver ul').empty()
          $.each data.result, ( index, value ) ->
            value = 'ЕСТЬ ТАКОЙ!' if value == ''
            $('#solver ul').append('<li>'+value+'</li>')

  $('.close').on 'click', ()->
    $(this).parent().remove()

  $('.add-rule').on 'click', ()->
    $('#add-rule').trigger('openModal')
    $('#add-rule input').focus()
  $('#add-rule button').on 'click', ()->
    $.ajax
      type: 'post'
      dataType: "json"
      url: 'rule'
      data: { rule: $('#add-rule input').val() }
      success:  (data, status, xhr) ->
        $('#rules ul').append("<li>"+data.result+"<a class='close' data-method='delete' data-remote='true' href='/rule/"+data.result.id+"' rel='nofollow'>X</a></li>")
        $('#add-rule').trigger('closeModal')
        $('.close').on 'click', ()->
          $(this).parent().remove()

  $('.add-fact').on 'click', ()->
    $('#add-fact').trigger('openModal')
    $('#add-fact input').focus()
  $('#add-fact button').on 'click', ()->
    $.ajax
      type: 'post'
      dataType: "json"
      url: 'fact'
      data: { fact: $('#add-fact input').val() }
      success:  (data, status, xhr) ->
        $('#facts ul').append("<li>"+data.result+"<a class='close' data-method='delete' data-remote='true' href='/fact/"+data.result.id+"' rel='nofollow'>X</a></li>")
        $('#add-fact').trigger('closeModal')
        $('.close').on 'click', ()->
          $(this).parent().remove()


  $('.add-fact').on 'click', ()->
    $('#add-fact').trigger('openModal')

