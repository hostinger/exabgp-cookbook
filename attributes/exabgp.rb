default[:exabgp][:local_as] = 12345
default[:exabgp][:peer_as] = 12345
default[:exabgp][:community] = [0]

default[:exabgp][:hold_time] = 20
default[:exabgp][:local_preference] = nil

default[:exabgp][:ipv4][:neighbor] = nil
default[:exabgp][:ipv4][:anycast] = ['127.0.0.2/32']
default[:exabgp][:ipv4][:enable_static_route] = true

default[:exabgp][:ipv6][:neighbor] = nil
default[:exabgp][:ipv6][:anycast] = ['::1/128']

default[:exabgp][:source_version] = 'master'
default[:exabgp][:bin_path] = '/usr/local/bin/exabgp'

default[:exabgp][:watchdog_flag_file] = '/tmp/exabgp-announce'

default[:exabgp][:hubot][:enable] = false
default[:exabgp][:hubot][:url] = 'http://localhost:9998'
default[:exabgp][:hubot][:secret] = 'secret'
default[:exabgp][:hubot][:event] = 'sre'
