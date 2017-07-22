#!/usr/local/bin/ruby -w
# encoding: UTF-8
require 'net/http'
require 'open-uri'
require 'json'
require 'socket'
require 'optparse'

def banner()
red = "\033[01;31m"
green = "\033[01;32m"


puts "\n"
puts"██╗  ██╗ █████╗ ████████╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗ "
puts"██║  ██║██╔══██╗╚══██╔══╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗"
puts"███████║███████║   ██║       ██║     ██║     ██║   ██║██║   ██║██║  ██║"
puts"██╔══██║██╔══██║   ██║       ██║     ██║     ██║   ██║██║   ██║██║  ██║"
puts"██║  ██║██║  ██║   ██║       ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝"
puts"╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ "
                                                                       


puts "#{red}Tool for identifying real IP of CloudFlare protected website." 
puts "#{green}\x41\x75\x74\x68\x6f\x72\x3a\x20\x4d\x61\x74\x65\x75\x73\x20\x61\x2e\x6b\x2e\x61\x20\x44\x63\x74\x6f\x72\x2e\x20\x2d\x20\x48\x61\x74\x42\x61\x73\x68\x20\x42\x52"
puts "#{green}\x4d\x65\x6d\x62\x65\x72\x73\x20\x48\x61\x74\x42\x61\x73\x68\x42\x52\x3a\x20\x45\x76\x65\x72\x74\x6f\x6e\x20\x61\x2e\x6b\x2e\x61\x20\x20\x58\x47\x55\x34\x52\x44\x31\x34\x4e\x2c\x20\x4a\x75\x6e\x69\x6f\x72\x20\x61\x2e\x6b\x2e\x61\x20\x41\x53\x54\x41\x52\x4f\x54\x48\x20\x2c\x20\x55\x72\x64\x53\x79\x73\x20\x61\x2e\x6b\x2e\x61\x20\x4a\x6f\x68\x6e\x6e\x79\x2c\x20\x4e\x6f\x20\x6f\x6e\x65\x2c\x20\x47\x65\x6f\x76\x61\x6e\x65\x2c\x20\x52\x48\x6f\x6f\x64"
puts "fb.com/hatbashbr/"
puts "github.com/hatbashbr/"  

puts "\n"                                        
end

options = {:bypass => nil, :massbypass => nil}
parser = OptionParser.new do|opts|
   
    opts.banner = "Example: ruby cloudhat.rb -b <your target> or ruby cloudhat.rb --byp <your target>"
    opts.on('-b ','--byp ', 'Discover real IP (bypass CloudFlare)', String)do |bypass|
    options[:bypass]=bypass;
    end
    
    opts.on('-o', '--out', 'Next release.', String) do |massbypass|
        options[:massbypass]=massbypass
       
    end 
    
    opts.on('-h', '--help', 'Help') do
        banner()
        puts opts
        puts "Example: ruby cloudhat.rb -b discordapp.com or ruby cloudhat.rb --byp discordapp.com"
        exit
    end
end
 
parser.parse!
 

banner()

if options[:bypass].nil?
    puts "Insert URL -b or --byp"
else
option = options[:bypass]
payload = URI ("http://www.crimeflare.com/cgi-bin/cfsearch.cgi")
    request = Net::HTTP.post_form(payload, 'cfS' => options[:bypass])
        
        response =  request.body 
regex = /(\d*\.\d*\.\d*\.\d*)/.match(response)
    ip_real = IPSocket.getaddress (options[:bypass])
    
    puts "[+] Site analysis: #{option} "
    puts "[+] CloudFlare IP is #{ip_real} "
    puts "[+] Real IP is #{regex}"
        target = "http://ipinfo.io/#{regex}/json"
        url = URI(target).read
        json = JSON.parse(url)
    puts "[+] Hostname: " + json['hostname']
    puts "[+] City: "  + json['city']
    puts "[+] Region: " + json['country']
    puts "[+] Location: " + json['loc']
    puts "[+] Organization: " + json['org']

end
