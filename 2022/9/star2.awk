#! /usr/bin/awk -f
#
# --- Part Two ---
# A rope snaps! Suddenly, the river is getting a lot closer than you remember. The bridge is still there, but some of the ropes that broke are now whipping toward you as you fall through the air!
# 
# The ropes are moving too quickly to grab; you only have a few seconds to choose how to arch your body to avoid being hit. Fortunately, your simulation can be extended to support longer ropes.
# 
# Rather than two knots, you now must simulate a rope consisting of ten knots. One knot is still the head of the rope and moves according to the series of motions. Each knot further down the rope follows the knot in front of it using the same rules as before.
# 
# Using the same series of motions as the above example, but with the knots marked H, 1, 2, ..., 9, the motions now occur as follows:
# 
# == Initial State ==
# 
# ......
# ......
# ......
# ......
# H.....  (H covers 1, 2, 3, 4, 5, 6, 7, 8, 9, s)
# 
# == R 4 ==
# 
# ......
# ......
# ......
# ......
# 1H....  (1 covers 2, 3, 4, 5, 6, 7, 8, 9, s)
# 
# ......
# ......
# ......
# ......
# 21H...  (2 covers 3, 4, 5, 6, 7, 8, 9, s)
# 
# ......
# ......
# ......
# ......
# 321H..  (3 covers 4, 5, 6, 7, 8, 9, s)
# 
# ......
# ......
# ......
# ......
# 4321H.  (4 covers 5, 6, 7, 8, 9, s)
# 
# == U 4 ==
# 
# ......
# ......
# ......
# ....H.
# 4321..  (4 covers 5, 6, 7, 8, 9, s)
# 
# ......
# ......
# ....H.
# .4321.
# 5.....  (5 covers 6, 7, 8, 9, s)
# 
# ......
# ....H.
# ....1.
# .432..
# 5.....  (5 covers 6, 7, 8, 9, s)
# 
# ....H.
# ....1.
# ..432.
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# == L 3 ==
# 
# ...H..
# ....1.
# ..432.
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ..H1..
# ...2..
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# .H1...
# ...2..
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# == D 1 ==
# 
# ..1...
# .H.2..
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# == R 4 ==
# 
# ..1...
# ..H2..
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ..1...
# ...H..  (H covers 2)
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ...1H.  (1 covers 2)
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ...21H
# ..43..
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# == D 1 ==
# 
# ......
# ...21.
# ..43.H
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# == L 5 ==
# 
# ......
# ...21.
# ..43H.
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ...21.
# ..4H..  (H covers 3)
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ...2..
# ..H1..  (H covers 4; 1 covers 3)
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ...2..
# .H13..  (1 covers 4)
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ......
# H123..  (2 covers 4)
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# == R 2 ==
# 
# ......
# ......
# .H23..  (H covers 1; 2 covers 4)
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# 
# ......
# ......
# .1H3..  (H covers 2, 4)
# .5....
# 6.....  (6 covers 7, 8, 9, s)
# Now, you need to keep track of the positions the new tail, 9, visits. In this example, the tail never moves, and so it only visits 1 position. However, be careful: more types of motion are possible than before, so you might want to visually compare your simulated rope to the one above.
# 
# Here's a larger example:
# 
# R 5
# U 8
# L 8
# D 3
# R 17
# D 10
# L 25
# U 20
# These motions occur as follows (individual steps are not shown):
# 
# == Initial State ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ...........H..............  (H covers 1, 2, 3, 4, 5, 6, 7, 8, 9, s)
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# == R 5 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ...........54321H.........  (5 covers 6, 7, 8, 9, s)
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# == U 8 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ................H.........
# ................1.........
# ................2.........
# ................3.........
# ...............54.........
# ..............6...........
# .............7............
# ............8.............
# ...........9..............  (9 covers s)
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# == L 8 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ........H1234.............
# ............5.............
# ............6.............
# ............7.............
# ............8.............
# ............9.............
# ..........................
# ..........................
# ...........s..............
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# == D 3 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# .........2345.............
# ........1...6.............
# ........H...7.............
# ............8.............
# ............9.............
# ..........................
# ..........................
# ...........s..............
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# == R 17 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ................987654321H
# ..........................
# ..........................
# ..........................
# ..........................
# ...........s..............
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# == D 10 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ...........s.........98765
# .........................4
# .........................3
# .........................2
# .........................1
# .........................H
# 
# == L 25 ==
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ...........s..............
# ..........................
# ..........................
# ..........................
# ..........................
# H123456789................
# 
# == U 20 ==
# 
# H.........................
# 1.........................
# 2.........................
# 3.........................
# 4.........................
# 5.........................
# 6.........................
# 7.........................
# 8.........................
# 9.........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ...........s..............
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# 
# Now, the tail (9) visits 36 positions (including s) at least once:
# 
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# ..........................
# #.........................
# #.............###.........
# #............#...#........
# .#..........#.....#.......
# ..#..........#.....#......
# ...#........#.......#.....
# ....#......s.........#....
# .....#..............#.....
# ......#............#......
# .......#..........#.......
# ........#........#........
# .........########.........
# Simulate your complete series of motions on a larger rope with ten knots. How many positions does the tail of the rope visit at least once?

function visit(x, y) {
	x+=0
	y+=0
	if (!visited[x,y]) {
		visited[x,y]=1
		count+=1
	}
	if (debug) {
		if (x<minX) {
			minX=x
		}
		if (x>maxX) {
			maxX=x
		}
		if (y<minY) {
			minY=y
		}
		if (y>maxY) {
			maxY=y
		}
	}
}

BEGIN {
	# right
	movesX[ 1, 0, 1,-1]= 1; movesY[ 1, 0, 1,-1]=-1
	movesX[ 1, 0, 1, 0]= 1; movesY[ 1, 0, 1, 0]= 0
	movesX[ 1, 0, 1, 1]= 1; movesY[ 1, 0, 1, 1]= 1

	# left
	movesX[-1, 0,-1,-1]=-1; movesY[-1, 0,-1,-1]=-1
	movesX[-1, 0,-1, 0]=-1; movesY[-1, 0,-1, 0]= 0
	movesX[-1, 0,-1, 1]=-1; movesY[-1, 0,-1, 1]= 1

	# up
	movesX[ 0, 1, 1, 1]= 1; movesY[ 0, 1, 1, 1]= 1
	movesX[ 0, 1, 0, 1]= 0; movesY[ 0, 1, 0, 1]= 1
	movesX[ 0, 1,-1, 1]=-1; movesY[ 0, 1,-1, 1]= 1

	# down
	movesX[ 0,-1, 1,-1]= 1; movesY[ 0,-1, 1,-1]=-1
	movesX[ 0,-1, 0,-1]= 0; movesY[ 0,-1, 0,-1]=-1
	movesX[ 0,-1,-1,-1]=-1; movesY[ 0,-1,-1,-1]=-1


	# right, up
	movesX[ 1, 1, 1,-1]= 1; movesY[ 1, 1, 1,-1]= 0
	movesX[ 1, 1, 1, 0]= 1; movesY[ 1, 1, 1, 0]= 1
	movesX[ 1, 1, 1, 1]= 1; movesY[ 1, 1, 1, 1]= 1
	movesX[ 1, 1, 0, 1]= 1; movesY[ 1, 1, 0, 1]= 1
	movesX[ 1, 1,-1, 1]= 0; movesY[ 1, 1,-1, 1]= 1

	# right, down
	movesX[ 1,-1,-1,-1]= 0; movesY[ 1,-1,-1,-1]=-1
	movesX[ 1,-1, 0,-1]= 1; movesY[ 1,-1, 0,-1]=-1
	movesX[ 1,-1, 1,-1]= 1; movesY[ 1,-1, 1,-1]=-1
	movesX[ 1,-1, 1, 0]= 1; movesY[ 1,-1, 1, 0]=-1
	movesX[ 1,-1, 1, 1]= 1; movesY[ 1,-1, 1, 1]= 0

	# left, down
	movesX[-1,-1,-1, 1]=-1; movesY[-1,-1,-1, 1]= 0
	movesX[-1,-1,-1, 0]=-1; movesY[-1,-1,-1, 0]=-1
	movesX[-1,-1,-1,-1]=-1; movesY[-1,-1,-1,-1]=-1
	movesX[-1,-1, 0,-1]=-1; movesY[-1,-1, 0,-1]=-1
	movesX[-1,-1, 1,-1]= 0; movesY[-1,-1, 1,-1]=-1

	# left, up
	movesX[-1, 1, 1, 1]= 0; movesY[-1, 1, 1, 1]= 1
	movesX[-1, 1, 0, 1]=-1; movesY[-1, 1, 0, 1]= 1
	movesX[-1, 1,-1, 1]=-1; movesY[-1, 1,-1, 1]= 1
	movesX[-1, 1,-1, 0]=-1; movesY[-1, 1,-1, 0]= 1
	movesX[-1, 1,-1,-1]=-1; movesY[-1, 1,-1,-1]= 0
	
	knots=10
	for (k=1;k<=knots;k++) {
		x[k]=0
		y[k]=0
	}
	visit(x[knots],y[knots])
}

function move(k, xDelta, yDelta) {
	xDelta+=0
	yDelta+=0
	if (!xDelta && !yDelta) {
		return
	}
	linkX=x[k]-x[k+1]
	linkY=y[k]-y[k+1]
	x[k]+=xDelta
	y[k]+=yDelta
	if (k==knots) {
		return
	}
	move(k+1,movesX[xDelta,yDelta,linkX,linkY],movesY[xDelta,yDelta,linkX,linkY])
}

{
	xDelta=0
	yDelta=0
	if ($1=="R") {
		xDelta=1
	}
	if ($1=="L") {
		xDelta=-1
	}
	if ($1=="U") {
		yDelta=1
	}
	if ($1=="D") {
		yDelta=-1
	}
	for (i=1;i<=$2;i++) {
		move(1,xDelta,yDelta)
		visit(x[knots],y[knots])
	}
}

debug {
	# Display state
	print
	for (i=maxY+knots-1;i>=minY-knots+1;i--) {
		for (j=minX-knots+1;j<=maxX+knots-1;j++) {
			c="."
			if (visited[j,i]) {
				c="#"
			}
			for (k=knots;k>=1;k--) {
				if (j==x[k] && i==y[k]) {
					c=sprintf("%d",k-1)
					if (k==1) {
						c="H"
					}
				}
			}
			printf(c)
		}
		print ""
	}
}

END {
	print count
}
