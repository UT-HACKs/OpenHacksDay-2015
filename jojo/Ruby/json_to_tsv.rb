#!/usr/bin/env ruby
require 'json'
require 'open-uri'



def json_to_tsv(json_obj,path)
    max_ncol = 4
    max_nrow = 10
    file_name = path + json_obj["created_at"] + ".tsv"
    puts path
    io = File.open(file_name,"w")
    col_id = []
    for i in 0..(max_ncol-1) do
        key = "title"+i.to_s
        if json_obj.key?(key) then
            io.print(json_obj[key])
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
            if json_obj.key?(key) then
                one_row.push(json_obj[key])
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
end

path = "/data/"
file_name_io = open(path + "file_name.txt","w")
i = 1
while 1==1 do
    begin
        io = open("https://camiapp.herokuapp.com/json_files/json/" + i.to_s)
        puts "https://camiapp.herokuapp.com/json_files/json/" + i.to_s
        json_obj = JSON.load(io)
        io.close()
        file_name_file = json_obj["created_at"] + ".tsv"
        file_name_io.puts(file_name_file)
    rescue
        print("ended!")
        break
    end
        json_to_tsv(json_obj,path)
        i=i+1
        if i>100 then
            break
        end
    
end
