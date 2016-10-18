def route(version = 'ipv4')
  anycast_ip = node['exabgp'][version]['anycast']
  return anycast_ip.kind_of?(String) ? [anycast_ip] : anycast_ip
end

def ipv6_next_hop
  cmd = Mixlib::ShellOut.new("ip route get #{node['exabgp']['ipv6']['neighbor']}")
  cmd.run_command
  next_hop = cmd.stdout.match(/src ([\w\d\:]+)/)[1] unless cmd.stdout.empty?
  next_hop || node['ip6address']
end

def exabgp_next_hop(ip)
  ipv6_global = IPAddr.new('2000::/3')
  if ipv6_global.include? ip
    ipv6_next_hop
  else
    node['ipaddress']
  end
end

def exabgp_exazk_routes
  node[:exabgp][:exazk][:routes].map do |route|
    "%s route #{route} next-hop #{exabgp_next_hop(route)}\n"
  end
end
