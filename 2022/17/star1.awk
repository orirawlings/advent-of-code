#! /usr/bin/awk -f
#
# --- Day 17: Pyroclastic Flow ---
# Your handheld device has located an alternative exit from the cave for you and the elephants. The ground is rumbling almost continuously now, but the strange valves bought you some time. It's definitely getting warmer in here, though.
# 
# The tunnels eventually open into a very tall, narrow chamber. Large, oddly-shaped rocks are falling into the chamber from above, presumably due to all the rumbling. If you can't work out where the rocks will fall next, you might be crushed!
# 
# The five types of rocks have the following peculiar shapes, where # is rock and . is empty space:
# 
# ####
# 
# .#.
# ###
# .#.
# 
# ..#
# ..#
# ###
# 
# #
# #
# #
# #
# 
# ##
# ##
# The rocks fall in the order shown above: first the - shape, then the + shape, and so on. Once the end of the list is reached, the same order repeats: the - shape falls first, sixth, 11th, 16th, etc.
# 
# The rocks don't spin, but they do get pushed around by jets of hot gas coming out of the walls themselves. A quick scan reveals the effect the jets of hot gas will have on the rocks as they fall (your puzzle input).
# 
# For example, suppose this was the jet pattern in your cave:
# 
# >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
# In jet patterns, < means a push to the left, while > means a push to the right. The pattern above means that the jets will push a falling rock right, then right, then right, then left, then left, then right, and so on. If the end of the list is reached, it repeats.
# 
# The tall, vertical chamber is exactly seven units wide. Each rock appears so that its left edge is two units away from the left wall and its bottom edge is three units above the highest rock in the room (or the floor, if there isn't one).
# 
# After a rock appears, it alternates between being pushed by a jet of hot gas one unit (in the direction indicated by the next symbol in the jet pattern) and then falling one unit down. If any movement would cause any part of the rock to move into the walls, floor, or a stopped rock, the movement instead does not occur. If a downward movement would have caused a falling rock to move into the floor or an already-fallen rock, the falling rock stops where it is (having landed on something) and a new rock immediately begins falling.
# 
# Drawing falling rocks with @ and stopped rocks with #, the jet pattern in the example above manifests as follows:
# 
# The first rock begins falling:
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# +-------+
# 
# Jet of gas pushes rock right:
# |...@@@@|
# |.......|
# |.......|
# |.......|
# +-------+
# 
# Rock falls 1 unit:
# |...@@@@|
# |.......|
# |.......|
# +-------+
# 
# Jet of gas pushes rock right, but nothing happens:
# |...@@@@|
# |.......|
# |.......|
# +-------+
# 
# Rock falls 1 unit:
# |...@@@@|
# |.......|
# +-------+
# 
# Jet of gas pushes rock right, but nothing happens:
# |...@@@@|
# |.......|
# +-------+
# 
# Rock falls 1 unit:
# |...@@@@|
# +-------+
# 
# Jet of gas pushes rock left:
# |..@@@@.|
# +-------+
# 
# Rock falls 1 unit, causing it to come to rest:
# |..####.|
# +-------+
# 
# A new rock begins falling:
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |.......|
# |.......|
# |..####.|
# +-------+
# 
# Jet of gas pushes rock left:
# |..@....|
# |.@@@...|
# |..@....|
# |.......|
# |.......|
# |.......|
# |..####.|
# +-------+
# 
# Rock falls 1 unit:
# |..@....|
# |.@@@...|
# |..@....|
# |.......|
# |.......|
# |..####.|
# +-------+
# 
# Jet of gas pushes rock right:
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |.......|
# |..####.|
# +-------+
# 
# Rock falls 1 unit:
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |..####.|
# +-------+
# 
# Jet of gas pushes rock left:
# |..@....|
# |.@@@...|
# |..@....|
# |.......|
# |..####.|
# +-------+
# 
# Rock falls 1 unit:
# |..@....|
# |.@@@...|
# |..@....|
# |..####.|
# +-------+
# 
# Jet of gas pushes rock right:
# |...@...|
# |..@@@..|
# |...@...|
# |..####.|
# +-------+
# 
# Rock falls 1 unit, causing it to come to rest:
# |...#...|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# A new rock begins falling:
# |....@..|
# |....@..|
# |..@@@..|
# |.......|
# |.......|
# |.......|
# |...#...|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# The moment each of the next few rocks begins falling, you would see this:
# 
# |..@....|
# |..@....|
# |..@....|
# |..@....|
# |.......|
# |.......|
# |.......|
# |..#....|
# |..#....|
# |####...|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |..@@...|
# |..@@...|
# |.......|
# |.......|
# |.......|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |...@...|
# |..@@@..|
# |...@...|
# |.......|
# |.......|
# |.......|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |....@..|
# |....@..|
# |..@@@..|
# |.......|
# |.......|
# |.......|
# |..#....|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |..@....|
# |..@....|
# |..@....|
# |..@....|
# |.......|
# |.......|
# |.......|
# |.....#.|
# |.....#.|
# |..####.|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |..@@...|
# |..@@...|
# |.......|
# |.......|
# |.......|
# |....#..|
# |....#..|
# |....##.|
# |....##.|
# |..####.|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# 
# |..@@@@.|
# |.......|
# |.......|
# |.......|
# |....#..|
# |....#..|
# |....##.|
# |##..##.|
# |######.|
# |.###...|
# |..#....|
# |.####..|
# |....##.|
# |....##.|
# |....#..|
# |..#.#..|
# |..#.#..|
# |#####..|
# |..###..|
# |...#...|
# |..####.|
# +-------+
# To prove to the elephants your simulation is accurate, they want to know how tall the tower will get after 2022 rocks have stopped (but before the 2023rd rock begins falling). In this example, the tower of rocks will be 3068 units tall.
# 
# How many units tall will the tower of rocks be after 2022 rocks have stopped falling?

BEGIN {
	FS=""
}

END {
	r=r "####"
	r=r "    "
	r=r "    "
	r=r "    "

	r=r " #  "
	r=r "### "
	r=r " #  "
	r=r "    "

	r=r "### "
	r=r "  # "
	r=r "  # "
	r=r "    "

	r=r "#   "
	r=r "#   "
	r=r "#   "
	r=r "#   "

	r=r "##  "
	r=r "##  "
	r=r "    "
	r=r "    "
	split(r,rocks,"")
	for (R=1;R<=2022;R++) {
		X=3
		Y=height+4
		show()
		while (1) {
			j=j%NF+1
			# move
			if ($j=="<") {
				if (!collision(-1,0)) {
					X--
				}
			} else {
				if (!collision(1,0)) {
					X++
				}
			}
			show()
			# fall
			if (collision(0,-1)) {
				set()
				break
			} else {
				Y--
			}
			show()
		}
		show()
	}
	print height
}

function show(   ,j,k) {
	if (!debug) {
		return
	}
	for (k=height+7;k>=1;k--) {
		printf("|")
		for (j=1;j<=7;j++) {
			if (chamber[j,k]) {
				printf(chamber[j,k])
			} else if (pending(j,k)) {
				printf("@")
			} else {
				printf(".")
			}
		}
		print "|"
	}
	print "+-------+"
	print ""
}

function pending(j,k) {
	return j>=X && j<=X+3 && k>=Y && k<=Y+3 && rocks[(R-1)%5*16+(k-Y)*4+j-X+1]=="#"
}

function collision(xDiff,yDiff    ,j,k,newX,newY) {
	for (j=0;j<4;j++) {
		for (k=0;k<4;k++) {
			if (rocks[(R-1)%5*16+k*4+j+1]!="#") {
				continue
			}
			newX=X+xDiff+j
			newY=Y+yDiff+k
			if (newX<1||newX>7||newY<1||chamber[newX,newY]) {
				return 1
			}
		}
	}
	return 0
}

function set(    ,j,k) {
	for (j=0;j<4;j++) {
		for (k=0;k<4;k++) {
			if (rocks[(R-1)%5*16+k*4+j+1]=="#") {
				chamber[X+j,Y+k]="#"
				if (Y+k>height) {
					height=Y+k
				}
			}
		}
	}
}
