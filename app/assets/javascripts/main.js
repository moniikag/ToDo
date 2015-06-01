$(document).ready(function() {

  $("#show-completed").click(function() {
    $("#completed").toggle();
  });

  function functionCompleted(checkbox) {
    if ($(checkbox).is (':checked')) {
      alert('checked' + checkbox.value);
      $.post('/todo_items/' + checkbox.value +'/complete', { completed: true } );
    } else {
      alert('unchecked' + checkbox.value);
      $.post('/todo_items/' + checkbox.value +'/complete', { completed: false } );
    };
  };

  // $(".checkbox-completed").click(function() {
  //   if ($(this).is (':checked')) {
  //     console.log('checked' + this.value);
  //     $.post('/todo_items/' + this.value +'/complete', { completed: true } );
  //   } else {
  //     console.log('unchecked' + this.value);
  //     $.post('/todo_items/' + this.value +'/complete', { completed: false } );
  //   }
  // });

  // $(".checkbox-completed").on("change", function(){
  //   if ($(this).is (':checked')) {
  //     console.log('checked' + this.value);
  //     $.post('/todo_items/' + this.value +'/complete', { completed: true } );
  //   } else {
  //     console.log('unchecked' + this.value);
  //     $.post('/todo_items/' + this.value +'/complete', { completed: false } );
  //   };
  // });


});
