#
# Cookbook Name:: exabgp
# Recipe:: default
#
# Copyright 2012, DNSimple, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

systemd_enabled = File.open('/proc/1/comm').gets.chomp == 'systemd'

include_recipe 'build-essential::default' if node['exabgp']['exazk']['enable']
include_recipe 'runit' unless systemd_enabled

pyenv_system_install 'system'
pyenv_python node['exabgp']['python']['version']
pyenv_global node['exabgp']['python']['version']

pyenv_pip 'exabgp' unless node['recipes'].include? 'exabgp::source'

directory '/etc/exabgp'

template 'exabgp: config' do
  path node['exabgp']['config_path']
  source 'exabgp.conf.erb'
  variables( router_id: node['ipaddress'],
             hold_time: node['exabgp']['hold_time'],
             neighbor_ipv4: node['exabgp']['ipv4']['neighbor'],
             local_address_ipv4: node['ipaddress'],
             local_preference: node['exabgp']['local_preference'],
             route_ipv4: route('ipv4'),
             enable_ipv4_static_route: node['exabgp']['ipv4']['enable_static_route'],
             enable_hubot: node['exabgp']['hubot']['enable'],
             enable_exazk: node['exabgp']['exazk']['enable'],
             exazk_routes: node['exabgp']['exazk']['routes'],
             neighbor_ipv6: node['exabgp']['ipv6']['neighbor'],
             local_address_ipv6: node['ip6address'],
             route_ipv6: route('ipv6'),
             local_as: node['exabgp']['local_as'],
             peer_as: node['exabgp']['peer_as'],
             community: node['exabgp']['community'].join(' '))
  mode 0o0644
  notifies :run, 'execute[reload-exabgp-config]' unless systemd_enabled
  notifies :reload, 'service[exabgp]' if systemd_enabled
end

template '/etc/exabgp/neighbor-changes.rb' do
  source 'neighbor-changes.rb.erb'
  variables hubot_publish: {
              url: node['exabgp']['hubot']['url'],
              secret: node['exabgp']['hubot']['secret'],
              event: node['exabgp']['hubot']['event']
            }
  mode 0o0755
  notifies :run, 'execute[reload-exabgp-config]' unless systemd_enabled
  notifies :reload, 'service[exabgp]' if systemd_enabled
end

template '/etc/exabgp/exazk.rb' do
  variables config: node['exabgp']['exazk'],
            routes: exabgp_exazk_routes
  mode 0o0755
  notifies :run, 'execute[reload-exabgp-config]' unless systemd_enabled
  notifies :reload, 'service[exabgp]' if systemd_enabled
  only_if { node['exabgp']['exazk']['enable'] }
end

gem_package 'exazk' if node['exabgp']['exazk']['enable']

execute 'reload-exabgp-config' do
  action :nothing
  command 'sv 2 exabgp'
end

runit_service 'exabgp' do
  default_logger true
end unless systemd_enabled

systemd_service 'exabgp' do
  unit_description 'ExaBGP service'
  unit_after node['exabgp']['systemd']['after']
  unit_requires node['exabgp']['systemd']['requires'] if node['exabgp']['systemd']['requires']
  unit_condition_path_exists node['exabgp']['config_path']
  service_environment 'exabgp_daemon_daemonize' => 'false'
  service_exec_start "#{node['exabgp']['bin_path']} #{node['exabgp']['config_path']}"
  service_exec_reload '/bin/kill -s USR1 $MAINPID'
  service_user 'nobody'
  install_wanted_by 'multi-user.target'
  only_if { systemd_enabled }
end

service 'exabgp' do
  action %i[enable start]
  only_if { systemd_enabled }
end
