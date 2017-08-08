# Preparation
#
# Create mysql database "foodmart" and import sample data with e.g.
#
# mysqladmin -u root -p create foodmart
# mysql -u root -p -D foodmart < db/foodmart.sql
# Create user "foodmart"
#
# mysql -u root -p
# mysql> grant all on foodmart.* to 'foodmart'@'localhost' identified by 'foodmart';
# Install JRuby (e.g. with rvm).
#
# Install all necessary gems with bundle install.
#
# Run application with
#
# jruby -S script/rails server
# or if you would like to see debugging output from Mondrian (including generated SQL statements) then start application with
#
# jruby -J-Dlog4j.configuration=config/log4j.properties -S script/rails s

FROM jruby
RUN apt-get update
RUN apt-get install -y mysql-workbench

WORKDIR /app/src

COPY Gemfile* ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD bash -c 'rake setup:create_and_populate_tables; rails s -b 0.0.0.0'
