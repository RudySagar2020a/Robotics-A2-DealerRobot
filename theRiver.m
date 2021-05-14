%% The River

function [] = theTurn(robot,cards,CH,CD)

cardNum = 13;
burnCard(robot,cards,cardNum,CD)

cardNum = 14;
showCard(robot,cards,CH,cardNum);

return2Home(robot);

end
