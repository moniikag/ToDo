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
      if ($("#done").is(':hidden')) {
        $("#done").show(800);
      };
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
      type: "PATCH",
      url:'./'+ id,
      dataType: "json",
      data: { todo_list: { title: value } }
    });
    $("#title").html(value);
    return(value);
    }, {}
  );

  $(function() {
    $("#incomplete").sortable({
      update: function(event, ui){
        var list_id = location.pathname.split('/')[2];
        var items_arr = $("#incomplete").sortable('toArray', {attribute: 'data-id'});
        $.post("./"+list_id+"/prioritize", { ordered_items_ids: items_arr} );
      }
    });
  });

  $("#done").click(function() {
    if (confirm("Have you completed all the TodoItems?")) {
      var list_id = $(this).attr('list-id');
      $.post("./done", { id: list_id} );

      var incomplete = $('div#incomplete').children();
      $(':checkbox').prop("checked", true);
      $('div#completed').append(incomplete);
      $('div#incomplete').append($('li#for-form'));

      var count = $("#completed li").length;
      $("#show-completed").html(count + ' Completed');
      $("#done").hide(800);
    };
  })

});


