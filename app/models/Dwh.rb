require 'mondrian-olap'

class Dwh
  @schema = Mondrian::OLAP::Schema.define do
    cube 'Sales' do
      table 'sales_fact_1997'
      dimension 'Customers', :foreign_key => 'customer_id' do
        hierarchy :has_all => true, :all_member_name => 'All Customers', :primary_key => 'customer_id' do
          table 'customer'
          level 'Country', :column => 'country', :unique_members => true
          level 'State Province', :column => 'state_province', :unique_members => true
          level 'City', :column => 'city', :unique_members => false
          level 'Name', :column => 'fullname', :unique_members => true
        end
      end
      dimension 'Products', :foreign_key => 'product_id' do
        hierarchy :has_all => true, :all_member_name => 'All Products',
                  :primary_key => 'product_id', :primary_key_table => 'product' do
          join :left_key => 'product_class_id', :right_key => 'product_class_id' do
            table 'product'
            table 'product_class'
          end
          level 'Product Family', :table => 'product_class', :column => 'product_family', :unique_members => true
          level 'Brand Name', :table => 'product', :column => 'brand_name', :unique_members => false
          level 'Product Name', :table => 'product', :column => 'product_name', :unique_members => true
        end
      end
      dimension 'Time', :foreign_key => 'time_id', :type => 'TimeDimension' do
        hierarchy :has_all => false, :primary_key => 'time_id' do
          table 'time_by_day'
          level 'Year', :column => 'the_year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Quarter', :column => 'quarter', :unique_members => false, :level_type => 'TimeQuarters'
          level 'Month', :column => 'month_of_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
        end
        hierarchy 'Weekly', :has_all => false, :primary_key => 'time_id' do
          table 'time_by_day'
          level 'Year', :column => 'the_year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
          level 'Week', :column => 'weak_of_year', :type => 'Numeric', :unique_members => false, :level_type => 'TimeWeeks'
        end
      end
      measure 'Unit Sales', :column => 'unit_sales', :aggregator => 'sum'
      measure 'Store Sales', :column => 'store_sales', :aggregator => 'sum'
      measure 'Store Cost', :column => 'store_cost', :aggregator => 'sum'
    end
  end
  
  def self.schema; @schema; end

  params = ActiveRecord::Base.configurations[Rails.env].symbolize_keys
  @olap = Mondrian::OLAP::Connection.create(
    :driver => params[:adapter] == 'oracle_enhanced' ? 'oracle' : params[:adapter],
    :host => params[:host],
    :database => params[:database],
    :username => params[:username],
    :password => params[:password],
    :schema => @schema
  )

  def self.olap; @olap; end

end
