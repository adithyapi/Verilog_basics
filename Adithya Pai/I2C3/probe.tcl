database -open waves_mastertb -default
probe -create -all -depth all
##probe -create -database waves_muxtb -all -depth {muxtb.UUT}
run 100000 ms
exit
