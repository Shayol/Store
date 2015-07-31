namespace :cleanup do
  desc "removes unfinished orders from the database"
  task :orders => :environment do
    stale_orders = Order.where("DATE(created_at) < DATE(?)", Date.yesterday).where(state: "in_progress")
    stale_products.map(&:destroy)
  end
end