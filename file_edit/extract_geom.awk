FNR == 1 {
    file_count++
    filenames[file_count]=FILENAME
}

/Standard orientation/,/Rotational constants/ {
    if ( NF == 6 && match($0,"[a-zA-Z]") == 0 )
        {
            symbol[file_count,$1]=$2
            x[file_count,$1]=$4
            y[file_count,$1]=$5
            z[file_count,$1]=$6
            atoms[file_count]=$1
        }
}

END {
    for (i=1; i <= file_count; i++)
        {
            filename = filenames[i]
            gsub("pddg","b3lyp_d3bj-midix",filename)
            gsub(".out",".gjf",filename)
            print filename
            print "%nprocshared=4\n%mem=3GB\n#p b3lyp midix empiricaldispersion=gd3bj opt freq=noraman scrf=(pcm,solvent=diethylether)\n\ntitle\n\n0 1" > filename
            for (j=1; j <= atoms[i]; j++)
                printf "%2d %15.8f %15.8f %15.8f\n", symbol[i,j], x[i,j], y[i,j], z[i,j]  >> filename
            printf "\n\n" >> filename
        }
}
