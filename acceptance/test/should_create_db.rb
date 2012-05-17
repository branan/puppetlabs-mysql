test_name "databases and users"

db_name = "puppet#{rand(999999).to_i}"

step "create a database with puppet"
apply_manifest_on(agents, "database { '#{db_name}': ensure => present, provider => 'mysql', charset => 'utf8'}")

agents.each do |agent|
  step "verify the database exists"
  on agent, "mysql --no-beep -e 'SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME=\"#{db_name}\"'"

  step "destroy the database"
  on agent, "mysql --no-beep -e 'drop database #{db_name}'"
end

db_name = "puppet#{rand(999999).to_i}"
user_name = "user#{rand(999999).to_i}"
user_pass = "pass#{rand(999999).to_i}"

step "create a database and user with puppet"
apply_manifest_on(agents, "class {'mysql::server':} mysql::db { '#{db_name}': user => '#{user_name}', password => '#{user_pass}' }")

agents.each do |agent|
  step "verify we can connect to the DB with the correct user"
  on agent, "mysql --user=#{user_name} --password=#{user_pass} -e 'SHOW TABLES FROM #{db_name};'"

  step "drop the database"
  on agent, "mysql --no-beep -e 'drop database #{db_name}'"

  step "drop the user"
  on agent, "mysql --no-beep -e 'drop user #{user_name}@localhost'"
end
