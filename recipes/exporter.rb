include_recipe 'tar::default'

ee = node['exabgp']['exporter']

exabgp_exporter_binary = "#{ee['dir']}/exabgp_exporter"

directory ee['dir'] do
  owner ee['user']
  group ee['group']
  recursive true
end

remote_file exabgp_exporter_binary do
  source ee['binary_url']
  owner ee['user']
  group ee['group']
  mode 0o0755
  notifies :restart, 'service[exabgp_exporter]'
end

systemd_service 'exabgp_exporter' do
  unit_description 'exabgp_exporter (Prometheus Ecosystem)'
  install_wanted_by 'multi-user.target'
  service_type 'simple'
  service_exec_start "#{exabgp_exporter_binary} standalone"
  service_restart 'always'
  service_restart_sec 10
  service_working_directory '/'
end

service 'exabgp_exporter' do
  action %i(enable start)
end
