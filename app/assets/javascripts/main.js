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
  });

  $("#new-invitation").click(function() {
    $("#invitation-form").toggleClass("invisible");
  });

  $('#form-for-item').parent().click(function() {
    $('#form-for-item').removeClass("invisible");
  });

  $('.show').click(function() {
    console.log('show');
    var parent = $(this).closest('li')
    $(".details", parent).toggleClass("invisible");
  });

  $(function() {
    $('.datepicker').datepicker({
      dateFormat: 'dd/mm/yy'
    });
  });

});
