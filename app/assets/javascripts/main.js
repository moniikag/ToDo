$(document).ready(function() {
  $('input[type=checkbox]').change(function() {
    var checkbox = $(this);
    var li = checkbox.closest('li');
    if (checkbox.is (':checked')) {
      $.post('/todo_items/' + checkbox.val() +'/complete', { completed: true } );
      $("#completed").append(li);
    } else {
      $.post('/todo_items/' + checkbox.val() +'/complete', { completed: false } );
      $("#incomplete").prepend(li);
    };
    var count = $("#completed li").length;
    $("#show-completed").html(count + ' Completed');
  });

  $("#show-completed").click(function() {
    $("#completed").toggleClass("invisible");
  });

  $("#new-list").click(function() {
    $("#new-list-form").toggleClass("invisible");
    $("input#todo_list_title").focus();
  });

  $("#new-invitation").click(function() {
    $("#invitation-form").toggleClass("invisible");
  });

  $('#form-for-item').parent().click(function() {
    $('#form-for-item').removeClass("invisible");
    $('input#todo_item_content').focus();
  });

  $("#new-item").click(function() {
    $("#form-for-item").toggleClass("invisible");
    $("input#todo_item_content").focus();
  });

  $('.show').click(function() {
    var parent = $(this).closest('li')
    if (parent.hasClass('with-details')) {
      parent.removeClass('with-details');
    }
    else {
      $('section#todo_items li').removeClass('with-details');
      parent.addClass('with-details');
    }
  });

  $('.share').click(function() {
    var parent = $(this).closest('li')
    if (parent.hasClass('with-invitation')) {
      parent.removeClass('with-invitation');
    }
    else {
      $('section#todo_lists li').removeClass('with-invitation');
      parent.addClass('with-invitation');
    }
  });

  $(function() {
    $('.datepicker').datepicker({
      dateFormat: 'dd/mm/yy'
    });
  });

  $('.editable-title').editable(function(value, settings) {
    var id = $('li#selected div.editable-title').attr('data-list-id');
    $.ajax({
      url:'./'+ id + '.json',
      method:"PATCH",
      data: { todo_list: { title: value } }
    });
    $("#title").html(value);
    return(value);
    }, {}
  );


});


