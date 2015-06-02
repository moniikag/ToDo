$(document).ready(function() {

  $('input[type=checkbox]').change(function() {
    var checkbox = $(this);
    if (checkbox.is (':checked')) {
      $.post('/todo_items/' + checkbox.val() +'/complete', { completed: true } );
      checkbox.parents('.todo_item').addClass('complete');
    } else {
      $.post('/todo_items/' + checkbox.val() +'/complete', { completed: false } );
      checkbox.parents('.todo_item').removeClass('complete');
    };
  });

  $("#show-completed").click(function() {
    $("#completed").toggleClass("invisible");
  });

});
