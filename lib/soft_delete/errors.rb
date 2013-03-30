module SoftDelete
  class SoftDeleteError < StandardError
  end

  class ColumnDoesNotExist < SoftDeleteError
    def initialize(table, column)
      super("#{column} column does not exist for #{table} table")
    end
  end
end
