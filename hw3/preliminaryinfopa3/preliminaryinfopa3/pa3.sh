# "l" displays short or long room contents, based on whether it's been visited:
alias l='(head -n [0-9]* con*; ls ??[^umbirdfsn]*>& ~/X &&echo Here there is:\
        && head -1q ??[^umbirdfsn]*;ls 1 >&~/X||mv -f 9 1 >&~/X)'

# "look" let's the player see the long-form display of already visited rooms:
alias look='mv -f 1 9 >& ~/X; l'

# These 2 aliases are support functions for the movement commands that follow: 
alias BacktrackTest='cd `pwd -P` >& ~/X; expr `pwd|xargs basename` =='
alias nogo='echo "You cannot go that way."'

# Eight of the movements have Backtrack and Forward movement.
#         Backtracking movement:            Forward move:  Succeed:   Fail:    
alias nw='BacktrackTest se>&~/X && cd .. || cd nw>& ~/X    && l    || nogo'
alias ne='BacktrackTest sw>&~/X && cd .. || cd ne>& ~/X    && l    || nogo'
alias sw='BacktrackTest ne>&~/X && cd .. || cd sw>& ~/X    && l    || nogo'
alias se='BacktrackTest nw>&~/X && cd .. || cd se>& ~/X    && l    || nogo'
alias e='BacktrackTest w >& ~/X && cd .. || cd e >& ~/X    && l    || nogo'
alias n='BacktrackTest s >& ~/X && cd .. || cd n >& ~/X    && l    || nogo'
alias s='BacktrackTest n >& ~/X && cd .. || cd s >& ~/X    && l    || nogo'
alias d='BacktrackTest u >& ~/X && cd .. || cd d >& ~/X    && l    || nogo'

# One movement, up, is special because it can't backtrack:
alias u='cd u >&~/X && l || nogo'

# The final movement, west, is special because the forward movement may, in one
# location, be prevented by the electronic door at ~/pa3/start/e/e/n/w.
# You have to write the "trydoor" script to deal with this case. Also, because
# the electronic door relocks itself, we need to relock the door. We could have
# done this by locking it only after entering the locked room, but the code is
# simpler for us to just always lock the room, without bothering to check
# whether it is already locked:
alias w='~/trydoor; BacktrackTest e >& ~/X && cd .. || cd w >& ~/X && l||nogo;\
         chmod u-x ~/pa3/start/e/e/n/w'

# The following 3 commands were in programming assignment 2 (although the dig
# command hss been improved to test for whether you hold the shovel).
alias i='echo You currently have:;head -1q ~/pa3/items/??[^xumbirdfs]*'
alias sleep='cat .sleep 2> ~/X || \
            echo "You try to sleep standing up, but cannot manage it."'
alias dig='ls ~/pa3/items/shovel>& ~/X && (mv .platinum platinum 2> ~/X &&echo\
          "I think you found something"||echo "Digging here reveals nothing.")\
	  || echo "You have nothing with which to dig"' 

# The following 6 commands each require you to write a script, as indicated:
alias get='~/get'
alias drop='~/drop'
alias x='~/exam'
alias reset='~/reset'
alias put='~/put'
alias cut='~/cut&&quit'

# The following command starts the game. It is like the last homework, except
# that: 1) it uses my room solution (rooms.tar) and 2) it locks the electronic
# door by making the directory nonexecutable. (I couldn't automatically make
# the directory "locked" at the time when I created rooms.tar because the tar
# program needed access to the directory, in order to tar it up. Likewise, you
# will notice that we needed to "unlock" the directory before running rm -r:
alias game='cd ~; chmod u+x pa3/start/e/e/n/w >& ~/X; rm -r pa3>&~/X;\
            tar -xf rooms.tar >& ~/X; cd pa3/start; chmod u-x e/e/n/w; clear;\
	    l; PS1="> "'

# This command "quits" the game. It creates a "$ " prompt to indicate this.
alias quit='score;cd ~;unalias l look BacktrackTest nogo n e w s ne nw se sw i\
           sleep dig get drop x reset put cut game quit score flush; PS1=\$\ '

# The next 2 commands are the only parts that you need to modify in this file.
# See the README file for details on what these commands are meant to do.
alias score='echo "You have to implement this"' 
alias flush='echo "You have to implement this"' 
