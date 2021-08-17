package 'git-core'

git '/usr/src/exabgp' do
  repository 'https://github.com/Exa-Networks/exabgp.git'
  reference node['exabgp']['source_version']
  checkout_branch node['exabgp']['source_version']
  action :sync
  notifies :run, 'execute[restart-exabgp]' unless node['exabgp']['systemd']['enabled']
  notifies :restart, 'service[exabgp]' if node['exabgp']['systemd']['enabled']
end

node.normal['exabgp']['bin_path'] = '/usr/src/exabgp/sbin/exabgp'

include_recipe 'exabgp::default'
