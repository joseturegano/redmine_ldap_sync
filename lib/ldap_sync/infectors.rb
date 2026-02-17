module LdapSync::Infectors
  # Module definitions are loaded via require in init.rb
  # Patch application is handled by Rails.configuration.to_prepare in init.rb
  # This avoids double-loading issues with Zeitwerk (Rails 7.2)
end
