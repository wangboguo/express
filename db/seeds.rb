I18n.locale = :"zh-TW"

# [Post, Screencast, Training].each do |model|
[Post].each do |m|
  m.all.each do |p|
    puts "Translating: #{p.title}"
    p.save
  end
end
