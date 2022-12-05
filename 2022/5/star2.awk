#! /usr/bin/awk -f
#
# --- Part Two ---
# As you watch the crane operator expertly rearrange the crates, you notice the process isn't following your prediction.
# 
# Some mud was covering the writing on the side of the crane, and you quickly wipe it away. The crane isn't a CrateMover 9000 - it's a CrateMover 9001.
# 
# The CrateMover 9001 is notable for many new and exciting features: air conditioning, leather seats, an extra cup holder, and the ability to pick up and move multiple crates at once.
# 
# Again considering the example above, the crates begin in the same configuration:
# 
#     [D]    
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 
# Moving a single crate from stack 2 to stack 1 behaves the same as before:
# 
# [D]        
# [N] [C]    
# [Z] [M] [P]
#  1   2   3 
# However, the action of moving three crates from stack 1 to stack 3 means that those three moved crates stay in the same order, resulting in this new configuration:
# 
#         [D]
#         [N]
#     [C] [Z]
#     [M] [P]
#  1   2   3
# Next, as both crates are moved from stack 2 to stack 1, they retain their order as well:
# 
#         [D]
#         [N]
# [C]     [Z]
# [M]     [P]
#  1   2   3
# Finally, a single crate is still moved from stack 1 to stack 2, but now it's crate C that gets moved:
# 
#         [D]
#         [N]
#         [Z]
# [M] [C] [P]
#  1   2   3
# In this example, the CrateMover 9001 has put the crates in a totally different order: MCD.
# 
# Before the rearrangement process finishes, update your simulation so that the Elves know where they should stand to be ready to unload the final supplies. After the rearrangement procedure completes, what crate ends up on top of each stack?

!initialized && /\[/ {
	# record crate configuration at this height
	initial[NR]=$0
	next
}

!initialized {
	numStacks=NF # total number of stacks
	for (i=NR-1;i>=1;i--) { # walk back up the stacks of crates we remembered earlier
		split(initial[i],crates,"")
		for (j=1;j<=numStacks;j++) {
			crate=crates[(j-1)*4+2] # find the character for each crate in row
			if (crate!=" ") {
				stackLengths[j]+=1
				stacks[j,stackLengths[j]]=crate
			}
		}
	}
	initialized=1
} 

/^move [0-9]+ from [0-9]+ to [0-9]+$/ {
	count=$2
	from=$4
	to=$6
	stackLengths[to]+=count
	for (i=0;i<count;i++) {
		stacks[to,stackLengths[to]-i]=stacks[from,stackLengths[from]-i]
	}
	stackLengths[from]-=count
}

END {
	for (i=1;i<=numStacks;i++) {
		printf("%s",stacks[i,stackLengths[i]])
	}
	print ""
}
