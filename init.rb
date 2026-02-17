# plugins/redmine_ldap_sync/init.rb
# Compatible with Redmine 6.1.1 + Rails 7.2 + Ruby 3.4
require 'set'

require 'redmine'
require File.expand_path('lib/ldap_sync/entity_manager', __dir__)

Redmine::Plugin.register :redmine_ldap_sync do
  name 'Redmine LDAP Sync'
  author 'Ricardo Santos'
  author_url 'https://github.com/thorin'
  description 'Syncs users and groups with ldap'
  url 'https://github.com/joseturegano/redmine_ldap_sync'
  version '2.2.0-panel'
  requires_redmine version_or_higher: '6.0.0'

  settings default: HashWithIndifferentAccess.new
  menu :admin_menu, :ldap_sync,
       { controller: 'ldap_settings', action: 'index' },
       caption: :label_ldap_synchronization,
       html: { class: 'icon icon-ldap-sync' }
end

# Load core extensions once (they patch Ruby/Rails stdlib, not Redmine classes)
require File.join(__dir__, 'lib', 'ldap_sync', 'core_ext')

# Load infector modules once (module definitions only)
Dir[File.join(__dir__, 'lib', 'ldap_sync', 'infectors', '*.rb')].sort.each { |f| require f }

# Load hooks once
require File.join(__dir__, 'lib', 'ldap_sync', 'hooks')

# Apply patches on each code reload (Zeitwerk-compatible for Rails 7.2)
# When Zeitwerk reloads User/AuthSourceLdap, patches must be re-applied
Rails.configuration.to_prepare do
  if defined?(AuthSourceLdap) && defined?(LdapSync::Infectors::AuthSourceLdap)
    unless AuthSourceLdap < LdapSync::Infectors::AuthSourceLdap
      AuthSourceLdap.include LdapSync::Infectors::AuthSourceLdap
    end
  end

  if defined?(User) && defined?(LdapSync::Infectors::User)
    unless User.included_modules.include?(LdapSync::Infectors::User)
      User.include LdapSync::Infectors::User
    end
  end
end
