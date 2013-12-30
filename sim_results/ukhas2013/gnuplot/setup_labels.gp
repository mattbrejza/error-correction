#line for uncoded
set style line 1 lc rgb 'black' pt 1 pi 10 lt 1 lw 1.2 ps 1 

#lines for rs
set style line 2 lc rgb 'blue' pt 2 pi 5 lt 1 lw 1.2 ps 1  #(7,5)
set style line 3 lc rgb 'blue' pt 3 pi 5 lt 1 lw 1.2 ps 1   #(255,223)

#line for rep
set style line 4 lc rgb 'red' pt 4 pi 10 lt 1 lw 1.2 ps 1   #soft
set style line 5 lc rgb 'red' pt 5 pi 10 lt 1 lw 1.2 ps 1   #hard
set style line 14 lc rgb 'red' pt 4 pi 10 lt 1 lw 1.2 ps 1   #soft
set style line 15 lc rgb 'red' pt 5 pi 10 lt 1 lw 1.2 ps 1   #hard

#lines for turbo
set style line 6  lc rgb '#006400' pt 6 pi 3 lt 1  lw 1.2 ps 1  #.333
set style line 7  lc rgb '#006400' pt 7 pi 3 lt 1  lw 1.2 ps 1  #.5
set style line 8  lc rgb '#006400' pt 8 pi 3 lt 1  lw 1.2 ps 1  #.6
set style line 9  lc rgb '#006400' pt 9 pi 3 lt 1  lw 1.2 ps 1  #.7
set style line 10 lc rgb '#006400' pt 10 pi 3  lt 1 lw 1.2 ps 1  #.8
set style line 11 lc rgb '#006400' pt 11 pi 3  lt 1 lw 1.2 ps 1  #.9

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

##labels for turbo
#set label 1 "R=1/3" at -4.5  , 0.00015 center
#set label 2 "R=0.5" at -2    , 0.00015 center
#set label 3 "R=0.6" at -.5   , 2.5e-5 center
#set label 4 "R=0.7" at 1     , 7e-6 center
#set label 5 "R=0.8" at 2.5   , 7e-6 center
#set label 6 "R=0.9" at 4.4   , 7e-6 center
#
##labels for turbo (eb/n0)
#set label 11 "1/3" at -4.5-10*log10(0.33)  , 0.00015 center
#set label 12 "0.5" at -2-10*log10(0.5)    , 0.00015 center
#set label 13 "0.6" at -.5-10*log10(0.6)   , 2.5e-5 center
#set label 14 "0.7" at 1-10*log10(0.7)     , 1e-5 center
#set label 15 "0.8" at 2.5-10*log10(0.8)   , 1e-5 center
#set label 16 "0.9" at 4.4-10*log10(0.9)   , 1e-5 center
#
#set label 60 "Shannon Limit" at -1.4   , 1.2e-5 center rotate by 270
###set label 61 "Shannon Limit" at -1.4+10*log10(.333)   , 1.2e-5 center rotate by 270