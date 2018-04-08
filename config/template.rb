# 配置mina自动化部署工具
if apply_mina?
  template "config/deploy.rb.tt"
  template "config/deploy/staging.rb.tt"
  template "config/deploy/production.rb.tt"
end

# 服务器nginx相关配置
template "config/deploy/config/puma.rb.tt"
template "config/deploy/config/nginx.conf.tt"
template "config/deploy/config/nginx.https.conf.tt"

copy_file "config/initializers/devise.rb"
copy_file "config/initializers/devise_token_auth.rb"

# 配置路由相关
run 'mkdir config/routes'
remove_file "config/routes.rb"
copy_file "config/routes.rb"

# 不同业务路由通过文件分离开，开发环境路由文件自动加载
prepend_to_file "config/environments/development.rb", "require Rails.root.join('lib/routes_reloader').to_s\n"
environment 'config.middleware.use RoutesReloader', env: 'development'
# insert_into_file "config/environments/development.rb", before: /^end/ do
#   <<-'RUBY'
#     config.middleware.use RoutesReloader
#   RUBY
# end

# 添加常用配置
environment 'config.autoload_paths << Rails.root.join("app/forms")'
environment 'config.time_zone = "Beijing"'
environment 'config.active_record.default_timezone = :local'
