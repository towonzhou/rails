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
