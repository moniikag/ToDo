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
    $("#show-completed").html('Completed: ' + count);
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

  // $('.show').click(function() {
  //   var parent = $(this).parent("li");
  //   var $show = $("#show-item-dialog", parent)
  //     .dialog({
  //       autoOpen: false,
  //       title: "TodoItem"
  //     });
  //   $show.dialog('open');
  //   return false;
  // });

  $('.show').click(function() {
    var parent = $(this).parent("li");
    $("#show-item-dialog", parent).dialog();
  });

  $('.edit').click(function() {
    var parent = $(this).parent("li");
    $("#edit-item-dialog", parent).dialog({minWidth: 400});
  })
});

