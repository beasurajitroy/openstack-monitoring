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
require 'net/https'
require 'ipaddr'


cloud=["dal1"].each do |filename|
file=Hash[*File.read("#{filename}.txt").split(/[, \n]+/)].to_json
$properties=JSON.parse(file)

keystone_uri = URI.parse("https://#{$properties["cloudapihost"]}:5443/v2.0/tokens")
@toSend = {
	"auth" => {
                "tenantName" => "admin",
                "passwordCredentials" => {
                      "username" => "iaasops",
                      "password" => "sroy"

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
 # puts keystone_request.body
 # Send the keystone request
 keystone_response = keystone_http.request(keystone_request)
 # puts keystone_response.body
 if keystone_response.code == "200"
  result = JSON.parse(keystone_response.body)
  token=result["access"]["token"]["id"]
  issuedat=result["access"]["token"]["issued_at"]
  tenantid=result["access"]["token"]["tenant"]["id"]
  #puts tenantid
  #puts token

  else

  puts "Error connecting to keystone api for generating authentication token"
  #send_email "sroy@sroylabs.com", :body => "This was for testing to send"
 end 

      ipused=0
      ipleft=0
      ipavailable=Array[]
      usedcount=Array[]
      subnetid=Array[]
      netname=Array[]
      netid=Array[]

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

###
### Get Total IP Count
###

      subnetlist = URI("https://#{$properties["cloudapihost"]}:9696/v2.0/subnets")
      subnetlist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }
      subnetlist_http = Net::HTTP.new(subnetlist.host, subnetlist.port)
      subnetlist_http.use_ssl = true
      subnetlist_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      subnetlist_request = Net::HTTP::Get.new(subnetlist.request_uri,subnetlist_headers)
      subnetlist_response = subnetlist_http.request(subnetlist_request)
      subnetlistdata = JSON.parse(subnetlist_response.body)

       subnetlistdata["subnets"].length.times do |j|
        subnetid.push("#{subnetlistdata["subnets"][j]["network_id"]}")
        subnet=subnetlistdata["subnets"][j]["cidr"]
        #puts "#{j}.net id: #{subnetid[j]}"
        #puts "#{j}.cidr: #{subnet}"
        subnetipavailable=IPAddr.new(subnet).to_range.count-2 
        reservedsubnetip=(subnetipavailable/256)*2 + 10
        ipavailable[j]=(subnetipavailable-reservedsubnetip)
        #puts "#{j}.ipavailable: #{ipavailable}"
      end


###
###  Total IP Used
###

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

fileHtml = File.new("dal1ipstatus.html", "w+")
fileHtml.puts "<html>"
fileHtml.puts "<head><link rel='stylesheet' type='text/css' href='style.css'></head>"
fileHtml.puts "<body bgcolor='#2E2E2E'><br><br>"
fileHtml.puts "<table style='width:100%'  class='hovertable'><tr>"
fileHtml.puts "<th align='center' style='font-size:14px; background-color:#f6e0ab;'> IP Availability Report for DAL1</th></tr></table>"
fileHtml.puts "<br>"
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

fileHtml.puts "</table></body></html>"
fileHtml.close()
end
