%% The Turn

function [] = theTurn(robot,cards,CH,CD)

cardNum = 11;
burnCard(robot,cards,cardNum,CD)

cardNum = 12;
showCard(robot,cards,CH,cardNum)
return2Home(robot);
end
