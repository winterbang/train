# Train
rails 项目生成模板

## Why Train

  每次做项目最让我头疼和讨厌的事情就建项目然后配置项目，从已经搭好的项目中复制各种配置代码然后粘贴到新项目中，真的好烦人啊。```Train```可以帮我完成这些麻烦的配置，项目一键生成后可以马上开始写我的业务代码了。

## Requirements

  系统已经安装5.0以上的rails，并且选择mysql作为项目使用的数据库

## Usage

  rails new myproject -d mysql -m https://raw.githubusercontent.com/winterbang/train/master/template.rb

## How It Works
  就是使用ruby的```thor```库或rails为定制模板提供的方法将自己喜欢的配置参数或文件替换了rails项目默认生成的。
  具体可以参考以下文档，然后你自己也可以定制一套自己的习惯的rails模板，再也不用苦恼于新建项目了。

  - ```http://guides.rubyonrails.org/rails_application_templates.html```

  - ```https://github.com/erikhuda/thor```

## More
