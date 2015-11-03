###Program to get the data from Openstack and store it in ES######
###Author: Surajit#######


#require 'rubygems' - for ruby 1.8
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


def email(subject,message)

emailtime=Time.now.utc.iso8601(3)
msgstr = <<END_OF_MESSAGE
From: Your Name <GECTSDIA38@email.wal-mart.com>
To: Destination Address <sroy@xxxxxlabs.com>
Subject: #{subject}
Date: #{emailtime}
  #{message}
END_OF_MESSAGE


Net::SMTP.start('smtp-gw1.wal-mart.com', 25) do |smtp|
  smtp.send_message msgstr,
                    'GECTSDIA38@email.wal-mart.com',
                    'sroy@xxxxxlabs.com','CloudDevo@email.wal-mart.com'
  puts "Message Sent"                  
end
end

def is_port_open?(ip, port)
  begin
    Timeout::timeout(2) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        #puts "#{ip} accesible"
        $canconnect=true
        return true

      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        #puts "connection refused or hostnot reachable"
        return false
      end
    end
  rescue Timeout::Error
    #puts "time out #{ip}"
    $canconnect=false
    $activebutnotsshcounts=$activebutnotsshcounts+1
  end

  return false
end




 
class Graphite
  def initialize(host)
    @host = host
  end
 
  def socket
    return @socket if @socket && !@socket.closed?
    @socket = TCPSocket.new(@host, 2003)
  end
 
  def report(key, value, time = Time.now)
    begin
      socket.write("#{key} #{value.to_f} #{time.to_i}\n")
    rescue Errno::EPIPE, Errno::EHOSTUNREACH, Errno::ECONNREFUSED
      @socket = nil
      nil
    end
  end
 
  def close_socket
    @socket.close if @socket
    @socket = nil
  end
end


#Encrypt and decrypt password using irb
#irb
#>password="xxxxxxx"
#>crypted_password = password.encrypt(:symmetric, :password => 'yyyyyyyyy')
#> puts crypted_password
#>"xxxxxxx".decrypt(:symmetric, :password => "yyyyyyyy")

#=begin

scheduler = Rufus::Scheduler.new
scheduler.every '300s' do
cloud=["dal1"].each do |filename|
file=Hash[*File.read("#{filename}.txt").split(/[, \n]+/)].to_json
$properties=JSON.parse(file)
#puts $properties["log"]




########################################################################################################################################################
#                                                 Keystone request
########################################################################################################################################################
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
  
  $token = result["access"]["token"]["id"]
  tenantid=result["access"]["token"]["tenant"]["id"]
  #puts tenantid
  puts $token

else

	puts "Error connecting to keystone api for generating authentication token"
  #send_email "sroy@xxxxxlabs.com", :body => "This was for testing to send"
end 

ElasticSearchData||={}
ElasticSearchData.clear
puts "Empty any data for ElasticSearchData"
puts ElasticSearchData
ElasticSearchCompatibleResponse||={}
ElasticSearchCompatibleResponse.clear
puts "Empty any data for ElasticSearchCompatibleResponse" 
puts ElasticSearchCompatibleResponse




 
#--------------------------------------------------------------------------x----------------------------------------------------------------------------
#GET THE TENANTS ID BASED ON THE TENANT NAME IF required but this is another hop so skipping it

#tenantlist = URI("http://#{properties["cloudapihost"]}:5000/v2.0/tenants?admin")
#tenantlist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{token}" }

#tenantlist_http = Net::HTTP.new(tenantlist.host, tenantlist.port)
#tenantlist_request = Net::HTTP::Get.new(tenantlist.request_uri,tenantlist_headers)

#tenantlist_response = tenantlist_http.request(tenantlist_request)
#puts tenantlist_response.body

########################################################################################################################################################
#                                                 Service list to Openstack
########################################################################################################################################################

servicelist = URI("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/os-services")
servicelist_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{$token}" }

servicelist_http = Net::HTTP.new(servicelist.host, servicelist.port)

servicelist_http.use_ssl = true
servicelist_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

servicelist_request = Net::HTTP::Get.new(servicelist.request_uri,servicelist_headers)

servicelist_response = servicelist_http.request(servicelist_request)
puts "Service list is parsed"
#puts servicelist_response.body


servicelistdata = JSON.parse(servicelist_response.body)
#puts servicelistdata

hypervisorstateupcount=0
hypervisorstatedowncount=0
hypervisormaintenancecount=0
controllerconductorstateupcount=0
controllerconductorstatedowncount=0
controllerschedulerstateupcount=0
controllerschedulerstatedowncount=0

servicelistdata["services"].length.times do |i|
      if servicelistdata["services"][i]["binary"] == "nova-compute" and servicelistdata["services"][i]["state"] == "up" and servicelistdata["services"][i]["status"] == "enabled"
        hypervisorstateupcount=hypervisorstateupcount+1
          else if servicelistdata["services"][i]["binary"] == "nova-compute" and servicelistdata["services"][i]["state"] == "down" and servicelistdata["services"][i]["status"] == "enabled"
                hypervisorstatedowncount=hypervisorstatedowncount+1
            else if servicelistdata["services"][i]["binary"] == "nova-conductor" and servicelistdata["services"][i]["state"] == "up"
                  controllerconductorstateupcount=controllerconductorstateupcount+1
              else if servicelistdata["services"][i]["binary"] == "nova-conductor" and servicelistdata["services"][i]["state"] == "down"
                  controllerconductorstatedowncount=controllerconductorstatedowncount+1  
                else if servicelistdata["services"][i]["binary"] == "nova-scheduler" and servicelistdata["services"][i]["state"] == "up" 
                        controllerschedulerstateupcount=controllerschedulerstateupcount+1
                  else if servicelistdata["services"][i]["binary"] == "nova-scheduler" and servicelistdata["services"][i]["state"] == "down" 
                            controllerschedulerstatdowncount=controllerschedulerstatedowncount+1 
                         else if servicelistdata["services"][i]["binary"] == "nova-compute" and servicelistdata["services"][i]["status"] == "disabled"
                               hypervisormaintenancecount=hypervisormaintenancecount+1 
                              
                         end
                    end
                end
              end
            end
          end 
      end           
    
      ElasticSearchData["TotalHypervisors"]=hypervisorstateupcount+hypervisorstatedowncount+hypervisormaintenancecount
      ElasticSearchData["Hypervisors-nova-compute-UP"]= hypervisorstateupcount
      ElasticSearchData["Hypervisors-nova-compute-DOWN"]= hypervisorstatedowncount
      ElasticSearchData["TotalControllers"]=controllerconductorstateupcount+controllerconductorstatedowncount
      ElasticSearchData["Controller-nova-conductor-UP"]=controllerconductorstateupcount
      ElasticSearchData["Controller-nova-conductor-DOWN"]=controllerconductorstatedowncount
      ElasticSearchData["Controller-nova-scheduler-UP"]=controllerschedulerstateupcount
      ElasticSearchData["Controller-nova-scheduler-DOWN"]=controllerschedulerstatedowncount
      ElasticSearchData["Hypervisors-maintenance"]=hypervisormaintenancecount
      #if needed you can get all the other values like below
      #ElasticSearchData[servicelistdata["services"][i]["host"]] = servicelistdata["services"][i]["binary"]+"-"+servicelistdata["services"][i]["status"]+"-"+servicelistdata["services"][i]["state"]
end

#puts "new content for ElasticSearchData for service list"
#puts ElasticSearchData

#puts "After Service list is parsed"
#puts servicelistdata      
#servicelist_modifiedresponse=servicelistnewdata.to_json  
#puts  servicelist_modifiedresponse

#--------------------------------------------------------------------------x----------------------------------------------------------------------------
########################################################################################################################################################
#                                                 Hypervisor Statistics
########################################################################################################################################################

hypervisorstats = URI("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/os-hypervisors/statistics")
hypervisorstats_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{$token}" }

hypervisorstats_http = Net::HTTP.new(hypervisorstats.host, hypervisorstats.port)

hypervisorstats_http.use_ssl = true
hypervisorstats_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

hypervisorstats_request = Net::HTTP::Get.new(hypervisorstats.request_uri,hypervisorstats_headers)

hypervisorstats_response = hypervisorstats_http.request(hypervisorstats_request)
#puts hypervisorstats_response.body


hypervisorstatsdata = JSON.parse(hypervisorstats_response.body)
ElasticSearchData["Hypervisors_ALL"]=hypervisorstatsdata["hypervisor_statistics"]["count"]
ElasticSearchData["vcpus_used"]=hypervisorstatsdata["hypervisor_statistics"]["vcpus_used"]
ElasticSearchData["local_gb_used"]=hypervisorstatsdata["hypervisor_statistics"]["local_gb_used"]
ElasticSearchData["memory_mb"]=hypervisorstatsdata["hypervisor_statistics"]["memory_mb"]
ElasticSearchData["current_workload"]=hypervisorstatsdata["hypervisor_statistics"]["current_workload"]
ElasticSearchData["vcpus"]=hypervisorstatsdata["hypervisor_statistics"]["vcpus"]
ElasticSearchData["running_vms"]=hypervisorstatsdata["hypervisor_statistics"]["running_vms"]
ElasticSearchData["free_disk_gb"]=hypervisorstatsdata["hypervisor_statistics"]["free_disk_gb"]
ElasticSearchData["disk_available_least"]=hypervisorstatsdata["hypervisor_statistics"]["disk_available_least"]
ElasticSearchData["local_gb"]=hypervisorstatsdata["hypervisor_statistics"]["local_gb"]
ElasticSearchData["free_ram_mb"]=hypervisorstatsdata["hypervisor_statistics"]["free_ram_mb"]
ElasticSearchData["memory_mb_used"]=hypervisorstatsdata["hypervisor_statistics"]["memory_mb_used"]

#puts  servicelist_modifiedresponse
puts "hypervisor state list is parsed"
puts "new content for ElasticSearchData for hypervisor state list"
#puts ElasticSearchData



########################################################################################################################################################
#                                                 VM STATE STATUS
########################################################################################################################################################
class VMstate
  def initialize(uri)
    @uri=uri
  end

  def parse
    puts "fire" "#{@uri}"
    vmstate = URI(@uri)

    vmstate_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{$token}" }
    vmstate_http = Net::HTTP.new(vmstate.host, vmstate.port)

    vmstate_http.use_ssl = true
    vmstate_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    vmstate_request = Net::HTTP::Get.new(vmstate.request_uri,vmstate_headers)
    vmstate_response ||= vmstate_http.request(vmstate_request)
    #puts vmstate_response.body
    vmstatedata = JSON.parse(vmstate_response.body)
    begin
     
    $x=vmstatedata.has_key?("servers_links")
    puts $x
     
     #puts vmstatedata["servers_links"][0]["href"]
     $markerfornext=""
     marker||=vmstatedata["servers_links"][0]["href"].to_s.split("marker=").last
     puts marker
     $markerfornext=marker
     puts "Exiting marker check"
    rescue
    end   
         
    vmstatedata["servers"].length.times do |i| 
      createdtimestamp=vmstatedata["servers"][i]["created"]
      createdepoctime=Time.parse(createdtimestamp)
      if (Time.now.to_f - createdepoctime.to_f) < 300
        $vmcreated=$vmcreated+1
      end

      case vmstatedata["servers"][i]["status"] 
      when "ACTIVE"
        $activecounts=$activecounts+1
        #puts vmstatedata["servers"][i]["status"]
        #begin
           #is_port_open?("#{vmstatedata["servers"][i]["addresses"]["Primary_External_Net"][0]["addr"]}", 22)
           #puts "Active non ssh count #{$activebutnotsshcounts}"
           #rescue
           #     next
        #end
      when "HARD_REBOOT"  
        $hardrebootcounts=$hardrebootcounts+1
      when "SHUTOFF"  
        $shutoffcounts=$shutoffcounts+1
      end
        $totalVMs=$totalVMs+1
     
      begin
      log = Logger.new("#{$properties["log"]}", 'daily', 15)
      log.level = Logger::DEBUG
         log.info("#{$properties["tenant"]} #{vmstatedata["servers"][i]["updated"]} #{vmstatedata["servers"][i]["addresses"]["Primary_External_Net"][0]["addr"]} #{vmstatedata["servers"][i]["id"]} #{vmstatedata["servers"][i]["status"]} #{vmstatedata["servers"][i]["metadata"]["organization"]} #{vmstatedata["servers"][i]["OS-EXT-SRV-ATTR:host"]} #{vmstatedata["servers"][i]["OS-EXT-AZ:availability_zone"]} #{vmstatedata["servers"][i]["image"]["id"]} null")
      log.close
      rescue
        puts $!, $@
        next    # do_something_* again, with same i
      end
    end
end  
end     

$activecounts=0
$hardrebootcounts=0
$shutoffcounts=0
$totalVMs=0
$vmcreated=0


vmstatus=VMstate.new("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/servers/detail?all_tenants=1&&limit=1000")
vmstatus.parse


while $x == true do
     puts $activecounts
     puts $hardrebootcounts
     puts $shutoffcounts
     puts $vmcreated

   puts $markerfornext
   vmstatusnext1=VMstate.new("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/servers/detail?all_tenants=1&&limit=1000&marker=#{$markerfornext}")
   vmstatusnext1.parse
end   
      ElasticSearchData["activeVMs"]=$activecounts
      ElasticSearchData["hard_rebootVMs"]=$hardrebootcounts
      ElasticSearchData["shutoffVMs"]=$shutoffcounts
      ElasticSearchData["vmcreated"]=$vmcreated


puts $activecounts
puts $hardrebootcounts
puts $shutoffcounts
puts $vmcreated

ElasticSearchData["totalVMs"]= $totalVMs

    vmdeleted=0
    vmdeletestate = URI("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/servers/detail?all_tenants=1&deleted=True")

    vmdeletestate_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{$token}" }
    vmdeletestate_http = Net::HTTP.new(vmdeletestate.host, vmdeletestate.port)

    vmdeletestate_http.use_ssl = true
    vmdeletestate_http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    vmdeletestate_request = Net::HTTP::Get.new(vmdeletestate.request_uri,vmdeletestate_headers)
    vmdeletestate_response ||= vmdeletestate_http.request(vmdeletestate_request)
        #puts vmdeletestate_response.body
    vmdeletestatedata = JSON.parse(vmdeletestate_response.body)
        #puts vmdeletestatedata


    vmdeletestatedata["servers"].length.times do |i| 
        deletedtimestamp1=vmdeletestatedata["servers"][i]["updated"]
        #deletedinsname1=vmdeletestatedata["servers"][i]["OS-EXT-SRV-ATTR:instance_name"]
        #puts "#{deletedtimestamp1} --- #{deletedinsname1}"
  
    deletedepoctime1=Time.parse(deletedtimestamp1)
       if (Time.now.to_f - deletedepoctime1.to_f) < 300
        #puts "#{deletedinsname1} -- #{deletedepoctime1.to_f} -- #{Time.now.to_f}"
        vmdeleted = vmdeleted+1
       end  
    end
        puts "Total VM deleted in DAL1 for past 5 mins ==> #{vmdeleted}"

    ElasticSearchData["deletedVMs"]= "#{vmdeleted}"





puts ElasticSearchData

time = Time.new
timestamp=Time.now.utc.iso8601(3)
# Components of a Time
#puts "Current Time : " + time.inspect
#puts time.year    # => Year of the date 
#puts time.month   # => Month of the date (1 to 12)
#puts time.day     # => Day of the date (1 to 31 )
#puts time.wday    # => 0: Day of week: 0 is Sunday
#puts time.yday    # => 365: Day of year
#puts time.hour    # => 23: 24-hour clock
#puts time.min     # => 59
#puts time.sec     # => 59
#puts time.usec    # => 999999: microseconds
#puts time.zone    # => "UTC": timezone name      

ElasticSearchData["@timestamp"]= "#{timestamp}"
ElasticSearchCompatibleResponse=ElasticSearchData.to_json  
puts "Converting to ES compatible"+ ElasticSearchCompatibleResponse

#--------------------------------------------------------------------------x----------------------------------------------------------------------------

          data=Graphite.new("#{$properties["graphite"]}")

          ElasticSearchData.each_pair do |key,value|
                     data.socket
                     data.report("#{$properties["tenant"]}.openstack.#{key}".to_s, "#{value}", )
                     data.close_socket
         end
end
end


scheduler = Rufus::Scheduler.new
scheduler.every '1h' do

cloud=["dal1"].each do |filename|
file=Hash[*File.read("#{filename}.txt").split(/[, \n]+/)].to_json
$properties=JSON.parse(file)
puts $properties["log"]




########################################################################################################################################################
#                                                 Keystone request
########################################################################################################################################################
keystone_uri = URI.parse("https://#{$properties["cloudapihost"]}:5443/v2.0/tokens")
@toSend = {
  "auth" => {
                "tenantName" => "admin",
                "passwordCredentials" => {
                      "username" => "sulagan",
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
  
  $token = result["access"]["token"]["id"]
  tenantid=result["access"]["token"]["tenant"]["id"]
  puts tenantid
  puts $token

else

  puts "Error connecting to keystone api for generating authentication token"
  #send_email "sroy@xxxxxlabs.com", :body => "This was for testing to send"
end 

GraphiteData||={}
GraphiteData.clear
puts "Empty any data for Data"
puts GraphiteData

$activebutnotsshcounts=0
unless defined?($canconnect)
 $canconnect=true
end

class VMstatessh
  def initialize(uri)
    @uri=uri
  end

  def parse
    puts "fire" "#{@uri}"
    vmstate = URI(@uri)

    vmstate_headers = { 'User-Agent'=> 'python-keystoneclient','X-Auth-Token'=> "#{$token}" }
    vmstate_http = Net::HTTP.new(vmstate.host, vmstate.port)
    vmstate_http.use_ssl = true
    vmstate_http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    vmstate_request = Net::HTTP::Get.new(vmstate.request_uri,vmstate_headers)
    vmstate_response ||= vmstate_http.request(vmstate_request)
    #puts vmstate_response.body
    vmstatedata = JSON.parse(vmstate_response.body)
    begin
     
    $x=vmstatedata.has_key?("servers_links")
    puts $x
     
     #puts vmstatedata["servers_links"][0]["href"]
     $markerfornext=""
     marker||=vmstatedata["servers_links"][0]["href"].to_s.split("marker=").last
     puts marker
     $markerfornext=marker

     puts $markerfornext.empty?
     puts "Exiting"
    rescue
    end   
         
    vmstatedata["servers"].length.times do |i|      
      case vmstatedata["servers"][i]["status"] 
      when "ACTIVE"
        #$activecounts=$activecounts+1
        #puts vmstatedata["servers"][i]["status"]
        begin
           is_port_open?("#{vmstatedata["servers"][i]["addresses"]["Primary_External_Net"][0]["addr"]}", 22)
           #puts "Active non ssh count #{$activebutnotsshcounts}"
           rescue
                next
        end
      end  
      
      begin
      log = Logger.new("#{$properties["log"]}", 'daily', 15)
      log.level = Logger::DEBUG
      log.info("#{$properties["tenant"]} #{vmstatedata["servers"][i]["updated"]} #{vmstatedata["servers"][i]["addresses"]["Primary_External_Net"][0]["addr"]} #{vmstatedata["servers"][i]["id"]} #{vmstatedata["servers"][i]["status"]} #{vmstatedata["servers"][i]["metadata"]["organization"]} #{vmstatedata["servers"][i]["OS-EXT-SRV-ATTR:host"]} #{vmstatedata["servers"][i]["OS-EXT-AZ:availability_zone"]} #{vmstatedata["servers"][i]["image"]["id"]} #{$canconnect}")
      log.close
      rescue
        puts $!, $@
        next    # do_something_* again, with same i
      end
    end
end  
end     


vmstatusssh=VMstatessh.new("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/servers/detail?all_tenants=1&&limit=1000")
vmstatusssh.parse


while $x == true do
   
   puts $markerfornext
   vmstatusnextssh=VMstatessh.new("https://#{$properties["cloudapihost"]}:8774/v2/#{tenantid}/servers/detail?all_tenants=1&&limit=1000&marker=#{$markerfornext}")
   vmstatusnextssh.parse
end   

GraphiteData["nonsshactiveVMs"]=$activebutnotsshcounts
puts $activebutnotsshcounts


time = Time.new
timestamp=Time.now.utc.iso8601(3)


          data=Graphite.new("#{$properties["graphite"]}")

          GraphiteData.each_pair do |key,value|
                     puts "#{key} #{value}"
                     data.socket

                     #data.report("test.openstack.#{key}".to_s, "#{value}", )
                     data.report("#{$properties["tenant"]}.openstack.#{key}".to_s, "#{value}", )
                     data.close_socket
         end

end
end

scheduler = Rufus::Scheduler.new
scheduler.every '600s' do

cloud=["dal1"].each do |filename|
file=Hash[*File.read("#{filename}.txt").split(/[, \n]+/)].to_json
properties=JSON.parse(file)

cephnewHealthData||={}
cephnewHealthData.clear
#puts "Empty any data for cephnew Health Data"
#puts cephnewHealthData


cephnewhealth = URI("http://#{properties["cephendpoint"]}:5000/api/v0.1/health")
cephnewhealth_headers = { 'Accept'=> 'application/json' }
cephnewhealth_http = Net::HTTP.new(cephnewhealth.host, cephnewhealth.port)
cephnewhealth_request = Net::HTTP::Get.new(cephnewhealth.request_uri,cephnewhealth_headers)
cephnewhealth_response = cephnewhealth_http.request(cephnewhealth_request)
puts "cephnew Health Data"
cephnewhealthdata = JSON.parse(cephnewhealth_response.body)

#puts cephnewhealthdata["output"]["timechecks"]["mons"]


clusterstatus = URI("http://#{properties["cephendpoint"]}:5000/api/v0.1/status")
clusterstatus_headers = { 'Accept'=> 'application/json' }
clusterstatus_http = Net::HTTP.new(clusterstatus.host, clusterstatus.port)
clusterstatus_request = Net::HTTP::Get.new(clusterstatus.request_uri,clusterstatus_headers)
clusterstatus_response = clusterstatus_http.request(clusterstatus_request)
puts "Cluster Status"
clusterstatusdata = JSON.parse(clusterstatus_response.body)
#puts clusterstatusdata

cephnewHealthData["totalosds"]= "#{clusterstatusdata["output"]["osdmap"]["osdmap"]["num_osds"]}"
cephnewHealthData["numosdsup"]= "#{clusterstatusdata["output"]["osdmap"]["osdmap"]["num_up_osds"]}"

cephnewhealthdata["output"]["timechecks"]["mons"].length.times do |i|
            
            case cephnewhealthdata["output"]["timechecks"]["mons"][i]["health"]
            when "HEALTH_OK"
              cephnewHealthData["#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["name"]}.health"]= "1"
              cephnewHealthData["#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["name"]}.latency"]= "#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["latency"]}"
              cephnewHealthData["#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["name"]}.skew"]= "#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["skew"]}"
            else  
                cephnewHealthData["#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["name"]}.health"]= "0"
                cephnewHealthData["#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["name"]}.latency"]= "#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["latency"]}"
              cephnewHealthData["#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["name"]}.skew"]= "#{cephnewhealthdata["output"]["timechecks"]["mons"][i]["skew"]}"
            end
end

puts cephnewHealthData


time = Time.new
timestamp=Time.now.utc.iso8601(3)


          data=Graphite.new("#{properties["graphite"]}")

          cephnewHealthData.each_pair do |key,value|
                     #puts "#{key} #{value}"
                     data.socket

                     #data.report("test.cephnew.mons.#{key}".to_s, "#{value}", )
                     data.report("#{properties["tenant"]}.ceph.mons.#{key}".to_s, "#{value}", )
                     data.close_socket
         end


QuorumStatusData||={}
QuorumStatusData.clear
puts "Empty any data for Quorum Status Data"
puts QuorumStatusData


quorumstatus = URI("http://#{properties["cephendpoint"]}:5000/api/v0.1/quorum_status")
quorumstatus_headers = { 'Accept'=> 'application/json' }
quorumstatus_http = Net::HTTP.new(quorumstatus.host, quorumstatus.port)
quorumstatus_request = Net::HTTP::Get.new(quorumstatus.request_uri,quorumstatus_headers)
quorumstatus_response = quorumstatus_http.request(quorumstatus_request)
puts "Quorum Status"
quorumstatusdata = JSON.parse(quorumstatus_response.body)
#puts quorumstatusdata

if quorumstatusdata["status"] == "OK"
  QuorumStatusData["status"] = "1"
else
  QuorumStatusData["status"] = "0"
end

quorumstatusdata["output"]["monmap"]["mons"].length.times do |i|
  QuorumStatusData["#{quorumstatusdata["output"]["monmap"]["mons"][i]["name"]}.quorumrank"]="#{quorumstatusdata["output"]["monmap"]["mons"][i]["rank"]}"
end

#puts QuorumStatusData

time = Time.new
timestamp=Time.now.utc.iso8601(3)


          data=Graphite.new("#{properties["graphite"]}")

          QuorumStatusData.each_pair do |key,value|
                     #puts "#{key} #{value}"
                     data.socket

                     #data.report("test.cephnew.quorum.#{key}".to_s, "#{value}", )
                     data.report("#{properties["tenant"]}.ceph.quorum.#{key}".to_s, "#{value}", )
                     data.close_socket
         end

PoolData||={}
PoolData.clear
#puts "Empty any data for Pool Status Data"
#puts PoolData

pooldump = URI("http://#{properties["cephendpoint"]}:5000/api/v0.1/pg/dump_pools_json")
pooldump_headers = { 'Accept'=> 'application/json' }
pooldump_http = Net::HTTP.new(pooldump.host, pooldump.port)
pooldump_request = Net::HTTP::Get.new(pooldump.request_uri,pooldump_headers)
pooldump_response = pooldump_http.request(pooldump_request)
puts "PG Pool Dump"
pooldumpdata = JSON.parse(pooldump_response.body)
#puts pooldumpdata

pooldumpdata["output"].length.times do |i|
  pooldumpdata["output"][i]["stat_sum"].each_pair do |key,value|
               PoolData["#{pooldumpdata["output"][i]["poolid"]}.#{key}"] = "#{value}"
           end
       end

time = Time.new
timestamp=Time.now.utc.iso8601(3)


          data=Graphite.new("#{properties["graphite"]}")

          PoolData.each_pair do |key,value|
                     #puts "#{key} #{value}"
                     data.socket

                     #data.report("test.cephnew.pool.#{key}".to_s, "#{value}", )
                     data.report("#{properties["tenant"]}.ceph.pool.#{key}".to_s, "#{value}", )
                     data.close_socket
         end




OsdPerfData||={}
OsdPerfData.clear
#puts "Empty any data for OSD Perf Data"
#puts OsdPerfData



osdperf = URI("http://#{properties["cephendpoint"]}:5000/api/v0.1/osd/perf")
osdperf_headers = { 'Accept'=> 'application/json' }
osdperf_http = Net::HTTP.new(osdperf.host, osdperf.port)
osdperf_request = Net::HTTP::Get.new(osdperf.request_uri,osdperf_headers)
osdperf_response = osdperf_http.request(osdperf_request)
puts "OSD Pool Stats"
osdperfdata = JSON.parse(osdperf_response.body)
#puts osdperfdata  

osdperfdata["output"]["osd_perf_infos"].length.times do |i|
            osdperfdata["output"]["osd_perf_infos"][i]["perf_stats"].each_pair do |key,value|
                 OsdPerfData["#{osdperfdata["output"]["osd_perf_infos"][i]["id"]}.#{key}"] = "#{value}"    
               end
           end
           #puts OsdPerfData

time = Time.new
timestamp=Time.now.utc.iso8601(3)


          data=Graphite.new("#{properties["graphite"]}")

          OsdPerfData.each_pair do |key,value|
                     #puts "#{key} #{value}"
                     data.socket

                     #data.report("test.cephnew.perf.#{key}".to_s, "#{value}", )
                     data.report("#{properties["tenant"]}.ceph.perf.#{key}".to_s, "#{value}", )
                     data.close_socket
         end

end
end



scheduler = Rufus::Scheduler.new
scheduler.every '300s' do

  cloud=["dal1"].each do |filename|
  file=Hash[*File.read("#{filename}.txt").split(/[, \n]+/)].to_json
  $properties=JSON.parse(file)

    rabbitreq = URI("http://#{$properties["cloudapihost"]}:15672/api/queues")
    rabbitreq_headers = { 'Accept'=> '*/*' }

    rabbitreq_http = Net::HTTP.new(rabbitreq.host, rabbitreq.port)
    rabbitreq_request = Net::HTTP::Get.new(rabbitreq.request_uri,rabbitreq_headers)
    rabbitreq_request.basic_auth 'sensu' , 'XMey5RntNbbJOsAseib0Pir4p2QBSb2N/w1p4cB9H0A=\n'.decrypt(:symmetric, :password => "secret_key")

    rabbitreq_response = rabbitreq_http.request(rabbitreq_request)

    rabbitdata = JSON.parse(rabbitreq_response.body)
    sum=0
    RabbitData||={}
    RabbitData.clear

    rabbitdata.length.times do |i|
        
       #puts rabbitdata[i]["messages_unacknowledged"]
        
       sum=sum+rabbitdata[i]["messages_unacknowledged"].to_i
       #puts sum
       #if rabbitdata[i]["messages_unacknowledged"] = 0 and /compute/.match("#{rabbitdata[i]["name"]}")
             #email("[#{filename}] Testing Critical RabbitMQ messages_unacknowledged in queue #{rabbitdata[i]["name"]}"," #{rabbitdata[i]["messages_unacknowledged"]}, please take necessary action")
            #else if count < 50 and count > 25
              #email("[#{filename}] Major IP Availability  NetworkID - #{networkid[j]}","IP remaining #{count}, please take necessary action")
             #else if count < 25
               #email("[#{filename}] Critical IP Availability  NetworkID - #{networkid[j]}","IP remaining #{count}, please take necessary action")
             #end
            #end
           #end
    end
    RabbitData["rabbit_total_messages_unacknowledged"]="#{sum}"
    puts RabbitData


    data=Graphite.new("#{$properties["graphite"]}")

          RabbitData.each_pair do |key,value|
                     data.socket
                     #puts "#{key} #{value}"
                     data.report("#{$properties["tenant"]}.openstack.#{key}".to_s, "#{value}", )
                     data.close_socket
         end



end
end

scheduler = Rufus::Scheduler.new
scheduler.every '4h' do

  cloud=["dal1"].each do |filename|
  file=Hash[*File.read("#{filename}.txt").split(/[, \n]+/)].to_json
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
        #send_email "sroy@xxxxxlabs.com", :body => "This was for testing to send"
      end 



####################################################################################################
### Creating HTML file
####################################################################################################

      fileHtml = File.new("#{$properties["quotahtml"]}/#{$properties["tenant"]}-status.html", "w+")

      fileHtml.puts "<html><head>"
      fileHtml.puts "<title>DAL1 STATUS</title>"
      fileHtml.puts "<style type=text/css> table.hovertable { font-family: verdana,arial,sans-serif; font-size:11px; color:#333333; border-width: 1px; border-color: #999999; border-collapse: collapse; } table.hovertable th { background-color:#c3dde0; border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } table.hovertable tr {       background-color:#d4e3e5; } table.hovertable td { border-width: 1px; padding: 8px; border-style: solid; border-color: #a9c6c9; } .btn { -webkit-border-radius: 10; -moz-border-radius: 10; border-radius: 10px; font-family: verdana,arial,sans-serif; color: #ffffff; font-size: 14px; background: #3498db; padding: 5px 20px 5px 20px; text-decoration: none; } .btn:hover { background: #5cace2; text-decoration: none;} .btn[disabled=disabled] { background: #e6cf71; text-decoration: none;  }  </style>"
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

       subnetlistdata["subnets"].length.times do |j|
        subnetid.push("#{subnetlistdata["subnets"][j]["network_id"]}")
        subnet=subnetlistdata["subnets"][j]["cidr"]
        subnetipavailable=IPAddr.new(subnet).to_range.count-2 
        reservedsubnetip=(subnetipavailable/256)*2 + 10
        ipavailable[j]=(subnetipavailable-reservedsubnetip)
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
end
scheduler.join






