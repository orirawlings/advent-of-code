#! /usr/bin/awk -f
#
# --- Part Two ---
# Now, you just need to put all of the packets in the right order. Disregard the blank lines in your list of received packets.
# 
# The distress signal protocol also requires that you include two additional divider packets:
# 
# [[2]]
# [[6]]
# Using the same rules as before, organize all packets - the ones in your list of received packets as well as the two divider packets - into the correct order.
# 
# For the example above, the result of putting the packets in the correct order is:
# 
# []
# [[]]
# [[[]]]
# [1,1,3,1,1]
# [1,1,5,1,1]
# [[1],[2,3,4]]
# [1,[2,[3,[4,[5,6,0]]]],8,9]
# [1,[2,[3,[4,[5,6,7]]]],8,9]
# [[1],4]
# [[2]]
# [3]
# [[4,4],4,4]
# [[4,4],4,4,4]
# [[6]]
# [7,7,7]
# [7,7,7,7]
# [[8,7,6]]
# [9]
# Afterward, locate the divider packets. To find the decoder key for this distress signal, you need to determine the indices of the two divider packets and multiply them together. (The first packet is at index 1, the second packet is at index 2, and so on.) In this example, the divider packets are 10th and 14th, and so the decoder key is 140.
# 
# Organize all of the packets into the correct order. What is the decoder key for the distress signal?

function number(s) {
	return s~/^[1-9]/
}

function nextItem(s,i    ,a,j,parens) {
	if (i+1>=length(s)) {
		return ""
	}
	split(s,a,"")

	if (a[i+1]=="[") {
		# parse item as list, scan till matching closing "]"
		parens=1
		for (j=i+2;parens>0;j++) { # assume all lists are well-formed in input
			if (a[j]=="[") {
				parens++
			}
			if (a[j]=="]") {
				parens--
			}
		}
	} else {
		# parse item as non-list, scan till next "," or end of s
		j=i+1
		while (j<length(s) && a[j]!=",") {
			j++
		}
	}
	return substr(s,i+1,j-1-i)
}

function compare(left,right    ,l,r,i,j,c) {
	if (number(left)) {
		if (number(right)) {
			return left-right
		}
		return compare("[" left "]", right)
	}
	if (number(right)) {
		return compare(left, "[" right "]")
	}
	# compare lists
	i=1
	j=1
	while (1) {
		l=nextItem(left,i)
		r=nextItem(right,j)
		if (length(l)==0 && length(r)>0) {
			return -1
		}
		if (length(l)==0 && length(r)==0) {
			return 0
		} 
		if (length(l)>0 && length(r)==0) {
			return 1
		}
		if ((c=compare(l,r))!=0) {
			return c
		}
		i+=length(l)+1
		j+=length(r)+1
	}
}

function swap(a,i,j    ,t) {
	t=a[i]
	a[i]=a[j]
	a[j]=t
}

function qsort(a,lo,hi    ,i,last) {
	if (lo>=hi) {
		return
	}
	swap(a,lo,lo+int((hi-lo+1)*rand()))
	last=lo # a[lo] is now partion element
	for (i=lo+1;i<=hi;i++) {
		if (compare(a[i],a[lo])<0) {
			swap(a,++last,i)
		}
	}
	swap(a,lo,last)
	qsort(a,lo,last-1)
	qsort(a,last+1,hi)
}

BEGIN {
	FS=""
	packets[++count]="[[2]]"
	packets[++count]="[[6]]"
}

$0 {
	packets[++count]=$0
}

END {
	qsort(packets,1,count)
	product=1
	for (i=1;i<=count;i++) {
		if (packets[i]=="[[2]]" || packets[i]=="[[6]]") {
			product*=i
		}
	}
	print product
}
