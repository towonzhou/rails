# -*- encoding: UTF-8 -*-
##############################################################
# File Name: sort_by.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 2013年09月26日 星期四 09时16分44秒
##############################################################

#a = %w{ C2 C3 C1 1F B2 B1 B4 B3 2F 10F 11F 3F }
a = %w{ C3 1F B2 B1 B4 B3 2F 10F 11F 3F }

p a.sort_by {|f| f =~ /^\d/ ? f.to_i : -f[1..-1].to_i}

b = %w{ C1 1B }
p b.sort_by {|f| f[0].to_i}
