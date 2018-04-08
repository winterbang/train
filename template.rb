def apply_template!
  assert_valid_options
  add_template_repository_to_source_path
  assert_mysql
  copy_file 'lib/routes_reloader.rb'
  
  template "Gemfile.tt", force: true

  # if apply_mina?
  #   template "DEPLOYMENT.md.tt"
  #   template "PROVISIONING.md.tt"
  # end

  template "README.md.tt", force: true
  remove_file "README.rdoc"

  copy_file "gitignore", ".gitignore", force: true
  apply "config/template.rb"

  unless any_local_git_commits?
    git add: "-A ."
    git commit: "-n -m 'Set up project'"
    git checkout: "-b development" if apply_mina?
    if git_repo_specified?
      git remote: "add origin #{git_repo_url.shellescape}"
      git push: "-u origin --all"
    end
  end
end

require "fileutils"
require "shellwords"

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/winterbang/rails_template.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def mina_app_name
  app_name.gsub(/[^a-zA-Z0-9_]/, "_")
end

# Bail out if user has passed in contradictory generator options.
# 如果用户传递了项目的生成参数则跳出
def assert_valid_options
  valid_options = {
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    skip_test_unit: false,
    edge: false
  }

  valid_options.each do |key, expected|
    next unless options.key?(key)
    actual = options[key]
    unless actual == expected
      fail Rails::Generators::Error, "Unsupported option: #{key}=#{actual}"
    end
  end
end

# 设置数据库mysql
def assert_mysql
  return if IO.read("Gemfile") =~ /^\s*gem ['"]mysql2['"]/
  run "rm -rf ../#{app_name}"
  fail Rails::Generators::Error,
       "This template requires mysql, "\
       "but the mysql gem isn’t present in your Gemfile."
end

# 仓库地址
def git_repo_url
  @git_repo_url ||=
    ask_with_default("What is the git remote URL for this project?", :blue, "skip")
end

# 生产环境地址
def production_hostname
  @production_hostname ||=
    ask_with_default("Production hostname?(Example: deploy@www.example.com)", :blue, "deploy@www.example.com")
end

# 测试环境地址
def staging_hostname
  @staging_hostname ||=
    ask_with_default("Staging hostname?(Example: deploy@staging.example.com)", :blue, "deploy@staging.example.com")
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def git_repo_specified?
  git_repo_url != "skip" && !git_repo_url.strip.empty?
end

def apply_mina?
  return @mina if defined?(@mina)
  @mina = \
    ask_with_default("Use Mina for deployment?", :blue, "no") \
    =~ /^y(es)?/i
end

def server_name
  # return @server_name if defined?(@server_name)
  @server_name ||=
    ask_with_default("What is the server_name?", :blue, "www.example.com")
end

# 判断是否有git的提交
def any_local_git_commits?
  system("git log &> /dev/null")
end

apply_template!
