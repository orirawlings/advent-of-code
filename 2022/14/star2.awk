#! /usr/bin/awk -f
#
#--- Part Two ---
#You realize you misread the scan. There isn't an endless void at the bottom of the scan - there's floor, and you're standing on it!
#
#You don't have time to scan the floor, so assume the floor is an infinite horizontal line with a y coordinate equal to two plus the highest y coordinate of any point in your scan.
#
#In the example above, the highest y coordinate of any point is 9, and so the floor is at y=11. (This is as if your scan contained one extra rock path like -infinity,11 -> infinity,11.) With the added floor, the example above now looks like this:
#
#        ...........+........
#        ....................
#        ....................
#        ....................
#        .........#...##.....
#        .........#...#......
#        .......###...#......
#        .............#......
#        .............#......
#        .....#########......
#        ....................
#<-- etc #################### etc -->
#To find somewhere safe to stand, you'll need to simulate falling sand until a unit of sand comes to rest at 500,0, blocking the source entirely and stopping the flow of sand into the cave. In the example above, the situation finally looks like this after 93 units of sand come to rest:
#
#............o............
#...........ooo...........
#..........ooooo..........
#.........ooooooo.........
#........oo#ooo##o........
#.......ooo#ooo#ooo.......
#......oo###ooo#oooo......
#.....oooo.oooo#ooooo.....
#....oooooooooo#oooooo....
#...ooo#########ooooooo...
#..ooooo.......ooooooooo..
##########################
#Using your scan, simulate the falling sand until the source of the sand becomes blocked. How many units of sand come to rest?

function abs(n) {
	if (n<0) {
		return -n
	}
	return n
}

function updateBounds(point) {
	if (point[1]<minX) {
		minX=point[1]
	}
	if (point[1]>maxX) {
		maxX=point[1]
	}
	if (point[2]<minY) {
		minY=point[2]
	}
	if (point[2]>maxY) {
		maxY=point[2]
	}
}

BEGIN {
	FS=" -> "
	cave[500,0]="+"
	minX=500
	maxX=500
	minY=0
	maxY=0
}

{
	for (i=1;i<=NF;i++) {
		split($i,current,",")
		updateBounds(current)
		if (i==1) {
			continue
		}
		split($(i-1),last,",")
		cave[current[1],current[2]]="#"
		if (last[1]==current[1]) { # horizontal rock
			for (j=last[2];j!=current[2];j+=(current[2]-last[2])/abs(current[2]-last[2])) {
				cave[current[1],j]="#"
			}
		} else if (last[2]==current[2]) { # vertical rock
			for (j=last[1];j!=current[1];j+=(current[1]-last[1])/abs(current[1]-last[1])) {
				cave[j,current[2]]="#"
			}
		}
	}
}

function show(    x,y) {
	for (y=minY;y<=maxY+2;y++) {
		for (x=minX;x<=maxX;x++) {
			if (y==maxY+2) {
				printf("#")
			} else if (!cave[x,y]) {
				printf(".")
			} else {
				printf(cave[x,y])
			}
		}
		print ""
	}
	print "---"
}

function dropGrain() {
	sand[1]=500
	sand[2]=0
	while (cave[500,0]!="o") {
		if (sand[2]==maxY+1) {
			cave[sand[1],sand[2]]="o"
			return 1 # resting on the floor
		} else if (!cave[sand[1],sand[2]+1]) {
			sand[2]++
		} else if (!cave[sand[1]-1,sand[2]+1]) {
			sand[1]--
			sand[2]++
		} else if (!cave[sand[1]+1,sand[2]+1]) {
			sand[1]++
			sand[2]++
		} else {
			cave[sand[1],sand[2]]="o"
			return 1
		}
	}
	return 0 # filled the cave
}

END {
	while(dropGrain()) {
		sum++
		if (debug>=2) {
			show()
		}
	}
	if (debug) {
		show()
	}
	print sum
}
