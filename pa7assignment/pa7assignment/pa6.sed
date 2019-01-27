#!/usr/bin/sed -f
# This program redoes pa4.sed, but makes use of any sed commands that we want.
# One benefit of redoing pa4.sed is that we now can use conditional branching 
# to replace any length of input. (Recall that we previously had to copy-paste 
# a fixed number of times.)

# In the code below, I follow a specific format:                              
# 1. Comment line(s) that describe what the line after it is meant to do.     
# 2. One "..." command line, that you are supposed to fill in.            
# 3. Four(or more) final comment lines that specify the contents of the hold  
#    space (HS) and the pattern space (PS) states, as they should be after the
#    preceding command finishes. (If I don't show the HS and PS states, it is 
#    because the preceding command does not change the HS or PS.              



###############################################################################
# First, we rename backslash-quoted symbols: "\\", "\[", "\ ", and "\".       #
###############################################################################
s,\\,%,g; s,%%,#,g; s,%\[,%@,g; s,% ,%_,g;
###############################################################################
#HS:                                                                          #
#  Empty                                                                      #
#PS:                                                                          #
#  Everything from the input line modifed by the following rules:             #
#    "\\"  ->  "#"                                                            #
#    "\["  ->  "%@"                                                           #
#    "\ "  ->  "%_"                                                           #
#    "\"   ->  "%"                                                            #
###############################################################################



###############################################################################
# The following line defines a label that indicates the top of a loop.        #
# (The concept of this loop is that the loop body finds spaces that are inside#
# the leftmost "[...]". And, having dealt with these, the "[" and the "]" of  #
# the "[...]" get converted to "+" and "|", respectively -- thus turning it   #
# into "+...|" (and, thus, no longer the leftmost "[...]".)                   #
###############################################################################
:L


###############################################################################
# The following line is a series of commands to modify the HS and PS to obtain#
# the contents indicated. In addition, one of the commands branches forward   #
# in the case that there are no more "[" symbols remaining.                   #
# Note: You can accomplish this branching with "b" or "T". "T" is the negative#
#       form of "t". I had not known this command before. I have now added it #
#       to the updated Slide #18 of Lecture #11 (now named "USP17_L11realfin").
###############################################################################
h; s,\[.*,,; x; TM; s,[^[]*\[,,
###############################################################################
#HS:                                                                          #
#   Everything before the leftmost "["                                        #
#PS:                                                                          #
#   Everything after the leftmost "["                                         #
###############################################################################



###############################################################################
# The following looks at the leftmost "[...]" (which, at this point, is at the#
# front of the PS), to see if it is a "[]...]" or a "[^]...]".                #
###############################################################################
s,^^],^~,; s,^],~,
###############################################################################
#HS:                                                                          #
#   Everything before the leftmost "["                                        #
#PS:                                                                          #
#   Everything after the leftmost "[". But in the cases of a PS starting with #
#   a "]" or a "^]", they are converted to a "~" or a "^~", respectively.     #
###############################################################################



###############################################################################
# The following line now: 1) issolates and 2) processes the leftmost "[...]". #
#  1. To begin issolating the "...", replace the "]" with a "\n". But that is #
#     Not enough. Now there will be a "\n" in the PS, with the part we are    #
#     presently interested in being before the \n. We want to make it the only#
#     thing in the PS. But we can't just throw out the rest, because we will  #
#     Need it later. The solution is to carefully use the HS. If you note the #
#     Desired HS and PS final states (shown below), you get a better idea.    #
#  2. To process the "...", we want to indicate that its internal "[" symbols #
#     don't start sets, and that its " " symbols are not outside spaces. To   #
#     do this indicating, we replace them with "@" and "_", respectively.     #
###############################################################################
s,],\n,; H; s,\n.*,,;s, ,_,g; s,\[,@,g;
###############################################################################
#HS (holds 3 lines):                                                          #
#   Everything before the leftmost "["                                        #
#   Everthing inside of the leftmost "[...]"                                  #
#   Everything after the "]" that closes out the leftmost "[...]"             #
#PS:                                                                          #
#   Eveything inside the leftmost "[...]", but with each " " converted to a   #
#   "_" and each "[" converted to a "@"                                       #
###############################################################################



###############################################################################
# Now we want to make the PS hold the input with the leftmost [...] dealt with.
# Hint: Notice that, above, the HS has the "before" and the "after" that we   #
#       want, and notice that the PS has the "inside" that we want. We just   #
#       need to combine them.                                                 #
###############################################################################
G; s,\(.*\)\n\(.*\)\n\(.*\)\n,\2+\1|,
###############################################################################
#HS:                                                                          #
#  Don't care.                                                                #
#PS:                                                                          #
#  The leftmost "[...]" has become "+...|" (and its "..." has been dealt with)#
###############################################################################


###############################################################################
# Now we jump up to the label to process the new leftmost "[...]". This jump is
# "unconditional" in the sense that we always want to jump to happen. But it is
# implemented, in actual fact, as a conditional jump. We do this because: 1) we
# know, by thoughtful consideration of the above code, that the "s-flag" will #
# be set by the time that we get to here, and 2) we want to clear that flag.  #
###############################################################################
tL


###############################################################################
# Now we define the label that we had branched to earlier in the program, when#
# there were no more "[...]"                                                  #
###############################################################################
:M


###############################################################################
# Now we convert all remaining spaces to "&" symbols, then we restore all of  #
# the special symbols (other than "&"):                                       #
###############################################################################
s, ,\&,g; s,@,[,g; s,~,],g; s,+,[,g; s,|,],g; s,_, ,g; s,#,\\\\,g; s,%,\\,g


###############################################################################
# Finally, we replace each "&" with the end-of-line-allowing patern:          #
###############################################################################
s,&,[\\n\\t\\r ][\\n\\t\\r ]*,g
###############################################################################
# Note: I have given you the above line. But I have also commented it out. The#
#       reason is that you should not uncomment it until all of the other parts
#       parts of the assignment are done. And the reason for that is that this#
#       line makes the inputted regular expression uglier -- thereby making it#
#       harder to debug whether it is properly identifying outside spaces.    #
###############################################################################
