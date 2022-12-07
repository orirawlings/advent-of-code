#! /usr/bin/awk -f
#
# --- Part Two ---
# Now, you're ready to choose a directory to delete.
# 
# The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000. You need to find a directory you can delete that will free up enough space to run the update.
# 
# In the example above, the total size of the outermost directory (and thus the total amount of used space) is 48381165; this means that the size of the unused space must currently be 21618835, which isn't quite the 30000000 required by the update. Therefore, the update still requires a directory with total size of at least 8381165 to be deleted before it can run.
# 
# To achieve this, you have the following options:
# 
# Delete directory e, which would increase unused space by 584.
# Delete directory a, which would increase unused space by 94853.
# Delete directory d, which would increase unused space by 24933642.
# Delete directory /, which would increase unused space by 48381165.
# Directories e and a are both too small; deleting them would not free up enough space. However, directories d and / are both big enough! Between these, choose the smallest: d, increasing unused space by 24933642.
# 
# Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?

/^\$/ {
	listing=0
}

/^\$ cd / {
	if ($3=="/") {
		depth=1
		dirs[depth]="/"
	} else if ($3=="..") {
		depth-=1
	} else {
		depth+=1
		dirs[depth]=dirs[depth-1] $3 "/"
	}
	next
}

/^\$ ls$/ {
	listing=1
	next
}

listing {
	for (i=1;i<=depth;i++) {
		sizes[dirs[i]]+=$1
	}
}

END {
	best=sizes["/"]
	required=30000000-(70000000-best)
	for (dir in sizes) {
		size=sizes[dir]
		if (size>=required && size<best) {
			best=size
		}
	}
	print best
}
