<html><head>
<title>DALSTG222 STATUS</title>
<style type=text/css> table.hovertable { font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #999999; border-collapse: collapse; } table.hovertable th { background-color:#c3dde0; border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } table.hovertable tr {       background-color:#d4e3e5; } table.hovertable td { border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } .btn { -webkit-border-radius: 10; -moz-border-radius: 10; border-radius: 10px; font-family: verdana,arial,sans-serif; color: #ffffff; font-size: 14px; background: #3498db; padding: 5px 20px 5px 20px; text-decoration: none; } .btn:hover { background: #e6cf71; text-decoration: none; } </style>
</head><body bgcolor='#2E2E2E'><br><br>
<table style='width:100%'  class='hovertable'>
<tr> <th align='center' style='font-size:16px' > DALSTG22 status  </th> </tr>
</table> <br>
<?php
if (isset($_POST['button'])) {
exec('/Monitoring/openstack/grafana-1.7.0/phphome/shelltestruby.sh'); }
?>
<form method="post"><button class='btn' name='btn' style='float: right;'>REFRESH REPORT</button></form><br><br>
<table style='width:100%;' class='hovertable'>
<tr style='background-color:#a8bff5'>
<th>Network Name</th>
<th>Allocated IP Count</th>
<th>Used IP Count</th>
<th>Remaining IPs</th></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>Primary_External_Net</td>
<td>498</td>
<td>8</td>
<td>490</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>STG_Primary_Net</td>
<td>2022</td>
<td>2021</td>
<td style='background-color:#f4a5a1'>1</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>STG2_Primary_Net</td>
<td>2022</td>
<td>51</td>
<td>1971</td></tr>
</table><br><br>
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
<td>faux-paas</td>
<td>10</td>
<td>50</td>
<td>20%</td>
<td>20480</td>
<td>112640</td>
<td>18%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>dbaas</td>
<td>17</td>
<td>36</td>
<td>47%</td>
<td>34816</td>
<td>98816</td>
<td>35%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ISDSpecialtyNonHippa</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ISDHealthOpticalPharm</td>
<td>7</td>
<td>20</td>
<td>35%</td>
<td>14336</td>
<td>51200</td>
<td>28%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdagm</td>
<td>78</td>
<td>104</td>
<td>75%</td>
<td>159744</td>
<td>212992</td>
<td>75%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdecommerce</td>
<td>2</td>
<td>216</td>
<td>0%</td>
<td>4096</td>
<td>442368</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>LabsCustomerPersonalization</td>
<td>158</td>
<td>158</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>323584</td>
<td>323584</td>
<td style='background-color:#f4a5a1'>100%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>service</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>custsrvc</td>
<td>18</td>
<td>24</td>
<td>75%</td>
<td>36864</td>
<td>49152</td>
<td>75%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>financialservicespersonalization</td>
<td>2</td>
<td>20</td>
<td>10%</td>
<td>4096</td>
<td>51200</td>
<td>8%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>polaris</td>
<td>18</td>
<td>36</td>
<td>50%</td>
<td>36864</td>
<td>83968</td>
<td>43%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>samsclubdotcom</td>
<td>28</td>
<td>65</td>
<td>43%</td>
<td>57344</td>
<td>165632</td>
<td>34%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>canada-gm</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdaukajaxgrcry</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>40960</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops-dev</td>
<td>167</td>
<td>216</td>
<td>77%</td>
<td>342016</td>
<td>442368</td>
<td>77%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>samsus</td>
<td>108</td>
<td>108</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>221184</td>
<td>231424</td>
<td>95%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>CAR</td>
<td>104</td>
<td>104</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>212992</td>
<td>287232</td>
<td>74%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asdauk</td>
<td>6</td>
<td>31</td>
<td>19%</td>
<td>12288</td>
<td>73728</td>
<td>16%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>collaboration</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>customerexperience</td>
<td>3</td>
<td>20</td>
<td>15%</td>
<td>6144</td>
<td>51200</td>
<td>12%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops-int</td>
<td>0</td>
<td>62</td>
<td>0%</td>
<td>0</td>
<td>126976</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>platform</td>
<td>1181</td>
<td>1181</td>
<td style='background-color:#f4a5a1'>100%</td>
<td>2418688</td>
<td>2830720</td>
<td>85%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdordermgmt</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>asda-connect</td>
<td>7</td>
<td>20</td>
<td>35%</td>
<td>14336</td>
<td>51200</td>
<td>28%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>infosec</td>
<td>8</td>
<td>20</td>
<td>40%</td>
<td>16384</td>
<td>51200</td>
<td>32%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>LMS</td>
<td>68</td>
<td>93</td>
<td>73%</td>
<td>139264</td>
<td>190464</td>
<td>73%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>atsupport</td>
<td>3</td>
<td>20</td>
<td>15%</td>
<td>6144</td>
<td>51200</td>
<td>12%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>oneops</td>
<td>409</td>
<td>412</td>
<td style='background-color:#f4a5a1'>99%</td>
<td>837632</td>
<td>1622016</td>
<td>51%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>tsd</td>
<td>183</td>
<td>205</td>
<td>89%</td>
<td>370688</td>
<td>673216</td>
<td>55%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>brazil</td>
<td>6</td>
<td>20</td>
<td>30%</td>
<td>12288</td>
<td>51200</td>
<td>24%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>custpromise</td>
<td>134</td>
<td>150</td>
<td>89%</td>
<td>274432</td>
<td>307200</td>
<td>89%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>gis</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>catdev</td>
<td>1486</td>
<td>1666</td>
<td>89%</td>
<td>3043328</td>
<td>3449088</td>
<td>88%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>esm-monitoring</td>
<td>0</td>
<td>20</td>
<td>0%</td>
<td>0</td>
<td>51200</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>pangaeaservices</td>
<td>2556</td>
<td>2560</td>
<td style='background-color:#f4a5a1'>99%</td>
<td>5234688</td>
<td>5246592</td>
<td style='background-color:#f4a5a1'>99%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>admin</td>
<td>17</td>
<td>-1</td>
<td>0%</td>
<td>34816</td>
<td>-1</td>
<td>0%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>cdqarth</td>
<td>790</td>
<td>817</td>
<td style='background-color:#f4a5a1'>96%</td>
<td>1617920</td>
<td>1673216</td>
<td style='background-color:#f4a5a1'>96%</td>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>isdglobalinvsec</td>
<td>11</td>
<td>30</td>
<td>36%</td>
<td>22528</td>
<td>61440</td>
<td>36%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>sdkcommerce</td>
<td>4</td>
<td>20</td>
<td>20%</td>
<td>11904</td>
<td>59520</td>
<td>20%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>sascos</td>
<td>52</td>
<td>100</td>
<td>52%</td>
<td>106496</td>
<td>204800</td>
<td>52%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ukgmc</td>
<td>22</td>
<td>26</td>
<td>84%</td>
<td>45056</td>
<td>53248</td>
<td>84%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>ukgrsps</td>
<td>26</td>
<td>53</td>
<td>49%</td>
<td>53248</td>
<td>140096</td>
<td>38%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>globalproducts</td>
<td>131</td>
<td>232</td>
<td>56%</td>
<td>268288</td>
<td>475136</td>
<td>56%</td></tr>
<tr style='font-size:12px; background-color:#D4DFFA'> 
<td>affiliates</td>
<td>8</td>
<td>20</td>
<td>40%</td>
<td>16384</td>
<td>51200</td>
<td>32%</td></tr>
</table>
</body></html>
