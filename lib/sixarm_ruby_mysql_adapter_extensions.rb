# -*- coding: utf-8 -*-
=begin rdoc
Please see README
=end


module ActiveRecord
  module ConnectionAdapters

    # Specify indices to add in a migration that are added if they are missing, otherwise ignored

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

      # Specify indices to remove in a migration that are dropped if they exist, otherwise ignored

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
