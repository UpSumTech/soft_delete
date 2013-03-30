module SoftDelete
  module Archivable
    def self.included(klass)
      if klass.connection.table_exists?(klass.table_name) && klass.columns.find {|column| column.name.to_s == "deleted" && column.type == :boolean}
        klass.__send__(:extend, ClassMethods)
        klass.instance_eval do
          __pre_load__
        end
        klass.__send__(:include, InstanceMethods)
      else
        raise ColumnDoesNotExist.new(klass.table_name, 'deleted')
      end
    end

    module InstanceMethods
      def destroy
        if archivable?
          self.class.transaction do
            run_callbacks :destroy do
              archive
            end
          end
        else
          __destroy__
        end
      end

      def archivable?
        soft_delete_options = self.class.soft_delete_options
        (!soft_delete_options[:if] && !soft_delete_options[:unless]) ||
          (soft_delete_options[:if] && soft_delete_options[:if].call(self)) ||
          (soft_delete_options[:unless] && !soft_delete_options[:unless].call(self))
      end

      def archive
        self.deleted = true
        if self.persisted?
          pk = self.class.primary_key
          tn = self.class.quoted_table_name
          connection.execute("UPDATE #{tn} SET deleted = true " + "WHERE #{tn}.#{pk} = #{self.__send__(pk)}")
        end
        freeze
        true
      end
    end

    module ClassMethods
      private

      def __pre_load__
        __assign_default_options__
        default_scope where(:deleted => false)
        __add_callback_support_for_archive__
        alias_method :__destroy__, :destroy
      end

      def soft_delete(options)
        self.soft_delete_options = options
      end

      def __assign_default_options__
        class_attribute :soft_delete_options
        self.soft_delete_options = {}
      end

      def __add_callback_support_for_archive__
        extend ActiveModel::Callbacks
        define_model_callbacks :archive
      end
    end
  end
end
