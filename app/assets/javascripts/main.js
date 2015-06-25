$(document).ready(function() {
  $('input[type=checkbox]').change(function() {
    var checkbox = $(this);
    var li = checkbox.closest('li');
    var list_id = location.pathname.split('/')[2];
    if (checkbox.is (':checked')) {
      $.post('/todo_items/' + checkbox.val() +'/complete', { completed: true, todo_list_id: list_id } );
      $("#completed").append(li);
    } else {
      $.post('/todo_items/' + checkbox.val() +'/complete', { completed: false, todo_list_id: list_id } );
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

  $('.share').click(function() {
    var parent = $(this).closest('li')
    parent.addClass('with-invitation');
    $('#transparent').removeClass('invisible');
  });

  $('.show-details').click(function() {
    var parent = $(this).closest('li')
    parent.addClass('with-details');
    $('#transparent').removeClass('invisible');
  });

  $('#transparent').click(function(){
    $(this).addClass('invisible');
    $('#todo_lists li').removeClass('with-invitation');
    $('#todo_items li').removeClass('with-details');
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
  });

  $('form.edit_todo_item').submit(function() {
    var thisel = $(this);
    var parentli = thisel.closest('li');
    var valuesToSubmit = $(this).serialize();
    $.ajax({
      type: "POST",
      url: $(this).attr('action'),
      data: valuesToSubmit,
      dataType: "JSON"
    }).success(function(data) {
      console.log(JSON.stringify(data));
      $('.content-in-list', parentli).html(data.todo_item.content);
      $('.content', parentli).html(data.todo_item.content);
      $('.tag_list', parentli).html(data.todo_item.tag_list)
      if (data.todo_item.deadline != null) {
        $('.deadline', parentli).html(data.todo_item.deadline_formatted)
      };
      if ((Date.parse(data.todo_item.deadline)-Date.now()) < 86400000 ) {
        if (!$('.deadline', parentli).hasClass('urgent'))
        { $('.deadline', parentli).addClass('urgent') };
      } else {
        if ($('.deadline', parentli).hasClass('urgent'))
        { $('.deadline', parentli).removeClass('urgent') };
      };
      (parentli).removeClass('with-details');
    });
    return false;
  });

});


