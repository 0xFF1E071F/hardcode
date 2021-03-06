# block preprocessor for assembler.

import sys

BlockNumber = 0
BlockLevel = 0
ActiveBlockList = []

print "; *** this file was generated by blockpp."

for line in sys.stdin.readlines():
	if line.find("{") != -1:
		BlockNumber += 1
		BlockLevel += 1
		line = line[line.find("{"):].replace("{", "%*s_continue_%d:" % (BlockLevel, "", BlockNumber))
		print line,
		ActiveBlockList.append(BlockNumber)
		continue
	
	if line.find("}") != -1:
		line = line[line.find("}"):].replace("}", "%*s_break_%d:" % (BlockLevel, "", ActiveBlockList[-1]))
		print line,
		BlockLevel -= 1
		ActiveBlockList = ActiveBlockList[:-1]
		continue
	
	for key in ["continue", "break"]:
		if line.find(key) != -1:
			line = line.replace(key, "_%s_%d" % (key, ActiveBlockList[-1]))
	
	print line,

