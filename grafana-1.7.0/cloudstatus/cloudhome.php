<html>
<head>
<style>
table , td, th {
	font-family: verdana,arial,sans-serif;
	color: #1a4045;
	font-size:14px;
   	border-style: solid; 
   	border-color: #a9c6c9;
   	border-collapse: collapse;
}
th {
	background-color:#c3dde0; 
	border-width: 1px; 
	padding: 8px; 
	border-color: #a9c6c9;
}
td {
	background-color: #d9e2e3;
}

table.heading {
		border-width: 0px; 		
}

table.heading tr{
	border-width: 0px; 	
	font-family: verdana,arial,sans-serif;
	font-size:14px;
   	background-color: #2E2E2E;
}
table.heading td{
	border-width: 0px; 	
	font-family: verdana,arial,sans-serif;
	font-size:14px;
   	background-color: #2E2E2E;
}

h1 {
	font-family: verdana,arial,sans-serif;
	color: #e5d9d9;
	font-size:56px;
}

table.legend {
	border-width: 0px; 
}

table.legend tr{
	border-width: 0px; 	
	font-family: verdana,arial,sans-serif;
	font-size:10px;
   	background-color: #2E2E2E;
   	color:#e5d9d9;
}
table.legend td{
	border-width: 0px; 	
	font-family: verdana,arial,sans-serif;
	font-size:10px;
   	background-color: #2E2E2E;
   	color:#e5d9d9;
}

footer {
	color:#e5d9d9;
	font-family: verdana,arial,sans-serif;
	font-size:12px;

}

</style>
</head>


<body bgcolor='#2E2E2E'>
<br>
<table width="100%" class="heading">
<col width="20%">
<col width="80%">	
<tr>
	<td align='center' ><img src='openstack-logo.png' /></td>
	<td align='center' > <h1>OPENSTACK DASHBOARD</h1> </td>
	
</tr>
</table>

<br><br>	
<table style="width:100% " >
<col width="20%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<col width="8%">
<tr>
	<th width="15%"> <img src='clouds.png' /> </th>
	<th>DAL1</th>
	<th>DAL2</th>
	<th>DAL3</th>
	<th>DAL4</th>
	<th>DALSTG2</th>
	<th>DFW1</th>
	<th>DFW2</th>
	<th>DFW3</th>
	<th>DFW4</th>
	<th>DFWSTG2</th>
</tr>

<tr>
      
      <?php  

      	 set_time_limit(0);

         echo "<th> Nova-Computes </th>";      	

         $flag1 = "0";

         $clouds = array("dal1", "dal2", "dal3", "dal4", "dalstg2", "dfw1", "dfw2", "dfw3", "dfw4", "dfwstg2");

         foreach ($clouds as $value) {

            $request_down = "http://esm-graphite.prod.sroy.com/render?target=$value.openstack.Hypervisors-nova-compute-DOWN&format=raw&from=-10mins";
            $response_down = file_get_contents($request_down);  

            $request_up = "http://esm-graphite.prod.sroy.com/render?target=$value.openstack.Hypervisors-nova-compute-UP&format=raw&from=-10mins";
            $response_up = file_get_contents($request_up);  



            $string_up = explode("|", $response_up);
            $string_down = explode("|", $response_down);
            $string_tmp1 = $string_up[1];
            $string_tmp2 = $string_down[1];
           
            $tmp1 = explode(",", $string_tmp1);
            $tmp2 = explode(",", $string_tmp2);

            $up_value = $tmp1[0];
            $down_value = $tmp2[0];

            $up_per = ($up_value / 100);

            if ( $down_value > ($up_per * 20)){
              echo "<td align='center'> <img src='circle_red.png' /> </td> ";
            }
            elseif ( ( $down_value < ($up_per * 20)) && ( $down_value > ($up_per * 10)) ) {
              echo "<td align='center'> <img src='circle_yellow.png' /> </td> ";
            }
            elseif ( $down_value < ($up_per * 10)) {
              echo "<td align='center'> <img src='circle_green.png' /> </td> ";
            }
            else {
              echo "<td align='center'> <img src='circle_grey.png' /> </td> ";            	
            }
    
        }


      ?>

</tr>

<tr>

      <?php  

         echo "<th> Nova-Conductor </th>";      	

         $flag1 = "0";

         $clouds = array("dal1", "dal2", "dal3", "dal4", "dalstg2", "dfw1", "dfw2", "dfw3", "dfw4", "dfwstg2");

         foreach ($clouds as $value) {

            $request = "http://esm-graphite.prod.sroy.com/render?target=$value.openstack.Controller-nova-conductor-DOWN&format=raw&from=-15mins";
            $response = file_get_contents($request);  

            $string = explode("|", $response);
            $string1 = $string[0];
            $string2 = $string[1];
           
            $tmp3 = explode(",", $string2);
            $cur_value = $tmp3[1];
            $past_value = $tmp3[0];
            if (isset($cur_value)){

            if ( $cur_value == 0 ){
            	echo "<td align='center'> <img src='circle_green.png' /> </td> ";
            }
            elseif ( $cur_value == 1.0 ){
              echo "<td align='center'> <img src='circle_yellow.png' /> </td> ";
            }
            elseif ( $cur_value > 1.0 ){
            	echo "<td align='center'> <img src='circle_red.png' /> </td> ";
            }
            else{
              echo "<td align='center'> <img src='circle_grey.png' /> </td> ";
            }
            
        }	
        else {
        	echo "<td align='center'> <img src='circle_grey.png' /> </td> ";
        }

        }

      ?>

</tr>

<tr>

      <?php  

         echo "<th> Nova-Scheduler </th>";      	

         $flag1 = "0";

         $clouds = array("dal1", "dal2", "dal3", "dal4", "dalstg2", "dfw1", "dfw2", "dfw3", "dfw4", "dfwstg2");

         foreach ($clouds as $value) {

            $request = "http://esm-graphite.prod.sroy.com/render?target=$value.openstack.Controller-nova-scheduler-DOWN&format=raw&from=-15mins";
            $response = file_get_contents($request);  

            $string = explode("|", $response);
            $string1 = $string[0];
            $string2 = $string[1];
           
            $tmp3 = explode(",", $string2);
            $cur_value = $tmp3[1];
            $past_value = $tmp3[0];
            if (isset($cur_value)){

            if ( $cur_value == 0 ){
            	echo "<td align='center'> <img src='circle_green.png' /> </td> ";
            }
            elseif ( $cur_value == 1.0 ){
              echo "<td align='center'> <img src='circle_yellow.png' /> </td> ";
            }
            elseif ( $cur_value > 1.0 ){
            	echo "<td align='center'> <img src='circle_red.png' /> </td> ";
            }
            else{
              echo "<td align='center'> <img src='circle_grey.png' /> </td> ";
            }
            
        }	
        else {
        	echo "<td align='center'> <img src='circle_grey.png' /> </td> ";
        }

        }

      ?>

</tr>

</table>

<br><br><br><br>
<table class="legend">
<tr><td><img src='circle_green.png' /></td><td>Cloud is in Good State.</td></tr>
<tr><td><img src='circle_red.png' /></td><td>Cloud is in Bad State, Need immediate attention..!</td></tr>
<tr><td><img src='circle_yellow.png' /></td><td>Cloud is in WARN State.</td></tr>
<tr><td><img src='circle_grey.png' /></td><td>No values returned.</td></tr>
</table>


</body>

</html>




