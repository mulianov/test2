set nfacs [ gtkwave::getNumFacs ]
set all_facs [list]
set index -1
set filterKeyword "top_instance"
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
    set index [ string first $filterKeyword $facname  ]
    if {$index != -1} {
        lappend all_facs "$facname"
    }
}
set num_added [ gtkwave::addSignalsFromList $all_facs ]
puts "num signals added: $num_added"

# zoom full
gtkwave::/Time/Zoom/Zoom_Full
