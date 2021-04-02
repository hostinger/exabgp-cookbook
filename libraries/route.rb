def route(version = 'ipv4')
  anycast_ip = node['exabgp'][version]['anycast']
  return anycast_ip.kind_of?(String) ? [anycast_ip] : anycast_ip
end

def ipv6_next_hop_link_local
  default_if = node['network']['default_inet6_interface']
  node['network']['interfaces'][default_if]['addresses'].each do |address, opts|
    next unless opts['scope'] == 'Link' && opts['family'] == 'inet6'

    return address
  end
end

def ipv6_next_hop
  ipv6_next_hop_link_local || node['ip6address']
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
  node['exabgp']['exazk']['routes'].map do |route|
    "%s route #{route} next-hop #{exabgp_next_hop(route)}\n"
  end
end
