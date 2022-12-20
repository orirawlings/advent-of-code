#! /usr/bin/awk -f
#
# --- Part Two ---
# You're worried that even with an optimal approach, the pressure released won't be enough. What if you got one of the elephants to help you?
# 
# It would take you 4 minutes to teach an elephant how to open the right valves in the right order, leaving you with only 26 minutes to actually execute your plan. Would having two of you working together be better, even if it means having less time? (Assume that you teach the elephant before opening any valves yourself, giving you both the same full 26 minutes.)
# 
# In the example above, you could teach the elephant to help you as follows:
# 
# == Minute 1 ==
# No valves are open.
# You move to valve II.
# The elephant moves to valve DD.
# 
# == Minute 2 ==
# No valves are open.
# You move to valve JJ.
# The elephant opens valve DD.
# 
# == Minute 3 ==
# Valve DD is open, releasing 20 pressure.
# You open valve JJ.
# The elephant moves to valve EE.
# 
# == Minute 4 ==
# Valves DD and JJ are open, releasing 41 pressure.
# You move to valve II.
# The elephant moves to valve FF.
# 
# == Minute 5 ==
# Valves DD and JJ are open, releasing 41 pressure.
# You move to valve AA.
# The elephant moves to valve GG.
# 
# == Minute 6 ==
# Valves DD and JJ are open, releasing 41 pressure.
# You move to valve BB.
# The elephant moves to valve HH.
# 
# == Minute 7 ==
# Valves DD and JJ are open, releasing 41 pressure.
# You open valve BB.
# The elephant opens valve HH.
# 
# == Minute 8 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You move to valve CC.
# The elephant moves to valve GG.
# 
# == Minute 9 ==
# Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
# You open valve CC.
# The elephant moves to valve FF.
# 
# == Minute 10 ==
# Valves BB, CC, DD, HH, and JJ are open, releasing 78 pressure.
# The elephant moves to valve EE.
# 
# == Minute 11 ==
# Valves BB, CC, DD, HH, and JJ are open, releasing 78 pressure.
# The elephant opens valve EE.
# 
# (At this point, all valves are open.)
# 
# == Minute 12 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# ...
# 
# == Minute 20 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# 
# ...
# 
# == Minute 26 ==
# Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.
# With the elephant helping, after 26 minutes, the best you could do would release a total of 1707 pressure.
# 
# With you and an elephant working together for 26 minutes, what is the most pressure you could release?

{
	v=$2
	N[v]=1
	rate=substr($5,6,length($5)-6)
	if (rate>0) {
		F[v]=rate
		I[v]=10^(flows++)
	}
	for (i=10;i<=NF;i++) {
		u=$i
		if (i<NF) {
			u=substr(u,1,length(u)-1)
		}
		E[v,u]=1
	}
}

END {
	# Floyd-Warshall algorithm to find shortest path between all node pairs
	for (x in N) {
		for (y in N) {
			if (x==y) {
				T[x,y]=0
			} else if (E[x,y]) {
				T[x,y]=1
			} else {
				T[x,y]=99999999999999999 # infinity-like
			}
		}
	}
	for (k in N) {
		for (i in N) {
			for (j in N) {
				T[i,j]=min(T[i,j],T[i,k]+T[k,j])
			}
		}
	}

	search("AA",26,0,0,answers)
	for (s1 in answers) {
		for (s2 in answers) {
			if ((s1+s2)!~2) { # disjoint sets
				combined[s1,s2]=answers[s1]+answers[s2]
			}
		}
	}
	print maxOf(combined)
}

function min(a,b) {
	if (a<b) {
		return a
	}
	return b
}

function max(a,b) {
	if (a>b) {
		return a
	}
	return b
}

function maxOf(answers    ,a,result) {
	for (a in answers) {
		result=max(result,answers[a])
	}
	return result
}

function search(v,remaining,state,flow,answers    ,newRemaining) {
	answers[state]=max(answers[state],flow)
	for (u in F) {
		newRemaining=remaining-T[v,u]-1
		if (newRemaining<=0 || (I[u]+state)~2) {
			continue
		}
		search(u,newRemaining,I[u]+state,flow+newRemaining*F[u],answers)
	}
}
