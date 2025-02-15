var items={1,3,55,1024,33,45,65,405,325}
Items=some_secret_procedure(items)
print (items)
 
 
procedure some_secret_procedure ( list : array of items )
 
  loop = list.count;
  for i = 0 to loop do:
     swapped = false
     for j = 0 to loop do:
        if list[j] > list[j+1] then
           swap( list[j], list[j+1] )                       
           swapped = true
        end if
     end for
     if(not swapped) then
        break
     end if
  end for