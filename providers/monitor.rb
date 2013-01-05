action :create do
  settings = new_resource.settings
  checks   = new_resource.checks

  gamekeeper_install settings

  # Max memory calculation
  memory      = node['memory']['total'].chomp("kB").to_i / 1024 / 1024
  memory_crit = memory * new_resource.high_watermark
  memory_warn = memory_crit / 1.5

  # Default node check
  node_health = checks['node.health'] || {}

  # Merge in rabbitmq_node check defaults
  checks['node.health'] = {
    'check'    => GameKeeper::Nagios::NODE,
    'name'     => new_resource.node_name,
    'messages' => [10_000_000, 20_000_000],
    'memory'   => ["%.1f" % memory_warn, "%.1f" % memory_crit]
  }.merge(node_health)

  nagios = GameKeeper::Nagios.new(settings, checks)

  Chef::Log.info("GameKeeper NRPE Entries: #{nagios.nrpe_entries.keys.inspect}")
  Chef::Log.info("GameKeeper Nagios Attributes: #{nagios.service_checks.keys.inspect}")

  # Add nrpe entries
  nrpe_check "gamekeeper" do
    checks nagios.nrpe_entries
  end

  # Expand the nagios => services => gamekeeper node attributes
  node.set['nagios']['services']['gamekeeper'] = nagios.service_checks

end
