=begin rdoc

= SixArm Ruby Gem: MySQL Adapter extensions

Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
Copyright:: Copyright (c) 2006-2010 Joel Parker Henderson
License:: CreativeCommons License, Non-commercial Share Alike
License:: LGPL, GNU Lesser General Public License

See http://www.dweebd.com/page/2/

=end

# Allows you to specify indices to add in a migration that will only be created if they do not
# already exist, or to remove indices only if they already exist
module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter
 
      def add_index_with_unless_exists table_name, column_name, options = {}
        if options.kind_of?(Hash) && options.delete(:force)
          begin
            add_index_without_unless_exists table_name, column_name, options
          rescue
            if /^Mysql::Error: Duplicate key name /.match($!.message)
              puts "Failed to create index #{table_name} #{column_name} #{options.inspect}"
            else
              raise $!
            end
          end
        else
          add_index_without_unless_exists table_name, column_name, options
        end
      end
      alias_method_chain :add_index, :unless_exists
 
      def remove_index_with_unless_doesnt_exist table_name, options = {}
        if options.kind_of?(Hash) && options.delete(:force)
          begin
            remove_index_without_unless_doesnt_exist table_name, options
          rescue
            if /^Mysql::Error: Can't DROP/.match($!.message)
              puts "Failed to drop index #{table_name} #{options.inspect}"
            else
              raise $!
            end
          end
        else
          remove_index_without_unless_doesnt_exist table_name, options
        end
      end
      alias_method_chain :remove_index, :unless_doesnt_exist
 
    end
  end
end
