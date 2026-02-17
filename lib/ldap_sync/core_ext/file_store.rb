# encoding: utf-8
# Copyright (C) 2011-2013  The Redmine LDAP Sync Authors
#
# This file is part of Redmine LDAP Sync.
#
# Redmine LDAP Sync is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Redmine LDAP Sync is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Redmine LDAP Sync.  If not, see <http://www.gnu.org/licenses/>.
module LdapSync
  module CoreExt
    module FileStore
      module Patch
        def delete_unless
          opts = merged_options(nil)
          search_dir(cache_path) do |path|
            key = file_path_key(path)
            delete_entry(key, **opts) unless yield(key)
          end
        end
      end
    end
  end
end

# Reopen the actual Rails class and include the patch
ActiveSupport::Cache::FileStore.prepend(LdapSync::CoreExt::FileStore::Patch)
