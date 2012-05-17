hosts.each do |host|
# TODO: move this to a generic setup step for module testing
step "clone puppetlabs-mysql (HAAACK)"
on host, "test -d /etc/puppet/modules/mysql || git clone git://github.com/puppetlabs/puppetlabs-mysql /etc/puppet/modules/mysql"
end

step "install mysql and launch the service"
apply_manifest_on(hosts, "class {'mysql':} class {'mysql::server':}")

step "verify mysql is installed"
#TODO
