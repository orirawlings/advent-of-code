#! /usr/bin/awk -f
#
# --- Part Two ---
# As you walk up the hill, you suspect that the Elves will want to turn this into a hiking trail. The beginning isn't very scenic, though; perhaps you can find a better starting point.
# 
# To maximize exercise while hiking, the trail should start as low as possible: elevation a. The goal is still the square marked E. However, the trail should still be direct, taking the fewest steps to reach its goal. So, you'll need to find the shortest path from any square at elevation a to the square marked E.
# 
# Again consider the example from above:
# 
# Sabqponm
# abcryxxl
# accszExk
# acctuvwj
# abdefghi
# Now, there are six choices for starting position (five marked a, plus the square marked S that counts as being at elevation a). If you start at the bottom-left square, you can reach the goal most quickly:
# 
# ...v<<<<
# ...vv<<^
# ...v>E^^
# .>v>>>^^
# >^>>>>>^
# This path reaches the goal in only 29 steps, the fewest possible.
# 
# What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?

function pos(x,y) {
	return (y-1)*NF+x
}

function x(pos) {
	return (pos-1)%NF+1
}

function y(pos) {
	return int((pos-1)/NF)+1
}

function left(n    ,p) {
	p=pos(x(n)-1,y(n))
	if (x(n)<=1 || height[n]-1>height[p]) {
		return 0
	} 
	return p
}

function right(n    ,p) {
	p=pos(x(n)+1,y(n))
	if (x(n)>=NF || height[n]-1>height[p]) {
		return 0
	} 
	return p
}

function up(n    ,p) {
	p=pos(x(n),y(n)-1)
	if (y(n)<=1 || height[n]-1>height[p]) {
		return 0
	} 
	return p
}

function down(n    ,p) {
	p=pos(x(n),y(n)+1)
	if (y(n)>=NR || height[n]-1>height[p]) {
		return 0
	} 
	return p
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

END {
	# Dijkstra's algorithm to create minimum spanning tree from end back to all other positions
	for (i=1;i<=NR*NF;i++) {
		if (i!=end) {
			steps[i]=NR*NF # maximum possible
			unvisited+=1
		}
	}
	steps[end]=0
	while (unvisited) {
		unvisited=0
		min=NR*NF+1
		for (i=1;i<=NR*NF;i++) {
			if (!visited[i]) {
				unvisited+=1
				if (steps[i]<min) {
					u=i
					min=steps[i]
				}
			}
		}
		visited[u]=1
		
		neighbor[1]=left(u)
		neighbor[2]=right(u)
		neighbor[3]=up(u)
		neighbor[4]=down(u)
		for (i=1;i<=4;i++) {
			v=neighbor[i]
			if (!v || visited[v]) {
				continue
			}
			s=steps[u]+1
			if (s<steps[v]) {
				steps[v]=s
				prev[v]=u
			}
		}
	}

	# find node of height "a" with shortest hike to end
	min=NR*NF
	for (i=1;i<=NR*NF;i++) {
		if (height[i]==ord["a"] && steps[i]<=min) {
			min=steps[i]
		}
	}
	print min
}
