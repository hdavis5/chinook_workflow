## change first column name using chr_map.txt so that chr names are shown
awk 'NR==FNR {a[$1]=$2; next} {if($1 in a) $1=a[$1]; print}' chr_map.txt CC_filtered_final.bim > CC_filtered_final_renamed.bim

## rather than having a '.' in the position for the snp name, change it to CHR:BP
awk '{if($2 == ".") $2 = $1":"$4; print}' CC_filtered_final.bim > CC_filtered_final_with_ids.bim

## for sequences that aligned outside the genome, remove lettering which can cause downstream issues
sed -i 's/^NW_/ /; s/ NW_/ /g' CC_filtered_final.bim
