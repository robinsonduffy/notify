$(document).ready(function(){
  $("#admin-checkbox").change(function(){
    // ajax call to set the admin
    $.ajax({
      type: 'POST',
      url: '../users/set_admin',
      data: {
        user_id: $("#user-info").attr("_user_id"),
        admin_status: this.checked
      },
      error: function(data, status, error){
        alert("There was an error.  Your changes were not saved")
      }
    });
  });
  $(".school-checkbox").change(function(){
    // ajax call to change the librarian status
    // alert($(this).val()) gets the school_id
    $.ajax({
      type: 'POST',
      url: '../users/set_librarian',
      data: {
        user_id: $("#user-info").attr("_user_id"),
        school_id: $(this).val(),
        librarian_status: this.checked
      },
      error: function(){
        alert("There was an error.  Your changes were not saved")
      }
    })
  })
})
