
set inputs [find nets -in /${DESIGN_NAME}_tb/DUT_INSTANCE/*]
set outputs [find nets -out /${DESIGN_NAME}_tb/DUT_INSTANCE/*]
set inouts [find nets -inout /${DESIGN_NAME}_tb/DUT_INSTANCE/*]
set ports [concat $inputs $inouts $outputs]

add wave -noupdate -divider {Gate-Level Model:}
foreach p $ports {
    add wave $p
}
add wave -noupdate -divider {RTL Model:}
foreach p $ports {
    set rp [string map [list "DUT_INSTANCE" "REF_MODEL/REF_INSTANCE" ] $p]
    add wave $rp
}

configure wave -signalnamewidth 1
configure wave -datasetprefix 0
