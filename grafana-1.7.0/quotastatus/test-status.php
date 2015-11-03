<html><head>
<title>DFW3 STATUS</title>
<style type=text/css> table.hovertable { font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #999999; border-collapse: collapse; } table.hovertable th { background-color:#c3dde0; border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } table.hovertable tr {       background-color:#d4e3e5; } table.hovertable td { border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } .btn { -webkit-border-radius: 10; -moz-border-radius: 10; border-radius: 10px; font-family: verdana,arial,sans-serif; color: #ffffff; font-size: 14px; background: #3498db; padding: 5px 20px 5px 20px; text-decoration: none; } .btn:hover { background: #e6cf71; text-decoration: none; } </style>
<script>
function myBtnFunction() {
    document.getElementById("btn").disabled = true;
}
</script>
</head><body bgcolor='#2E2E2E'><br><br>
<table style='width:100%'  class='hovertable'>
<tr> <th align='center' style='font-size:16px' > test status  </th> </tr>
</table> <br>
<?php
if (isset($_POST['button'])) {
echo '<script type="text/javascript">myBtnFunction();</script>';

?>
<form method="post"><button class='btn' id='btn' name='button' style='float: right;'>REFRESH REPORT</button></form><br><br>
<table style='width:100%'  class='hovertable'>
<tr><th align='center' style='font-size:12px; background-color:#f6e0ab' > IP Availability Report </th></tr>
</table><br>
<table style='width:100%;' class='hovertable'>
<tr style='background-color:#a8bff5'>
<th>Network Name</th>
<th>Allocated IP Count</th>
<th>Used IP Count</th>
<th>Remaining IPs</th></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>Primary2_External_Net</td>
<td>2022</td>
<td>1974</td>
<td style='background-color:#f4a5a1'>48</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>Primary_External_Net</td>
<td>2022</td>
<td>259</td>
<td>1763</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>SAMSUS_Primary_Net</td>
<td>498</td>
<td>135</td>
<td>363</td></tr>
</table><br><br>
<table style='width:100%'  class='hovertable'>
<tr><th align='center' style='font-size:12px; background-color:#f6e0ab' > Quota Availability Report </th>
</tr></table><br>
<table style='width:100%;' class='hovertable'>
<tr style='background-color:#a8bff5'>
<th>Tenant Name</th>
<th>Cores Used</th>
<th>Allocated Cores</th>
<th>% Cores Used</th>
<th>RAM Used</th>
<th>Allocated RAM</th>
<th>% RAM Used</th></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>qarth</td>
<td>62</td>
<td>100</td>
<td>62%</td>
<td>184512</td>
<td>297600</td>
<td>62%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ISDSpecialtyNonHippa</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>59520</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>faux-paas</td>
<td>10</td>
<td>75</td>
<td>13%</td>
<td>29760</td>
<td>339200</td>
<td>8%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>custpromise</td>
<td>112</td>
<td>112</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>333312</td>
<td>333312</td>
<td style='background-color:#f4a5a1'>100%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>admin</td>
<td>0</td>
<td>-1</td>
<td>0%</td>
<td>0</td>
<td>-1</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ISDHealthOpticalPharm</td>
<td>1</td>
<td>20</td>
<td>5%</td>
<td>2976</td>
<td>59520</td>
<td>5%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>pangaeaservices</td>
<td>5883</td>
<td>5883</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>19111392</td>
<td>19519712</td>
<td style='background-color:#f4a5a1'>97%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>monitoring</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>59520</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>polaris</td>
<td>8</td>
<td>12</td>
<td>66%</td>
<td>23808</td>
<td>35712</td>
<td>66%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>catdev</td>
<td>2316</td>
<td>2347</td>
<td style='background-color:#f4a5a1'>98%</td>
<td>7694208</td>
<td>7727072</td>
<td style='background-color:#f4a5a1'>99%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>platform</td>
<td>1060</td>
<td>1064</td>
<td style='background-color:#f4a5a1'>99%</td>
<td>3323520</td>
<td>3456928</td>
<td style='background-color:#f4a5a1'>96%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>LMS</td>
<td>24</td>
<td>32</td>
<td>75%</td>
<td>71424</td>
<td>95232</td>
<td>75%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>inkiru</td>
<td>4</td>
<td>10</td>
<td>40%</td>
<td>11904</td>
<td>29760</td>
<td>40%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdagm</td>
<td>0</td>
<td>10</td>
<td>0%</td>
<td>0</td>
<td>29760</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>dbaas</td>
<td>0</td>
<td>10</td>
<td>0%</td>
<td>0</td>
<td>29760</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>torbit</td>
<td>0</td>
<td>10</td>
<td>0%</td>
<td>0</td>
<td>29760</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>esm-monitoring</td>
<td>2</td>
<td>10</td>
<td>20%</td>
<td>5952</td>
<td>29760</td>
<td>20%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>LabsCustomerPersonalization</td>
<td>525</td>
<td>541</td>
<td style='background-color:#f4a5a1'>97%</td>
<td>1562400</td>
<td>1610016</td>
<td style='background-color:#f4a5a1'>97%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ukgrsps</td>
<td>16</td>
<td>20</td>
<td>80%</td>
<td>47616</td>
<td>59520</td>
<td>80%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>service</td>
<td>0</td>
<td>10</td>
<td>0%</td>
<td>0</td>
<td>29760</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdauk</td>
<td>0</td>
<td>47</td>
<td>0%</td>
<td>0</td>
<td>139872</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>gis</td>
<td>4</td>
<td>20</td>
<td>20%</td>
<td>11904</td>
<td>59520</td>
<td>20%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>car</td>
<td>94</td>
<td>138</td>
<td>68%</td>
<td>279744</td>
<td>410688</td>
<td>68%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ukgmc</td>
<td>0</td>
<td>14</td>
<td>0%</td>
<td>0</td>
<td>41664</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>samsclubdotcom</td>
<td>284</td>
<td>454</td>
<td>62%</td>
<td>845184</td>
<td>1336256</td>
<td>63%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>globalproducts</td>
<td>714</td>
<td>740</td>
<td style='background-color:#f4a5a1'>96%</td>
<td>2124864</td>
<td>2267200</td>
<td>93%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>SiteAnalytics</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>59520</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops-int</td>
<td>0</td>
<td>85</td>
<td>0%</td>
<td>0</td>
<td>220480</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>samsus</td>
<td>42</td>
<td>48</td>
<td>87%</td>
<td>124992</td>
<td>150304</td>
<td>83%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>tsd</td>
<td>72</td>
<td>79</td>
<td>91%</td>
<td>211200</td>
<td>235104</td>
<td>89%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdaukajaxgrcry</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>59520</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>custsrvc</td>
<td>0</td>
<td>16</td>
<td>0%</td>
<td>0</td>
<td>47616</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops</td>
<td>223</td>
<td>270</td>
<td>82%</td>
<td>663648</td>
<td>1035520</td>
<td>64%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>sascos</td>
<td>140</td>
<td>146</td>
<td>95%</td>
<td>416640</td>
<td>434496</td>
<td>95%</td></tr>
</table>
</body></html>
