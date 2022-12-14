#! /usr/bin/awk -f
#
# --- Day 12: Hill Climbing Algorithm ---
# You try contacting the Elves using your handheld device, but the river you're following must be too low to get a decent signal.
# 
# You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows the local area from above broken into a grid; the elevation of each square of the grid is given by a single lowercase letter, where a is the lowest elevation, b is the next-lowest, and so on up to the highest elevation, z.
# 
# Also included on the heightmap are marks for your current position (S) and the location that should get the best signal (E). Your current position (S) has elevation a, and the location that should get the best signal (E) has elevation z.
# 
# You'd like to reach E, but to save energy, you should do it in as few steps as possible. During each step, you can move exactly one square up, down, left, or right. To avoid needing to get out your climbing gear, the elevation of the destination square can be at most one higher than the elevation of your current square; that is, if your current elevation is m, you could step to elevation n, but not to elevation o. (This also means that the elevation of the destination square can be much lower than the elevation of your current square.)
# 
# For example:
# 
# Sabqponm
# abcryxxl
# accszExk
# acctuvwj
# abdefghi
# Here, you start in the top-left corner; your goal is near the middle. You could start by moving down or right, but eventually you'll need to head toward the e at the bottom. From there, you can spiral around to the goal:
# 
# v..v<<<<
# >v.vv<<^
# .>vv>E^^
# ..v>>>^^
# ..>>>>>^
# In the above diagram, the symbols indicate whether the path exits each square moving up (^), down (v), left (<), or right (>). The location that should get the best signal is still E, and . marks unvisited squares.
# 
# This path reaches the goal in 31 steps, the fewest possible.
# 
# What is the fewest steps required to move from your current position to the location that should get the best signal?

function pos(x,y) {
	return (y-1)*NF+x
}

function x(pos) {
	return (pos-1)%NF+1
}

function y(pos) {
	return int((pos-1)/NF)+1
}

function abs(n) {
	if (n<0) {
		return -n
	}
	return n
}

function manhattanDist(a, b) {
	return abs(x(a)-x(b))+abs(y(a)-y(b))
}

# findNeighbors of n that are climbable, insert into neighbors and return count of neighbors
function findNeighbors(n    ,h,p,count) {
	delete neighbors
	h=height[n]
	# left?
	if (x(n)>1) {
		p=pos(x(n)-1,y(n))
		if (height[p]<=h+1) {
			count+=1
			neighbors[count]=p
		}
	}
	# right?
	if (x(n)<NF) {
		p=pos(x(n)+1,y(n))
		if (height[p]<=h+1) {
			count+=1
			neighbors[count]=p
		}
	}
	# up?
	if (y(n)>1) {
		p=pos(x(n),y(n)-1)
		if (height[p]<=h+1) {
			count+=1
			neighbors[count]=p
		}
	}
	# down?
	if (y(n)<NR) {
		p=pos(x(n),y(n)+1)
		if (height[p]<=h+1) {
			count+=1
			neighbors[count]=p
		}
	}
	return count
}

# insert n into frontier min-heap
function insert(n    ,i,parent) {
	frontierSize+=1
	frontier[frontierSize]=n
	inFrontier[n]=1
	i=frontierSize
	while (i>1) {
		parent=int(i/2)
		if (guess[n]>=guess[frontier[parent]]) {
			break
		}
		# swap with parent to restore min property of min-heap
		frontier[i]=frontier[parent]
		frontier[parent]=n
		i=parent
	}
}

# minHeapify pushes down the item at position i until min property of frontier min-heap is restored
function minHeapify(i    ,min,left,right,t) {
	left=2*i
	right=2*i+1
	min=i
	if (left<=frontierSize && guess[frontier[left]] < guess[frontier[min]]) {
		min=left
	}
	if (right<=frontierSize && guess[frontier[right]] < guess[frontier[min]]) {
		min=right
	}
	if (min!=i) {
		t=frontier[i]
		frontier[i]=frontier[min]
		frontier[min]=t
		minHeapify(min)
	}
}

# remove minimum from frontier min-heap
function remove() {
	delete inFrontier[frontier[1]]
	frontier[1]=frontier[frontierSize]
	frontierSize-=1
	minHeapify(1)
}

BEGIN {
	FS=""
	# from 'a' to 'z'
	for (i=97;i<=122;i++) {
		ord[sprintf("%c",i)]=i
	}
}

{
	for (i=1;i<=NF;i++) {
		n=pos(i,NR)
		map[n]=$i
		if ($i=="S") {
			start=n
			height[n]=ord["a"]
		} else if ($i=="E") {
			end=n
			height[n]=ord["z"]
		} else {
			height[n]=ord[$i]
		}
	}
}

function show(    i,j,best) {
	best=start
	for (i=1;i<=NR*NF;i++) {
		if (visited[i]) {
			if (manhattanDist(i,end)<manhattanDist(best,end)) {
				best=i
			}
			display[i]="#"
		} else {
			display[i]="."
		}
	}
	display[end]="E"
	if (visited[end]) {
		i=end
	} else {
		i=best
		display[i]="B"
	}
	while (i!=start) {
		f=cameFrom[i]
		if (x(f)<x(i)) {
			display[f]=">"
		} else if (x(f)>x(i)) {
			display[f]="<"
		} else if (y(f)<y(i)) {
			display[f]="v"
		} else if (y(f)>y(i)) {
			display[f]="^"
		}
		i=f
	}
	for (j=1;j<=NR;j++) {
		for (i=1;i<=NF;i++) {
			printf(map[pos(i,j)])
		}
		printf(" ")
		for (i=1;i<=NF;i++) {
			printf(display[pos(i,j)])
		}
		print ""
	}
	if (debug>=2) {
		for (i=1;i<=45-NR;i++) {
			print ""
		}
	}
}

END {
	# A* search from start to end
	guess[start]=manhattanDist(start,end)
	insert(start)
	while (frontierSize>0) {
		if (debug>=2) {
			show()
		}
		n=frontier[1]
		visited[n]=1
		if (n==end) {
			if (debug) {
				show()
			}
			print steps[end]
			exit
		}
		remove()
		num=findNeighbors(n)
		for (i=1;i<=num;i++) {
			neighbor=neighbors[i]
			s=steps[n]+1
			if (!steps[neighbor] || s<steps[neighbor]) {
				steps[neighbor]=s
				guess[neighbor]=s+manhattanDist(neighbor,end)
				cameFrom[neighbor]=n
				if (!inFrontier[neighbor]) {
					insert(neighbor)
				}
			}
		}
	}
	# no path from start to end
	if (debug) {
		show()
	}
	exit 1
}
