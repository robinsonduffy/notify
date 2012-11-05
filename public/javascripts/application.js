//**GENERAL APPLICATION SCRIPTS**//



//**SPECIFIC SCRIPTS**//

//USER PERMISSIONS FORM
$(document).ready(function(){
  $(".notify-user-form .user-role-checkbox, .notify-user-form #user-group-any, .notify-user-form #user-list-any, .notify-user-form .user-school-checkbox, .notify-user-form #user-list-school").change(function(){
    cleanup_user_permissions_form();
  });
  $(".notify-user-form").each(function(){
    cleanup_user_permissions_form();
  })
});

function cleanup_user_permissions_form(){
  //start with a clean slate
  $("#message-permissions-fieldset").show();
  $(".user-role-checkbox").removeAttr("disabled")
  $(".user-message-type-checkbox").removeAttr("disabled")
  $(".user-recipient-type-checkbox").removeAttr("disabled")
  $(".user-contact-method-type-checkbox").removeAttr("disabled")
  $(".user-school-checkbox").removeAttr("disabled")
  $(".user-list-checkbox").removeAttr("disabled")
  $(".user-group-checkbox").removeAttr("disabled")
  $("#message-permissions-message-types").show();
  $("#message-permissions-recipient-types").show();
  $("#message-permissions-contact-method-types").show();
  $("#message-permissions-schools").show();
  $("#message-permissions-lists").show();
  $("#message-permissions-groups").show();
  $("#message-permissions-fieldset li").show();
  if($("#user-roles-system_admin").is(":checked")){
    $(".user-role-checkbox").not("#user-roles-system_admin").attr("disabled", "true").removeAttr("checked")
    $(".user-message-type-checkbox").attr("disabled", "true")
    $(".user-recipient-type-checkbox").attr("disabled", "true")
    $(".user-contact-method-type-checkbox").attr("disabled", "true")
    $(".user-school-checkbox").attr("disabled", "true")
    $(".user-list-checkbox").attr("disabled", "true")
    $(".user-group-checkbox").attr("disabled", "true")
    $("#message-permissions-message-types").hide();
    $("#message-permissions-recipient-types").hide();
    $("#message-permissions-contact-method-types").hide();
    $("#message-permissions-schools").hide();
    $("#message-permissions-lists").hide();
    $("#message-permissions-groups").hide();
    $("#message-permissions-fieldset").hide();
  }
  if($("#user-roles-system_manager").is(":checked")){
    $(".user-role-checkbox").not("#user-roles-system_manager").attr("disabled", "true").removeAttr("checked")
    $(".user-message-type-checkbox").attr("disabled", "true")
    $(".user-recipient-type-checkbox").attr("disabled", "true")
    $(".user-contact-method-type-checkbox").attr("disabled", "true")
    $(".user-school-checkbox").attr("disabled", "true")
    $(".user-list-checkbox").attr("disabled", "true")
    $(".user-group-checkbox").attr("disabled", "true")
    $("#message-permissions-message-types").hide();
    $("#message-permissions-recipient-types").hide();
    $("#message-permissions-contact-method-types").hide();
    $("#message-permissions-schools").hide();
    $("#message-permissions-lists").hide();
    $("#message-permissions-groups").hide();
    $("#message-permissions-fieldset").hide();
  }
  if($("#user-roles-location_manager").is(":checked")){
    $(".user-role-checkbox").not("#user-roles-location_manager").attr("disabled", "true").removeAttr("checked")
    $(".user-message-type-checkbox").attr("disabled", "true")
    $(".user-recipient-type-checkbox").attr("disabled", "true")
    $(".user-contact-method-type-checkbox").attr("disabled", "true")
    $(".user-list-checkbox").attr("disabled", "true")
    $(".user-group-checkbox").attr("disabled", "true")
    $("#message-permissions-message-types").hide();
    $("#message-permissions-recipient-types").hide();
    $("#message-permissions-contact-method-types").hide();
    $("#message-permissions-lists").hide();
    $("#message-permissions-groups").hide();
  }
  if($("#user-roles-full_sender").is(":checked")){
    $(".user-role-checkbox").not("#user-roles-full_sender, #user-roles-recipient_manager, #user-roles-recipient_viewer").attr("disabled", "true").removeAttr("checked")
    $(".user-recipient-type-checkbox").attr("disabled", "true")
    $(".user-contact-method-type-checkbox").attr("disabled", "true")
    $(".user-list-checkbox").attr("disabled", "true")
    $(".user-group-checkbox").attr("disabled", "true")
    $("#message-permissions-message-types").hide();
    $("#message-permissions-recipient-types").hide();
    $("#message-permissions-contact-method-types").hide();
    $("#message-permissions-lists").hide();
    $("#message-permissions-groups").hide();
  }
  if($("#user-roles-limited_sender").is(":checked")){
    $(".user-role-checkbox").not("#user-roles-limited_sender, #user-roles-recipient_manager, #user-roles-recipient_viewer").attr("disabled", "true").removeAttr("checked")
  }
  if($("#user-roles-recipient_manager").is(":checked")){
    $("#user-roles-recipient_viewer").attr("disabled", "true").removeAttr("checked")
  }
  if($("#user-roles-recipient_viewer").is(":checked")){
    $("#user-roles-recipient_manager").attr("disabled", "true").removeAttr("checked")
  }
  if($("#user-group-any").is(":checked")){
    $(".user-group-checkbox").not("#user-group-any").attr("disabled","true").removeAttr("checked").parent("li").hide();
  }
  if($(".user-school-checkbox:checked").length == 0){
    $("#user-list-school").attr("disabled", "true").removeAttr("checked")
  }
  if($("#user-list-any").is(":checked")){
    $(".user-list-checkbox").not("#user-list-any").attr("disabled","true").removeAttr("checked").parent("li").hide();
  }
  if($("#user-list-school").is(":checked")){
    $(".user-school-checkbox:checked").each(function(){
      $(".user-list-checkbox[data-school_id='"+$(this).val()+"']").attr("disabled","true").removeAttr("checked").parent("li").hide();
    });
  }
}