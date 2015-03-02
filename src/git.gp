set terminal png
set output "graph.png"

binwidth=5
set boxwidth binwidth

bin(x,width)=width*floor(x/width) + width/2.0


plot '<cat' using (bin($1,binwidth)):(1.0) smooth freq with boxes