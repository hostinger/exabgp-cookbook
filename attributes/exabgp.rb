default['exabgp']['local_as'] = 123_45
default['exabgp']['peer_as'] = 123_45
default['exabgp']['community'] = [0]

default['exabgp']['hold_time'] = 20
default['exabgp']['local_preference'] = nil

default['exabgp']['ipv4']['neighbor'] = nil
default['exabgp']['ipv4']['anycast'] = []
default['exabgp']['ipv4']['enable_static_route'] = true

default['exabgp']['ipv6']['neighbor'] = nil
default['exabgp']['ipv6']['anycast'] = []

default['exabgp']['source_version'] = 'master'
default['exabgp']['bin_path'] = '/usr/local/bin/exabgp'
default['exabgp']['config_path'] = '/etc/exabgp/exabgp.conf'
default['exabgp']['script_path'] = '/etc/exabgp/exabgp.sh'
default['exabgp']['src_path'] = '/usr/src/exabgp'

default['exabgp']['watchdog_flag_file'] = '/tmp/exabgp-announce'

default['exabgp']['exazk']['enable'] = false
default['exabgp']['exazk']['name'] = 'HA test'
default['exabgp']['exazk']['refresh_interval'] = 5
default['exabgp']['exazk']['routes'] = %w()
default['exabgp']['exazk']['zookeeper']['connection'] = 'localhost:2181/exazk'
default['exabgp']['exazk']['zookeeper']['path'] = '/mutex'

default['exabgp']['systemd']['enabled'] = File.open('/proc/1/comm').gets.chomp == 'systemd'
default['exabgp']['systemd']['after'] = %w(network.target)

default['exabgp']['hubot']['enable'] = false
default['exabgp']['hubot']['url'] = 'http://localhost:9998'
default['exabgp']['hubot']['secret'] = 'secret'
default['exabgp']['hubot']['event'] = 'sre'

default['exabgp']['python']['version'] = '2.7.18'
default['exabgp']['python']['path'] = '/usr/local/pyenv/shims'

default['exabgp']['env_path'] = "/usr/local/pyenv/versions/#{node['exabgp']['python']['version']}/etc/exabgp/exabgp.env"

default['pyenv']['git_ref'] = '1.2.26'
