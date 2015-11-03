function myBtnRefresh(cloud){
var cloudname = cloud;
$(document).ready('#btn1').click(function (){
		$('#btn1').attr('disabled','disabled');
		$.ajax({
		   url: "scripts/refresh-shell.php", 
		   type: "POST",
		   data: {name:cloudname},     
		   cache: false,
		   success: function (message) {
		   	alert(message);
		  }       
});
});
}
