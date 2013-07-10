rails-testf
===========

for rails test
面试官说会做一个上传的功能是从新手到初级的必然经历阶段,所以试试  
步骤和问题  
1. rails new upload (bundle install很慢,gem列表已经在本机存在,应该有一个直接用的方法,有待研究) 
   (解决方法,因为本机已经全部安装好了基本的Gem,所以运行gem server,然后把Gemfile的source指向"http://127.0.0.1"这样很快)  
   (据说http://ruby.taobao.org很快,没试过)  
2. rails g scaffold User name:string avatar:string  
   (加入root路径,删除public/index.html后依然无法启动,看log发现是没有执行rake db:create; rake db:migrate. ok 一切正常)  
3. 在Gemfile中加入gem "paperclip", "~> 3.0", sources改成taobao的果然很快.  
4. rails g paperclip user avatar,按照github上的提示走.   
