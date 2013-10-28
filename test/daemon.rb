# encoding: UTF-8

require "./models/hi_movie"

# "orders_list": 所有的订单列表
# "cache_list": 处理订单的列表
# "#{order_no}_firstQuery" 订单第一次查询的时间
# "#{order_no}_lastQuery" 订单上一次查询的时间
module Constant
  ORDERS = "orders_list" #订单列表
  CACHE = "cache_list"   #正在处理的订单列表
  FPER = "firstQuery_"   #起始时间的前缀
  LPER = "lastQuery_"    #上一次访问时间的前缀
  CACHE_MAX_COUNT = 5    #正在处理的订单列表的总数限制
end

class Daemon
  include Constant

  def initialize
    #测试,构建初始数据
    #虚拟数据 order = 619,620
    #redis_conn.rpush(ORDERS, [619,620])
    #get_orders_into_cache_list
    #query_cache
    init
  end

  def debug msg, e
    puts "-----#{msg}"
    puts e
  end

  def init
    EM.run {
      EM.add_periodic_timer(1) {
        count = get_orders_into_cache_list
        p "#{Time.now.strftime("%T")}:em run, the count is:#{count}"

        #如果大于0开始查询
        query_cache if count > 0
      }
    }
  end

  def redis_conn
    @redis ||= Redis.new
  end

  #从orders_list队列中取出数据到cache_list中,取CACHE_COUNT个数据
  def get_orders_into_cache_list
    l = redis_conn.llen(ORDERS)
    count = (l < CACHE_MAX_COUNT) ? l : CACHE_MAX_COUNT
    count.times do
      r = redis_conn.lpop(ORDERS)
      redis_conn.rpush(CACHE,r) if r
    end
    count
  end

  #从cache_list中取出数据查询
  def query_cache
    redis_conn.lrange(CACHE, 0, -1).each do |order|
      begin
        f = "#{FPER}#{order}"
        l = "#{LPER}#{order}"

        #取出provider_seat_order
        pso = SeatOrder.where(:pay_order_id => order).first.provider_seat_orders.first
        debug "pso", pso
        next remove_order(CACHE,order) unless pso #订单不存在,删除订单,执行下一个操作

        #如果是第一次访问,初始化第一次访问时间
        redis_conn.set(f, Time.now.to_i) unless redis_conn.get(f)
        #设置最后一次访问时间
        redis_conn.set(l, Time.now.to_i)

        ftime = redis_conn.get(f).to_i
        ltime = redis_conn.get(l).to_i

        debug "ftime", Time.at(ftime)
        debug "ltime", Time.at(ltime)

        query_res = query_order(pso.provider_seat_order_no)
        debug "query_res", query_res
        logger.info ("#{Time.now} query order:#{order} result:#{query_res}")

        #status_ind状态码 -1:错误, 0:等待支付确认, 1:交易成功, 2:交易超时,座位已释放
        handle_res order,query_res if query_res[:status_ind].in?(["-1","1","2"])

        debug 'redis keys', redis_conn.keys
        if check(ftime,ltime,query_res[:status_ind])
          debug 'check true', nil
          #如果是等待确认,删除cache中的订单,加入到orders_list的队尾
          redis_conn.lrem(CACHE,0,order)
          redis_conn.rpush(ORDERS, order)
          next
        end

        #处理完毕,删除订单和相关的keys
        remove_order(CACHE, order)
        debug 'redis keys', redis_conn.keys
      #rescue
      #  remove_order(CACHE, order)
      #  redis_conn.rpush(ORDERS, order)
      end
    end
  end

  #检查此订单时候能否再加入到队列
  def check ftime, ltime, status
    return false unless status == "0"

    now = Time.now.to_i
    return false unless ftime.between?(now - 5.minutes, now) #每个订单最多存在五分钟
    true
  end

  #根据返回结果,处理订单
  def handle_res id, res
    debug "init do_sth id", id
    debug "init do_sth res", res
    #修改pay_order的状态
    #发送短信
    if res[:status_ind] == "1"
      pay_order = PayOrder.find(id)
      pay_order.update_attributes({status: 1, get_ticket_no: res[:valid_code]})
      pay_order.activity_record.update_attribute(:status, 1) if pay_order.activity_record
      pay_order.platform_pay_order.update_attribute(:status,1) if pay_order.platform_pay_order
      #出票成功后下发短信
      SendSms.new.send_sms_create_success_order(pay_order)
    else
      #支付成功，出票失败
      pay_order.update_attribute(:status, 11)
      pay_order.activity_record.update_attribute(:status, 2) unless pay_order.activity_record.blank?
    end
  end

  #开始查询
  def query_order id
    debug 'init query_order', nil
    himovie = Adapter::HiMovie.new
    res = himovie.request_api(:query_order,{:createOrderID => id})
  end

  def remove_order src, order
    redis_conn.multi do
      redis_conn.lrem(src,0,order)
      redis_conn.del(
        FPER + order,
        LPER + order
      )
    end
  end

end


times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.008  000.008: --- VIM STARTING ---
000.114  000.106: Allocated generic buffers
000.212  000.098: locale set
000.231  000.019: GUI prepared
000.234  000.003: clipboard setup
000.242  000.008: window checked
002.813  002.571: inits 1
002.823  000.010: parsing arguments
002.825  000.002: expanding arguments
002.844  000.019: shell init
005.169  002.325: xsmp init
005.986  000.817: Termcap init
006.070  000.084: inits 2
006.242  000.172: init highlight
006.589  000.164  000.164: sourcing /usr/share/vim/vimfiles/archlinux.vim
006.642  000.312  000.148: sourcing /etc/vimrc
007.276  000.320  000.320: sourcing /usr/share/vim/vim74/syntax/syncolor.vim
007.429  000.564  000.244: sourcing /usr/share/vim/vim74/syntax/synload.vim
027.627  000.810  000.810: sourcing /home/zhou/.vim/ftdetect/ruby.vim
027.791  020.309  019.499: sourcing /usr/share/vim/vim74/filetype.vim
027.836  021.056  000.183: sourcing /usr/share/vim/vim74/syntax/syntax.vim
027.940  000.011  000.011: sourcing /usr/share/vim/vim74/filetype.vim
027.993  000.009  000.009: sourcing /usr/share/vim/vim74/filetype.vim
028.075  000.043  000.043: sourcing /usr/share/vim/vim74/ftplugin.vim
028.126  000.010  000.010: sourcing /usr/share/vim/vim74/filetype.vim
028.200  000.036  000.036: sourcing /usr/share/vim/vim74/indent.vim
031.608  000.211  000.211: sourcing /usr/share/vim/vim74/syntax/syncolor.vim
031.920  025.220  003.844: sourcing $HOME/.vimrc
031.929  000.155: sourcing vimrc file(s)
037.327  005.258  005.258: sourcing /home/zhou/.vim/plugin/NERD_commenter.vim
042.316  004.828  004.828: sourcing /home/zhou/.vim/plugin/NERD_tree.vim
042.835  000.450  000.450: sourcing /home/zhou/.vim/plugin/neocomplcache.vim
043.618  000.754  000.754: sourcing /home/zhou/.vim/plugin/rails.vim
044.008  000.352  000.352: sourcing /home/zhou/.vim/plugin/snipMate.vim
045.092  001.053  001.053: sourcing /home/zhou/.vim/plugin/supertab.vim
045.409  000.097  000.097: sourcing /usr/share/vim/vim74/plugin/getscriptPlugin.vim
045.728  000.292  000.292: sourcing /usr/share/vim/vim74/plugin/gzip.vim
045.972  000.208  000.208: sourcing /usr/share/vim/vim74/plugin/matchparen.vim
046.594  000.599  000.599: sourcing /usr/share/vim/vim74/plugin/netrwPlugin.vim
046.694  000.051  000.051: sourcing /usr/share/vim/vim74/plugin/rrhelper.vim
046.765  000.036  000.036: sourcing /usr/share/vim/vim74/plugin/spellfile.vim
047.026  000.233  000.233: sourcing /usr/share/vim/vim74/plugin/tarPlugin.vim
047.177  000.110  000.110: sourcing /usr/share/vim/vim74/plugin/tohtml.vim
047.382  000.176  000.176: sourcing /usr/share/vim/vim74/plugin/vimballPlugin.vim
047.674  000.251  000.251: sourcing /usr/share/vim/vim74/plugin/zipPlugin.vim
048.599  000.707  000.707: sourcing /home/zhou/.vim/after/plugin/snipMate.vim
048.607  001.223: loading plugins
048.626  000.019: inits 3
048.866  000.240: reading viminfo
051.130  002.264: setup clipboard
051.144  000.014: setting raw mode
051.166  000.022: start termcap
051.182  000.016: clearing screen
051.476  000.294: opening buffers
051.721  000.245: BufEnter autocommands
051.726  000.005: editing files in windows
052.066  000.119  000.119: sourcing /home/zhou/.vim/nerdtree_plugin/exec_menuitem.vim
052.520  000.417  000.417: sourcing /home/zhou/.vim/nerdtree_plugin/fs_menu.vim
053.318  001.056: VimEnter autocommands
053.323  000.005: before starting main loop
053.815  000.492: first screen update
053.817  000.002: --- VIM STARTED ---


times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.006  000.006: --- VIM STARTING ---
000.103  000.097: Allocated generic buffers
000.210  000.107: locale set
000.240  000.030: GUI prepared
000.243  000.003: clipboard setup
000.253  000.010: window checked
002.737  002.484: inits 1
002.746  000.009: parsing arguments
002.747  000.001: expanding arguments
002.762  000.015: shell init
004.374  001.612: xsmp init
004.705  000.331: Termcap init
004.754  000.049: inits 2
004.880  000.126: init highlight
005.112  000.116  000.116: sourcing /usr/share/vim/vimfiles/archlinux.vim
005.147  000.219  000.103: sourcing /etc/vimrc
005.621  000.230  000.230: sourcing /usr/share/vim/vim74/syntax/syncolor.vim
005.760  000.436  000.206: sourcing /usr/share/vim/vim74/syntax/synload.vim
026.403  000.812  000.812: sourcing /home/zhou/.vim/ftdetect/ruby.vim
026.558  020.748  019.936: sourcing /usr/share/vim/vim74/filetype.vim
026.602  021.341  000.157: sourcing /usr/share/vim/vim74/syntax/syntax.vim
026.704  000.011  000.011: sourcing /usr/share/vim/vim74/filetype.vim
026.754  000.009  000.009: sourcing /usr/share/vim/vim74/filetype.vim
026.834  000.042  000.042: sourcing /usr/share/vim/vim74/ftplugin.vim
026.885  000.009  000.009: sourcing /usr/share/vim/vim74/filetype.vim
026.959  000.036  000.036: sourcing /usr/share/vim/vim74/indent.vim
030.250  000.205  000.205: sourcing /usr/share/vim/vim74/syntax/syncolor.vim
030.541  025.344  003.691: sourcing $HOME/.vimrc
030.549  000.106: sourcing vimrc file(s)
038.018  007.341  007.341: sourcing /home/zhou/.vim/plugin/NERD_commenter.vim
042.337  004.201  004.201: sourcing /home/zhou/.vim/plugin/NERD_tree.vim
042.833  000.444  000.444: sourcing /home/zhou/.vim/plugin/neocomplcache.vim
043.387  000.529  000.529: sourcing /home/zhou/.vim/plugin/rails.vim
043.750  000.337  000.337: sourcing /home/zhou/.vim/plugin/snipMate.vim
045.209  001.421  001.421: sourcing /home/zhou/.vim/plugin/supertab.vim
045.504  000.081  000.081: sourcing /usr/share/vim/vim74/plugin/getscriptPlugin.vim
045.765  000.237  000.237: sourcing /usr/share/vim/vim74/plugin/gzip.vim
045.982  000.193  000.193: sourcing /usr/share/vim/vim74/plugin/matchparen.vim
046.642  000.637  000.637: sourcing /usr/share/vim/vim74/plugin/netrwPlugin.vim
046.741  000.052  000.052: sourcing /usr/share/vim/vim74/plugin/rrhelper.vim
046.809  000.034  000.034: sourcing /usr/share/vim/vim74/plugin/spellfile.vim
047.062  000.225  000.225: sourcing /usr/share/vim/vim74/plugin/tarPlugin.vim
047.208  000.106  000.106: sourcing /usr/share/vim/vim74/plugin/tohtml.vim
047.461  000.227  000.227: sourcing /usr/share/vim/vim74/plugin/vimballPlugin.vim
047.804  000.275  000.275: sourcing /usr/share/vim/vim74/plugin/zipPlugin.vim
048.492  000.568  000.568: sourcing /home/zhou/.vim/after/plugin/snipMate.vim
048.499  001.042: loading plugins
048.517  000.018: inits 3
048.758  000.241: reading viminfo
051.164  002.406: setup clipboard
051.179  000.015: setting raw mode
051.200  000.021: start termcap
051.226  000.026: clearing screen
051.529  000.303: opening buffers
051.779  000.250: BufEnter autocommands
051.784  000.005: editing files in windows
052.129  000.120  000.120: sourcing /home/zhou/.vim/nerdtree_plugin/exec_menuitem.vim
052.565  000.400  000.400: sourcing /home/zhou/.vim/nerdtree_plugin/fs_menu.vim
053.369  001.065: VimEnter autocommands
053.374  000.005: before starting main loop
053.859  000.485: first screen update
053.861  000.002: --- VIM STARTED ---
