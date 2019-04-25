class ChangeEncoding < ActiveRecord::Migration[5.2]
  config = Rails.configuration.database_configuration
  @db_name = config[Rails.env]['database']

  def up
    collate = 'utf8mb4_unicode_ci'
    char_set = 'utf8mb4'
    row_format = 'DYNAMIC'
 
    execute("ALTER DATABASE #{@db_name} CHARACTER SET #{char_set} COLLATE #{collate};")
 
    ActiveRecord::Base.connection.tables.each do |table|
      # The default row format for InnoDB tables in MySQL 5.6 is COMPACT
      # and in MySQL 5.7 is DYNAMIC. We're using MySQL 8.0.
      # https://tonnygaric.com/blog/difference-in-innodb-s-default-row-format-between-mysql-5-6-and-5-7
      # execute("ALTER TABLE #{table} ROW_FORMAT=#{row_format};")

      execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET #{char_set} COLLATE #{collate};")
    end
  end

  def down
    collate = 'utf8_unicode_ci'
    char_set = 'utf8'

    execute("ALTER DATABASE #{@db_name} DEFAULT CHARACTER SET #{char_set} DEFAULT COLLATE #{collate};")

    ActiveRecord::Base.connection.tables.each do |table|
      execute("ALTER TABLE #{table} CONVERT TO CHARACTER SET #{char_set} COLLATE #{collate};")
    end
  end
end
