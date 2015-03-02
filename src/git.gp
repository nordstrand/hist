set terminal png
set output "graph.png"


binwidth=5
set boxwidth binwidth

bin(x,width)=width*floor(x/width) + width/2.0

set xlabel "Age in days"
set ylabel "Number of commits"

set style line 1 lt 2 lw 2 pt 3 ps 0.5


set border 3


plot '<cat' using (bin($1,binwidth)):(1.0) ls 1 smooth freq with boxes notitle