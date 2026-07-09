# Demo data for local review. Idempotent and development-only.
if Rails.env.development?
  demo = User.find_or_create_by!(email_address: "user@example.com") do |u|
    u.name = "Demo"
    u.password = "password"
  end

  demo.add_default_categories! if demo.categories.none?

  if demo.expenses.none?
    by_name = demo.categories.index_by(&:name)
    [
      [ "Groceries",     64, 0, "Trader Joe's" ],
      [ "Groceries",     38, 2, nil ],
      [ "Eating out",    22, 1, "Tacos" ],
      [ "Eating out",    47, 3, "Date night" ],
      [ "Transport",     18, 1, "Gas" ],
      [ "Fun",           30, 4, "Mini golf" ],
      [ "Bills",        120, 6, "Electric" ],
      [ "Subscriptions", 15, 9, "Streaming" ],
      [ "Shopping",      56, 5, "Shoes" ]
    ].each do |name, amount, days_ago, note|
      category = by_name[name] or next
      demo.expenses.create!(category: category, amount: amount,
                            note: note, spent_on: Date.current - days_ago)
    end
  end

  puts "Seeded. Sign in as user@example.com / password."
end
