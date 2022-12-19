#! /usr/bin/awk -f
#
#--- Part Two ---
#Your handheld device indicates that the distress signal is coming from a beacon nearby. The distress beacon is not detected by any sensor, but the distress beacon must have x and y coordinates each no lower than 0 and no larger than 4000000.
#
#To isolate the distress beacon's signal, you need to determine its tuning frequency, which can be found by multiplying its x coordinate by 4000000 and then adding its y coordinate.
#
#In the example above, the search space is smaller: instead, the x and y coordinates can each be at most 20. With this reduced search area, there is only a single position that could have a beacon: x=14, y=11. The tuning frequency for this distress beacon is 56000011.
#
#Find the only possible position for the distress beacon. What is its tuning frequency?

function abs(n) {
	if (n<0) {
		return -n
	}
	return n
}

function manhattanDist(aX, aY, bX, bY) {
	return abs(aX-bX)+abs(aY-bY)
}

function max(a,b) {
	if (a>b) {
		return a
	}
	return b
}

function min(a,b) {
	if (a<b) {
		return a
	}
	return b
}

function left(s,row) {
	return x[s]-d[s]+abs(y[s]-row)
}

function right(s,row) {
	return x[s]+d[s]-abs(y[s]-row)
}

{
	sensors++
	x[sensors]=substr($3,3,length($3)-3)
	y[sensors]=substr($4,3,length($4)-3)
	field[x[sensors],y[sensors]]="S"

	bX[sensors]=substr($9,3,length($9)-3)
	bY[sensors]=substr($10,3)
	field[bX[sensors],bY[sensors]]="B"

	d[sensors]=manhattanDist(x[sensors],y[sensors],bX[sensors],bY[sensors])
}

function swapRanges(ranges,i,j    ,t) {
	t=ranges[i,"left"]
	ranges[i,"left"]=ranges[j,"left"]
	ranges[j,"left"]=t
	t=ranges[i,"right"]
	ranges[i,"right"]=ranges[j,"right"]
	ranges[j,"right"]=t
}

function addRange(ranges,l,r) {
	if (r<0 || l>rows) {
		return
	}
	ranges["length"]++
	ranges[ranges["length"],"left"]=l
	ranges[ranges["length"],"right"]=r
	for (i=ranges["length"];i>1;i--) {
		if (ranges[i,"left"]<ranges[i-1,"left"]) {
			swapRanges(ranges,i,i-1)
		}
		if (ranges[i-1,"right"]>=ranges[i,"left"]) {
			ranges[i-1,"right"]=max(ranges[i-1,"right"],ranges[i,"right"])
			ranges["length"]--
			for (j=i;j<=ranges["length"];j++) {
				swapRanges(ranges,j,j+1)
			}
		}
	}
}

function open(row    ,ranges) {
	for (s=1;s<=sensors;s++) {
		addRange(ranges,left(s,row),right(s,row))
		for (i=1;i<=ranges["length"]-1;i++) {
			if (ranges[i,"left"]<=0 && ranges[i,"right"]>=rows) {
				return -1
			}
		}
	}
	for (i=1;i<=ranges["length"]-1;i++) {
		if (ranges[i,"right"]>=0 && ranges[i+1,"left"]<=rows) {
			return ranges[i,"right"]+1
		}
	}
	return -1
}

END {
	for (row=0;row<=rows;row++) {
		if ((o=open(row))>=0) {
			print o*4000000+row
			exit
		}
	}
}
