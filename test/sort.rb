list = [1,2,4,5,3,6]
def s_find list, dest
    list.each_index { |index| p index if list[index] == b }
end

#list为递增
def b_find list, dest
    start = 0; last = list.length; index = 0
    while(true)
        index = start + (last - start ) / 2
        start = index if list[index] < dest
        last = index if list[index] > dest
        return p index if list[index] == dest
    end
end


#排序方法一律为从小到大

#冒泡排序: 比较相邻的两个数,a1,a2;
#if a1 < a2; next
#if a1 > a2; a1, a2 = a2, a1
def bubble_sort list
    ( list.size - 2 ).downto(0) do |i|
        (0..i).each do |j| 
            if list[j] > list[j+1]
                list[j], list[j+1] = list[j+1], list[j] 
            end
        end
    end
    return list
end

#选择排序:每次选择出最小的一个,顺序插入到目标数组
def select_sort list
    dest = []
    until list.empty?
        dest << list.min
        list.delete_at(list.index(list.min))
    end
    dest
end

#插入排序

#快速排序
def quick_sort list
    (x = list.pop) ? quick_sort(list.select {|i| i <= x}) + [x] + quick_sort(list.select {|i| i > x}) : []
end

p quick_sort list
