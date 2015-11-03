require 'rubygems'
require 'net/http'
require 'uri'
require 'json'
require 'net/smtp'
require 'rufus-scheduler'
require 'socket'
require 'logger'
require 'socket'
require 'timeout'
require 'encrypted_strings'
require 'ipaddr'  




cloud=["dal1"].each do |filename|
  file=Hash[*File.read("/Monitoring/openstack/conf/#{filename}.txt").split(/[, \n]+/)].to_json
  $properties=JSON.parse(file)

      keystone_uri = URI.parse("https://#{$properties["cloudapihost"]}:5443/v2.0/tokens")
      @toSend = {
        "auth" => {
                      "tenantName" => "admin",
                      "passwordCredentials" => {
                            "username" => "iaasops",
                            "password" => "LgPewB10SkI=\n".decrypt(:symmetric, :password => "secret_key")

                      }
        }
      }.to_json

      keystone_headers = { 'Content-Type'=> 'application/json' , 'Accept'=> 'application/json', 'Accept-Charset'=> 'utf-8'}
      # Create the HTTP objects
      keystone_http = Net::HTTP.new(keystone_uri.host, keystone_uri.port)
      keystone_http.use_ssl = true
      keystone_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      keystone_request = Net::HTTP::Post.new(keystone_uri.request_uri,keystone_headers)
      keystone_request.body = @toSend

      # Send the keystone request
      keystone_response = keystone_http.request(keystone_request)
      #puts keystone_response.body
      #body = JSON.parse(response.body)


      if keystone_response.code == "200"
        result = JSON.parse(keystone_response.body)
        #puts result
        
        token = result["access"]["token"]["id"]
        tenantid=result["access"]["token"]["tenant"]["id"]
        #puts tenantid
        puts $token

      else

        puts "Error connecting to keystone api for generating authentication token"
        #send_email "xxxxx", :body => "This was for testing to send"
      end 



####################################################################################################
### Creating HTML file
####################################################################################################

      fileHtml = File.new("#{$properties["quotahtml"]}/#{$properties["tenant"]}-status.html", "w+")

      fileHtml.puts "<html><head>"
      fileHtml.puts "<title>DAL1 STATUS</title>"
      fileHtml.puts "<style type=text/css> table.hovertable { font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #999999; border-collapse: collapse; } table.hovertable th { background-color:#c3dde0; border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } table.hovertable tr {       background-color:#d4e3e5; } table.hovertable td { border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } .btn { -webkit-border-radius: 10; -moz-border-radius: 10; border-radius: 10px; font-family: verdana,arial,sans-serif; color: #ffffff; font-size: 14px; background: #3498db; padding: 5px 20px 5px 20px; text-decoration: none; } .btn:hover { background: #5cace2; text-decoration: none;} .btn[disabled=disabled] { background: #e6cf71; text-decoration: none;   } </style>"
      fileHtml.puts "<script src=\"scripts/jquery-1.9.1.js\"></script>"
      fileHtml.puts "<script src=\"scripts/refresh-button.js\"></script>"
      fileHtml.puts "</head><body bgcolor='#2E2E2E'><br><br>"
      fileHtml.puts "<table style='width:100%;'  class='hovertable'>"
      fileHtml.puts "<tr> <th align='right' style='font-size:16px;width:50%;' > DAL1 status </th> <th>"
      fileHtml.puts "<form id='form1' name='formname'>"
      fileHtml.puts "<input id='btn1' type=\"button\" style='float:right' class='btn' value='REFRESH REPORT' onclick='myBtnRefresh(\"dal1\")' />"
      fileHtml.puts "</form></th></tr></table><br>"



####################################################################################################
### Variable Declations
####################################################################################################

      ipused=0
      ipleft=0
      ipavailable=Array[]
      usedcount=Array[]
      subnetid=Array[]
      netname=Array[]
      netid=Array[]
      tenid=Array[]
      tenname=Array[]

####################################################################################################
### Getting Network List for a Cloud
####################################################################################################

      netlist = URI("https://#{$properties["cloudapihost"]}:9696/v2.0/networks")
      netlist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }
      netlist_http = Net::HTTP.new(netlist.host, netlist.port)
      netlist_http.use_ssl = true
      netlist_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      netlist_request = Net::HTTP::Get.new(netlist.request_uri,netlist_headers)
      netlist_response = netlist_http.request(netlist_request)

      netlistdata = JSON.parse(netlist_response.body)

       netlistdata["networks"].length.times do |j|
        netname.push("#{netlistdata["networks"][j]["name"]}")
        netid.push("#{netlistdata["networks"][j]["id"]}")
        #puts netname[j] 
        #puts netid[j]
       end

####################################################################################################
### To Get Total IP Count allocated
####################################################################################################

      subnetlist = URI("https://#{$properties["cloudapihost"]}:9696/v2.0/subnets")
      subnetlist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }
      subnetlist_http = Net::HTTP.new(subnetlist.host, subnetlist.port)
      subnetlist_http.use_ssl = true
      subnetlist_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      subnetlist_request = Net::HTTP::Get.new(subnetlist.request_uri,subnetlist_headers)
      subnetlist_response = subnetlist_http.request(subnetlist_request)
      subnetlistdata = JSON.parse(subnetlist_response.body)

        netid.each_index do |j|
           subnetlistdata["subnets"].length.times do |k|
                if netid[j] == subnetlistdata["subnets"][k]["network_id"]
                  subnetid.push("#{subnetlistdata["subnets"][k]["network_id"]}")
                  subnet=subnetlistdata["subnets"][k]["cidr"]
                  subnetipavailable=IPAddr.new(subnet).to_range.count-2 
                  reservedsubnetip=(subnetipavailable/256)*2 + 10
                  ipavailable[j]=(subnetipavailable-reservedsubnetip)
                end
          end
      end


####################################################################################################
### To Get Total IP's Used
####################################################################################################

      portlist = URI("https://#{$properties["cloudapihost"]}:9696/v2.0/ports")
      portlist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }
      portlist_http = Net::HTTP.new(portlist.host, portlist.port)
      portlist_http.use_ssl = true
      portlist_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      portlist_request = Net::HTTP::Get.new(portlist.request_uri,portlist_headers)
      portlist_response = portlist_http.request(portlist_request)
      #puts portlist_response
      portlistdata = JSON.parse(portlist_response.body)

        netid.each_index do |j|
          usedcount[j]=0
        portlistdata["ports"].length.times do |k|
              if netid[j] == portlistdata["ports"][k]["network_id"]
                usedcount[j]=usedcount[j]+1
              end
        end
  	end


####################################################################################################
### Converting to HTML IP Status
####################################################################################################

      fileHtml.puts "<table style='width:100%'  class='hovertable'>"
      fileHtml.puts "<tr><th align='center' style='font-size:12px; background-color:#f6e0ab' > IP Availability Report </th></tr>"
      fileHtml.puts "</table><br>"
      fileHtml.puts "<table style='width:100%;' class='hovertable'>"
      fileHtml.puts "<tr style='background-color:#a8bff5'>"
      fileHtml.puts "<th>Network Name</th>"
      fileHtml.puts "<th>Allocated IP Count</th>"
      fileHtml.puts "<th>Used IP Count</th>"
      fileHtml.puts "<th>Remaining IPs</th></tr>" 


      netid.each_index do |j|  
        ipleft=(ipavailable[j]-usedcount[j])
        fileHtml.puts "<tr style='font-size:12px; background-color:#D4DFFA'> "
        fileHtml.puts "<td>#{netname[j]}</td>"
        fileHtml.puts "<td>#{ipavailable[j]}</td>"
        fileHtml.puts "<td>#{usedcount[j]}</td>"
        if ipleft < 50
          fileHtml.puts "<td style='background-color:#f4a5a1'>#{ipleft}</td></tr>"
        else
          fileHtml.puts "<td>#{ipleft}</td></tr>"
        end
      end
      fileHtml.puts "</table><br><br>"



####################################################################################################
### To Get Quota Allocation details for Individual Tenants and converting to HTML
####################################################################################################

      fileHtml.puts "<table style='width:100%'  class='hovertable'>"
      fileHtml.puts "<tr><th align='center' style='font-size:12px; background-color:#f6e0ab' > Quota Availability Report </th>"
      fileHtml.puts "</tr></table><br>"
      fileHtml.puts "<table style='width:100%;' class='hovertable'>"
      fileHtml.puts "<tr style='background-color:#a8bff5'>"
      fileHtml.puts "<th>Tenant Name</th>"
      fileHtml.puts "<th>Cores Used</th>"
      fileHtml.puts "<th>Allocated Cores</th>"
      fileHtml.puts "<th>% Cores Used</th>" 
      fileHtml.puts "<th>RAM Used</th>"
      fileHtml.puts "<th>Allocated RAM</th>"
      fileHtml.puts "<th>% RAM Used</th></tr>" 


      tenlist = URI("https://#{$properties["cloudapihost"]}:35357/v2.0/tenants")
      tenlist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }
      tenlist_http = Net::HTTP.new(tenlist.host, tenlist.port)
      tenlist_http.use_ssl = true
      tenlist_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      tenlist_request = Net::HTTP::Get.new(tenlist.request_uri,tenlist_headers)
      tenlist_response = tenlist_http.request(tenlist_request)
     # puts tenlist_response
      tenlistdata = JSON.parse(tenlist_response.body)
      #puts tenlistdata 
      tenlistdata["tenants"].length.times do |j|
        tenid.push("#{tenlistdata["tenants"][j]["id"]}")
        tenname.push("#{tenlistdata["tenants"][j]["name"]}")

        tenlimit = URI("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/limits?tenant_id=#{tenid[j]}")
        tenlimit_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }
        tenlimit_http = Net::HTTP.new(tenlimit.host, tenlimit.port)
        tenlimit_http.use_ssl = true
        tenlimit_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        tenlimit_request = Net::HTTP::Get.new(tenlimit.request_uri,tenlimit_headers)
        tenlimit_response = tenlimit_http.request(tenlimit_request)
        tenlimitdata = JSON.parse(tenlimit_response.body)

          coresused=tenlimitdata["limits"]["absolute"]["totalCoresUsed"]
          totalcores=tenlimitdata["limits"]["absolute"]["maxTotalCores"]
          if totalcores == 0 or totalcores == -1 
            percoresused=0
           else
            if coresused == 0
              percoresused=0
            else
              percoresused=((coresused * 100 )/ totalcores)
            end
          end

          ramused=tenlimitdata["limits"]["absolute"]["totalRAMUsed"]
          totalram=tenlimitdata["limits"]["absolute"]["maxTotalRAMSize"]
          if totalram == 0 or totalram == -1
            perramused=0
           else 
             if ramused == 0
              perramused=0
             else
              perramused=((ramused * 100)/ totalram)
             end
          end

        fileHtml.puts "<tr style='font-size:12px; background-color:#D4DFFA'> "
        fileHtml.puts "<td>#{tenname[j]}</td>"
        fileHtml.puts "<td>#{coresused}</td>"
        fileHtml.puts "<td>#{totalcores}</td>"
        if percoresused > 95
          fileHtml.puts "<td style='background-color:#f4a5a1'>#{percoresused}%</td>"
        else
          fileHtml.puts "<td>#{percoresused}%</td>"
        end
        fileHtml.puts "<td>#{ramused}</td>"
        fileHtml.puts "<td>#{totalram}</td>"
        if perramused > 95
          fileHtml.puts "<td style='background-color:#f4a5a1'>#{perramused}%</td>"
        else
          fileHtml.puts "<td>#{perramused}%</td></tr>"
        end

        
        #puts " #{tenname[j]} #{coresused} #{totalcores} #{percoresused} #{ramused} #{totalram} #{perramused}"
      
	end

      fileHtml.puts "</table>"
      fileHtml.puts "</body></html>"
      fileHtml.close()

end
