#!/usr/bin/env ruby
require 'json'

io = File.open("/Users/liyuanxu/Documents/Ruby/file.json")
JSON_obj = JSON.load(io)
io.close()
io = File.open("/Users/liyuanxu/Documents/Ruby/result.tsv","w")
max_ncol = 4
max_nrow = 10

io = File.open("/Users/liyuanxu/Documents/Ruby/result.tsv","w")
col_id = []
io.print("# ")
for i in 0..(max_ncol-1) do
    key = "title"+i.to_s
    if JSON_obj.key?(key) then
        io.print(JSON_obj[key])
        col_id.push(i)
        if i != max_ncol-1 then
            io.print "\t"
        end
    end
end
io.print "\n"
first_flag = 0
for j in 0..(max_nrow-1) do
    one_row = []
    flag = 0
    for i in col_id do
        key = "d"+j.to_s+i.to_s
        if JSON_obj.key?(key) then
            one_row.push(JSON_obj[key])
            flag = 1
        else
            one_row.push("NA")
        end
    end
    if flag == 0 then
        next
    end
    if first_flag==0 then
        first_flag = 1
    else
        io.print "\n"
    end
    for i in 0..(one_row.length-1) do
        io.print(one_row[i])
        if i != one_row.length-1 then
            io.print "\t"
        end
    end
end
io.close()
