<html><head>
<title>DFWSTG2 STATUS</title>
<style type=text/css> table.hovertable { font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #999999; border-collapse: collapse; } table.hovertable th { background-color:#c3dde0; border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } table.hovertable tr {       background-color:#d4e3e5; } table.hovertable td { border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } .btn { -webkit-border-radius: 10; -moz-border-radius: 10; border-radius: 10px; font-family: verdana,arial,sans-serif; color: #ffffff; font-size: 14px; background: #3498db; padding: 5px 20px 5px 20px; text-decoration: none; } .btn:hover { background: #e6cf71; text-decoration: none; } </style>
</head><body bgcolor='#2E2E2E'><br><br>
<table style='width:100%'  class='hovertable'>
<tr> <th align='center' style='font-size:16px' > DFWSTG2 status  </th> </tr>
</table> <br>
<?php
if (isset($_POST['button'])) {
exec('/Monitoring/openstack/grafana-1.7.0/quotastatus/scripts/quotagenerate.sh dalstg2'); }
?>
<form method='post'><button class='btn' name='button' style='float: right;'>REFRESH REPORT</button></form><br><br>
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
<td>DevQA2_Primary_Net</td>
<td>2022</td>
<td>669</td>
<td>1353</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>STG2_Primary_Net</td>
<td>2022</td>
<td>198</td>
<td>1824</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>STG_Primary_Net</td>
<td>2022</td>
<td>2009</td>
<td style='background-color:#f4a5a1'>13</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>Primary_External_Net</td>
<td>498</td>
<td>46</td>
<td>452</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>DevQA_Primary_Net</td>
<td>2022</td>
<td>2007</td>
<td style='background-color:#f4a5a1'>15</td></tr>
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
<td>samsus</td>
<td>245</td>
<td>245</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>501760</td>
<td>534272</td>
<td>93%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ukgmc</td>
<td>34</td>
<td>78</td>
<td>43%</td>
<td>69632</td>
<td>159744</td>
<td>43%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>brazil</td>
<td>10</td>
<td>37</td>
<td>27%</td>
<td>20480</td>
<td>75776</td>
<td>27%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdglobalinvsec</td>
<td>11</td>
<td>30</td>
<td>36%</td>
<td>22528</td>
<td>61440</td>
<td>36%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>service</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>40960</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>canada-gm</td>
<td>0</td>
<td>36</td>
<td>0%</td>
<td>0</td>
<td>88576</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops</td>
<td>408</td>
<td>421</td>
<td style='background-color:#f4a5a1'>96%</td>
<td>843008</td>
<td>1640448</td>
<td>51%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>globalproducts</td>
<td>475</td>
<td>514</td>
<td>92%</td>
<td>974656</td>
<td>1060096</td>
<td>91%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>custsrvc</td>
<td>21</td>
<td>132</td>
<td>15%</td>
<td>43008</td>
<td>270336</td>
<td>15%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>tsd</td>
<td>294</td>
<td>349</td>
<td>84%</td>
<td>602112</td>
<td>856768</td>
<td>70%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>customerexperience</td>
<td>3</td>
<td>20</td>
<td>15%</td>
<td>6144</td>
<td>51200</td>
<td>12%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ukgrsps</td>
<td>986</td>
<td>1017</td>
<td style='background-color:#f4a5a1'>96%</td>
<td>2019328</td>
<td>2283264</td>
<td>88%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops-int</td>
<td>0</td>
<td>62</td>
<td>0%</td>
<td>0</td>
<td>126976</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdordermgmt</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>CAR</td>
<td>169</td>
<td>192</td>
<td>88%</td>
<td>346112</td>
<td>541696</td>
<td>63%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>dbaas</td>
<td>17</td>
<td>24</td>
<td>70%</td>
<td>34816</td>
<td>59392</td>
<td>58%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>atsupport</td>
<td>3</td>
<td>20</td>
<td>15%</td>
<td>6144</td>
<td>40960</td>
<td>15%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>sdkcommerce</td>
<td>4</td>
<td>20</td>
<td>20%</td>
<td>11904</td>
<td>40960</td>
<td>29%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>polaris</td>
<td>12</td>
<td>36</td>
<td>33%</td>
<td>24576</td>
<td>73728</td>
<td>33%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>sascos</td>
<td>52</td>
<td>100</td>
<td>52%</td>
<td>106496</td>
<td>204800</td>
<td>52%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>custpromise</td>
<td>815</td>
<td>855</td>
<td>95%</td>
<td>1669120</td>
<td>2078624</td>
<td>80%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ISDSpecialtyNonHippa</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>40960</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>LMS</td>
<td>200</td>
<td>221</td>
<td>90%</td>
<td>409600</td>
<td>452608</td>
<td>90%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdauk</td>
<td>2</td>
<td>27</td>
<td>7%</td>
<td>4096</td>
<td>65536</td>
<td>6%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdaukajaxgrcry</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>40960</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>LabsCustomerPersonalization</td>
<td>205</td>
<td>248</td>
<td>82%</td>
<td>419840</td>
<td>507904</td>
<td>82%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>admin</td>
<td>18</td>
<td>-1</td>
<td>0%</td>
<td>36864</td>
<td>-1</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>affiliates</td>
<td>0</td>
<td>54</td>
<td>0%</td>
<td>0</td>
<td>110592</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>infosec</td>
<td>20</td>
<td>66</td>
<td>30%</td>
<td>40960</td>
<td>145408</td>
<td>28%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>cdqarth</td>
<td>1208</td>
<td>1225</td>
<td style='background-color:#f4a5a1'>98%</td>
<td>2473984</td>
<td>2857728</td>
<td>86%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>samsclubdotcom</td>
<td>1094</td>
<td>1968</td>
<td>55%</td>
<td>2240512</td>
<td>4136256</td>
<td>54%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asda-connect</td>
<td>10</td>
<td>20</td>
<td>50%</td>
<td>20480</td>
<td>51200</td>
<td>40%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops-dev</td>
<td>97</td>
<td>100</td>
<td style='background-color:#f4a5a1'>97%</td>
<td>198656</td>
<td>204800</td>
<td style='background-color:#f4a5a1'>97%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>gis</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>40960</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>pangaeaservices</td>
<td>5959</td>
<td>5960</td>
<td style='background-color:#f4a5a1'>99%</td>
<td>12238528</td>
<td>12872576</td>
<td>95%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdrmnim</td>
<td>0</td>
<td>30</td>
<td>0%</td>
<td>0</td>
<td>61440</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>teiavs</td>
<td>16</td>
<td>100</td>
<td>16%</td>
<td>32768</td>
<td>215040</td>
<td>15%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>platform</td>
<td>1836</td>
<td>1840</td>
<td style='background-color:#f4a5a1'>99%</td>
<td>4008832</td>
<td>4375232</td>
<td>91%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdecommerce</td>
<td>2</td>
<td>112</td>
<td>1%</td>
<td>4096</td>
<td>229376</td>
<td>1%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>financialservicespersonalization</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>esm-monitoring</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>40960</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>faux-paas</td>
<td>17</td>
<td>50</td>
<td>34%</td>
<td>34816</td>
<td>102400</td>
<td>34%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdagm</td>
<td>96</td>
<td>104</td>
<td>92%</td>
<td>196608</td>
<td>212992</td>
<td>92%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>catdev</td>
<td>2905</td>
<td>3074</td>
<td>94%</td>
<td>5953152</td>
<td>6340096</td>
<td>93%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>collaboration</td>
<td>4</td>
<td>24</td>
<td>16%</td>
<td>8192</td>
<td>118784</td>
<td>6%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ISDHealthOpticalPharm</td>
<td>4</td>
<td>20</td>
<td>20%</td>
<td>8192</td>
<td>40960</td>
<td>20%</td></tr>
</table>
</body></html>
