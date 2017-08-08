namespace :setup do

  desc "Run some mysql commands if needed."
  task create_and_populate_tables: :environment do
    `mysqladmin --host=db --user=foodmart --password=foodmart create foodmart`
    `echo "grant all on foodmart.* to 'foodmart'@'%' identified by 'foodmart';" | mysql --host=db --user=root --password=foodmart`
    `mysql --host=db --user=root --password=foodmart -D foodmart < db/foodmart.sql`
  end

end
