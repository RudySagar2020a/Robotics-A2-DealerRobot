%% The Flop

function [q] = theFlop(robot,cards,CH,CD)

cardNum = 7;
burnCard(robot,cards,cardNum,CD);

for cardNum = 8:10
   showcard(robot,cards,cardNum);
end
end

