#! /usr/bin/awk -f
#
# --- Day 16: Proboscidea Volcanium ---
# The sensors have led you to the origin of the distress signal: yet another handheld device, just like the one the Elves gave you. However, you don't see any Elves around; instead, the device is surrounded by elephants! They must have gotten lost in these tunnels, and one of the elephants apparently figured out how to turn on the distress signal.
# 
# The ground rumbles again, much stronger this time. What kind of cave is this, exactly? You scan the cave with your handheld device; it reports mostly igneous rock, some ash, pockets of pressurized gas, magma... this isn't just a cave, it's a volcano!
# 
# You need to get the elephants out of here, quickly. Your device estimates that you have 30 minutes before the volcano erupts, so you don't have time to go back out the way you came in.
# 
# You scan the cave for other options and discover a network of pipes and pressure-release valves. You aren't sure how such a system got into a volcano, but you don't have time to complain; your device produces a report (your puzzle input) of each valve's flow rate if it were opened (in pressure per minute) and the tunnels you could use to move between the valves.
# 
# There's even a valve in the room you and the elephants are currently standing in labeled AA. You estimate it will take you one minute to open a single valve and one minute to follow any tunnel from one valve to another. What is the most pressure you could release?
# 
# For example, suppose you had the following scan output:
# 
# Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
# Valve BB has flow rate=13; tunnels lead to valves CC, AA
# Valve CC has flow rate=2; tunnels lead to valves DD, BB
# Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
# Valve EE has flow rate=3; tunnels lead to valves FF, DD
# Valve FF has flow rate=0; tunnels lead to valves EE, GG
# Valve GG has flow rate=0; tunnels lead to valves FF, HH
# Valve HH has flow rate=22; tunnel leads to valve GG
# Valve II has flow rate=0; tunnels lead to valves AA, JJ
# Valve JJ has flow rate=21; tunnel leads to valve II
# All of the valves begin closed. You start at valve AA, but it must be damaged or jammed or something: its flow rate is 0, so there's no point in opening it. However, you could spend one minute moving to valve BB and another minute opening it; doing so would release pressure during the remaining 28 minutes at a flow rate of 13, a total eventual pressure release of 28 * 13 = 364. Then, you could spend your third minute moving to valve CC and your fourth minute opening it, providing an additional 26 minutes of eventual pressure release at a flow rate of 2, or 52 total pressure released by valve CC.
# 
# Making your way through the tunnels like this, you could probably open many or all of the valves by the time 30 minutes have elapsed. However, you need to release as much pressure as possible, so you'll need to be methodical. Instead, consider this approach:
# 
# == Minute 1 ==
# No valves are open.
# You move to valve DD.
# 
# == Minute 2 ==
# No valves are open.
# You open valve DD.
# 
# == Minute 3 ==
# Valve DD is open, releasing 20 pressure.
# You move to valve CC.
# 
# == Minute 4 ==
# Valve DD is open, releasing 20 pressure.
# You move to valve BB.
# 
# == Minute 5 ==
# Valve DD is open, releasing 20 pressure.
# You open valve BB.
# 
# == Minute 6 ==
# Valves BB and DD are open, releasing 33 pressure.
# You move to valve AA.
# 
# == Minute 7 ==
# Valves BB and DD are open, releasing 33 pressure.
# You move to valve II.
# 
# == Minute 8 ==
# Valves BB and DD are open, releasing 33 pressure.
# You move to valve JJ.
# 
# == Minute 9 ==
# Valves BB and DD are open, releasing 33 pressure.
# You open valve JJ.
# 
# == Minute 10 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve II.
# 
# == Minute 11 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve AA.
# 
# == Minute 12 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve DD.
# 
# == Minute 13 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve EE.
# 
# == Minute 14 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve FF.
# 
# == Minute 15 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve GG.
# 
# == Minute 16 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You move to valve HH.
# 
# == Minute 17 ==
# Valves BB, DD, and JJ are open, releasing 54 pressure.
# You open valve HH.
# 
# == Minute 18 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve GG.
# 
# == Minute 19 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve FF.
# 
# == Minute 20 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve EE.
# 
# == Minute 21 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You open valve EE.
# 
# == Minute 22 ==
# Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
# You move to valve DD.
# 
# == Minute 23 ==
# Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
# You move to valve CC.
# 
# == Minute 24 ==
# Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
# You open valve CC.
# 
# == Minute 25 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# == Minute 26 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# == Minute 27 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# == Minute 28 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# == Minute 29 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# == Minute 30 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# This approach lets you release the most pressure possible in 30 minutes with this valve layout, 1651.
# 
# Work out the steps to release the most pressure in 30 minutes. What is the most pressure you can release?

{
	v=$2
	rate[v]=substr($5,6,length($5)-6)
	closed[v]=1
	cost[v,v]=0
	for (i=10;i<=NF;i++) {
		n=$i
		if (i<NF) {
			n=substr(n,1,length(n)-1)
		}
		neighbors[v,++neighborCount[v]]=n
		cost[v,n]=1
	}
}

END {
	# remove trivial nodes from graph
	for (v in closed) {
		if (rate[v]==0 && neighborCount[v]==2) {
			n1=neighbors[v,1]
			n2=neighbors[v,2]
			cost[n1,n2]=cost[n1,v]+cost[v,n2]
			for (i=1;i<=neighborCount[n1];i++) {
				if (neighbors[n1,i]==v) {
					neighbors[n1,i]=n2
				}
			}
			cost[n2,n1]=cost[n2,v]+cost[v,n1]
			for (i=1;i<=neighborCount[n2];i++) {
				if (neighbors[n2,i]==v) {
					neighbors[n2,i]=n1
				}
			}
			delete closed[v]
		}
	}

	# build minimal spanning trees from each node, update minimum costs
	for (v in closed) {
		dijkstra(closed,v)
	}

	search("AA", 30, 0)
	print best
}

# dijkstra's algorithm for constructing a minimum spanning tree from given
# source node to all other nodes. Record best distances.
function dijkstra(graph,source    ,q,dist,count,u,alt) {
	for (v in graph) {
		dist[v]=9999999999999999999999999999999999999999
		q[v]=1
		count++
	}
	dist[source]=0
	while (count>0) {
		u=""
		for (v in q) {
			if (!u || dist[v]<dist[u]) {
				u=v
			}
		}
		delete q[u]
		count--
		for (i=1;i<=neighborCount[u];i++) {
			v=neighbors[u,i]
			alt=dist[u]+cost[u,v]
			if (alt<dist[v]) {
				dist[v]=alt
			}
		}
	}
	for (v in dist) {
		if (source!=v && !cost[source,v]) {
			cost[source,v]=dist[v]
		}
	}
}

function search(current,remaining,score    ,options,i,n) {
	if (remaining<=0 || allOpen()) {
		if (score>best) {
			best=score
		}
		return
	}

	if (bestPossible(current,remaining,score)<best) {
		return
	}
	
	# estimate benefit of locally available options
	if (closed[current]) {
		options[current]=bestReturn(current,current,remaining)
	}
	if (remaining>0) {
		for (i=1;i<=neighborCount[current];i++) {
			n=neighbors[current,i]
			options[n]=bestReturn(current,n,remaining)
		}
	}

	# keep picking from the best remaining options, searching each until none is left
	while (i=pick(options)) {
		if (i==current) {
			closed[current]=0
			search(current,remaining-1,score+(remaining-1)*rate[current])
			closed[current]=1
		} else {
			search(i,remaining-cost[current,i],score)
		}
		delete options[i]
	}
}

# bestPossible upper bound based on how many steps remain and how much pressure
# has already been released. Assume all valves are able to release pressure for
# all remaining steps.
function bestPossible(current,remaining,score    ,v,r) {
	if (remaining>0) {
		for (v in closed) {
			r=bestReturn(current,v,remaining)
			if (r>0) {
				score+=r
			}
		}
	}
	return score
}

# allOpen returns 1 if all helpful valves are open, returns 0 if any are closed
function allOpen() {
	for (v in closed) {
		if (closed[v] && rate[v]>0) {
			return 0
		}
	}
	return 1
}

# bestReturn possible for moving directly to target and opening it, relieving
# pressure for all remaining minutes
function bestReturn(current,target,remaining) {
	return (remaining-(1+cost[current,target]))*rate[target]*closed[target]
}

function pick(options    ,max,best) {
	for (i in options) {
		if (options[i]>=max) {
			max=options[i]
			best=i
		}
	}
	return best
}
