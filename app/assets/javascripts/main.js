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



  $('.edit').click(function() {
    console.log('edit');
    var parent = $(this).parent("li");
    $("#edit-item-dialog", parent).dialog({minWidth: 400});
  })

  // $('.edit').click(function() {
  //   var parent = $(this).parent("li");
  //   $("#edit-item-dialog", parent).dialog(open);
  //   return false;
  // })

  $('.show').click(function() {
    console.log('show');
    var parent = $(this).parent("li");
    $("#show-item-dialog", parent).dialog();
  });

  // $('.show').click(function() {
  //   var parent = $(this).parent("li");
  //   $("#show-item-dialog", parent).dialog({
  //     modal: true,
  //   }).open();
  // });

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

});

      // buttons: { Close: function() {$("#show-item-dialog", parent).dialog("destroy");}}
