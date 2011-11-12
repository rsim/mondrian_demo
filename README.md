Overview
========

This is sample Rails application that demonstrates usage of [mondrian-olap](https://github.com/rsim/mondrian-olap) gem.
It was used during [RailsWayCon 2011](http://railswaycon.com/2011/sessions#session-17837) conference presentation [Multidimensional Data Analysis with JRuby](http://www.slideshare.net/rsim/railswaycon-multidimensional-data-analysis-with-jruby).

Preparation
===========

Create mysql database "foodmart" and import sample data with e.g.

    mysqladmin -u root -p create foodmart
    mysql -u root -p -D foodmart < db/foodmart.sql

Create user "foodmart"

    mysql -u root -p
    mysql> grant all on foodmart.* to 'foodmart'@'localhost' identified by 'foodmart';

Install JRuby (e.g. with rvm).

Install all necessary gems with `bundle install`.

Run application with

    jruby -S rails server

or if you would like to see debugging output from Mondrian (including generated SQL statements) then start application with

    jruby -J-Dlog4j.configuration=config/log4j.properties -S rails s

MDX demo
========

Go to `http://localhost:3000/mdx` and input

    SELECT  {[Measures].[Unit Sales], [Measures].[Store Sales]} ON COLUMNS,
            {[Products].children} ON ROWS
      FROM  [Sales]
      WHERE ([Time].[1997].[Q1], [Customers].[USA].[CA])

It generates SQL similar to this:

    select "CUSTOMER"."STATE_PROVINCE" as "c0", "PRODUCT_CLASS"."PRODUCT_FAMILY" as "c1", "TIME_BY_DAY"."THE_YEAR" as "c2", "TIME_BY_DAY"."QUARTER" as "c3", sum("SALES_FACT_1997"."UNIT_SALES") as "m0", sum("SALES_FACT_1997"."STORE_SALES") as "m1"
    from "CUSTOMER" "CUSTOMER", "SALES_FACT_1997" "SALES_FACT_1997", "PRODUCT_CLASS" "PRODUCT_CLASS", "PRODUCT" "PRODUCT", "TIME_BY_DAY" "TIME_BY_DAY"
    where "SALES_FACT_1997"."CUSTOMER_ID" = "CUSTOMER"."CUSTOMER_ID" and "CUSTOMER"."STATE_PROVINCE" = 'CA' and "SALES_FACT_1997"."PRODUCT_ID" = "PRODUCT"."PRODUCT_ID" and "PRODUCT"."PRODUCT_CLASS_ID" = "PRODUCT_CLASS"."PRODUCT_CLASS_ID" and "SALES_FACT_1997"."TIME_ID" = "TIME_BY_DAY"."TIME_ID" and "TIME_BY_DAY"."THE_YEAR" = 1997 and "TIME_BY_DAY"."QUARTER" = 'Q1' group by "CUSTOMER"."STATE_PROVINCE", "PRODUCT_CLASS"."PRODUCT_FAMILY", "TIME_BY_DAY"."THE_YEAR", "TIME_BY_DAY"."QUARTER"


Query builder in Ruby
=====================


Go to `http://localhost:3000/mdx/builder` and try following queries

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].children').
    where('[Time].[1997].[Q1]', '[Customers].[USA].[CA]')

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].children').crossjoin('[Customers].[Canada]', '[Customers].[USA]').
    where('[Time].[1997].[Q1]')

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].children').
    where('[Time].[1997].[Q1].[1]', '[Time].[1997].[Q1].[2]').crossjoin('[Customers].[USA].[CA]', '[Customers].[USA].[OR]')

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].children').crossjoin('[Customers].[Canada]', '[Customers].[USA]').nonempty.
    where('[Time].[1997].[Q1]')

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].children').order('[Measures].[Unit Sales]', :bdesc)

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].[Product Family].members', '[Products].[Brand Name].members').
      order('[Measures].[Unit Sales]', :bdesc)

    olap.from('Sales').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('[Products].[Brand Name].members').top_count(5, '[Measures].[Store Sales]')

    olap.from('Sales').
    with_set('TopProducts').as('[Products].[Brand Name].members').
      top_percent(50, '[Measures].[Store Sales]').
    with_set('AllOtherProducts').as('[Products].[Brand Name].members').except('TopProducts').
    with_member('[Products].[All others]').as('AGGREGATE(AllOtherProducts)').
    columns('[Measures].[Unit Sales]', '[Measures].[Store Sales]').
    rows('TopProducts', '[Products].[All others]')

    olap.from('Sales').
    with_member('[Measures].[ProfitPct]').
      as('([Measures].[Store Sales] - [Measures].[Store Cost]) / [Measures].[Store Sales]',
      :format_string => 'Percent').
    columns('[Measures].[Store Sales]', '[Measures].[ProfitPct]').
    rows('[Products].children').crossjoin('[Customers].[USA].children').
      top_count(50, '[Measures].[Store Sales]').
    where('[Time].[1997].[Q1]')

    olap.from('Sales').
    with_set('SelectedRows').
      as('[Products].children').crossjoin('[Customers].[USA].children').
    with_member('[Measures].[Profit]').
      as('[Measures].[Store Sales] - [Measures].[Store Cost]').
    columns('[Measures].[Profit]').
    rows('SelectedRows')

Cube queries
============

You can try following cube queries in `rails console`

    cube = Dwh.olap.cube('Sales')
    cube.dimension_names                    # => ['Measures', 'Customers', 'Products', 'Time']
    cube.dimensions                         # => array of dimension objects
    cube.dimension('Customers')             # => customers dimension object
    cube.dimension('Time').hierarchy_names  # => ['Time', 'Time.Weekly']
    cube.dimension('Time').hierarchies      # => array of hierarchy objects
    cube.dimension('Customers').hierarchy   # => default customers dimension hierarchy
    cube.dimension('Customers').hierarchy.level_names
                                            # => ['(All)', 'Country', 'State Province', 'City', 'Name']
    cube.dimension('Customers').hierarchy.levels
                                            # => array of hierarchy level objects
    cube.dimension('Customers').hierarchy.level('Country').members
                                            # => array of all level members
    cube.member('[Customers].[USA].[CA]')   # => lookup member by full name
    cube.member('[Customers].[USA].[CA]').children
                                            # => get all children of member in deeper hierarchy level
    cube.member('[Customers].[USA]').descendants_at_level('City')
                                            # => get all descendants of member in specified hierarchy level

