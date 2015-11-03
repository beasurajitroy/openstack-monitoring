argument_usage()
{
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
echo "Error in Argument Usage"
echo "Usage     : ./script_name.sh [cloud-name]"
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"
exit 1
}

if [ $# -ne 1 ]
then
argument_usage
fi



cloud=$1
#source $cloud
path=`pwd`
htmlpath="/Monitoring/openstack/grafana-1.7.0/quotastatus"
mouse="onmouseover=\"this.style.backgroundColor='#ffff66';\" onmouseout=\"this.style.backgroundColor='#d4e3e5';\""
source ${htmlpath}/sources/$cloud
echo "
<html><head><style type=text/css>
table.hovertable {
        font-family: verdana,arial,sans-serif;
        font-size:11px;
        color:#333333;
        border-width: 1px;
        border-color: #999999;
        border-collapse: collapse;
}
table.hovertable th {
        background-color:#c3dde0;
        border-width: 1px;
        padding: 8px;
        border-style: solid;
        border-color: #a9c6c9;
}
table.hovertable tr {
        background-color:#d4e3e5;
}
table.hovertable td {
        border-width: 1px;
        padding: 8px;
        border-style: solid;
        border-color: #a9c6c9;
}
</style></head>
<body>
<table style=\'width:100%\'  class=\"hovertable\">
<tr></h3>$cloud</h3></tr>
<tr>
<th>Tenant Name</th>
<th>Cores Used</th>
<th>Cores Max</th>
<th>% Cores Used</th>
<th>RAM Used</th>
<th>RAM Max</th>
<th>% RAM Used</th>
</tr>

" > ${htmlpath}/${cloud}_quota.htm

keystone tenant-list > $path/tmp1
cat tmp1 | awk -F'|' '{print $2"|"$3}' |  sed '/^\s*$/d' | sed 's/ //g' | sed '1,3d' | sed '$d' > $path/tmp2

while read -r line
do
tenant=`echo "$line" | awk -F'|' '{print $1 "|" $2 }' | sed 's/ //g'`
tenantid=`echo $tenant | awk -F'|' '{print $1}'`
tenantname=`echo $tenant | awk -F'|' '{print $2}'`
compute=`nova absolute-limits --tenant ${tenantid} | grep -e 'maxTotalRAMSize\|totalCoresUsed\|totalRAMUsed\|maxTotalCores'`
coresused=`echo $compute | awk -F'|' '{print $6}'`
coresmax=`echo $compute | awk -F'|' '{print $13}'`
ramused=`echo $compute | awk -F'|' '{print $10}'`
rammax=`echo $compute | awk -F'|' '{print $3}'`

#coresper="$((( $coresused / $coresmax ) * 100 ))"
#ramper="$((( $ramused / $rammax  ) * 100 ))"

echo $tenantname

if [[ $coresmax -eq 0 || $coresmax -eq -1 ]]
then
coresper="0"
else

if [ $coresused -eq 0 ]
then
coresper="0"
else
coresper="$((( $coresused * 100 ) / $coresmax ))"
fi
fi

if [[ $rammax -eq 0 || $rammax -eq -1 ]]
then
ramper="0"
else
if [ $ramused -eq 0 ]
then
ramper="0"
else
ramper="$((( $ramused * 100 ) / $rammax ))"
fi
fi
printf '| %-40s| %-40s| %-10s| %-10s| %-10s| %-10s|\n' $tenantid $tenantname $coresused $coresmax $ramused $rammax

echo "
<tr ${mouse}>
<td>$tenantname</td>
<td>$coresused</td>
<td>$coresmax</td>
<td>$coresper%</td>
<td>$ramused</td>
<td>$rammax</td>
<td>$ramper%</td>
</tr>

" >> ${htmlpath}/${cloud}_quota.htm

done < $path/tmp2

echo "</body></html>" >> ${htmlpath}/${cloud}_quota.htm

