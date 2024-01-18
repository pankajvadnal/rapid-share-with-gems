namespace :db do
  desc 'Truncate all tables in the database'
  task truncate_all_tables: :environment do
    tables = ActiveRecord::Base.connection.tables

    tables.each do |table_name|
      next if table_name == 'schema_migrations' || table_name == 'ar_internal_metadata'
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name} RESTART IDENTITY CASCADE;")
    end

    puts 'All tables truncated.'
  end
end
