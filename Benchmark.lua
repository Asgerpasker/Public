-- heavy todo stuff with new func
local INSERT, CLEAR, HUGE = table.insert, table.clear, math.huge;
local wait, tick, print = task.wait, tick, print;

getgenv().Benchmark = function(func, iterations, interval)
	local Times, Combined = {}, 0;
	local Fastest, Slowest = HUGE, -1;
	local FastestI, SlowestI;

	for i = 1, iterations do
		local Start = tick();
		func();
		local Took = tick() - Start;
		INSERT(Times, Took);
		
		if Fastest > Took then
			Fastest, FastestI = Took, i;
		end; if Took > Slowest then
			Slowest, SlowestI = Took, i;
		end;
		
		if interval then
			wait(interval);
		end;
	end;

	for i,v in next, Times do
		Combined += v;
	end;
	
	print("Took a total of "..Combined..", with "..iterations.." iterations");
	print("Average was "..Combined / #Times);
	print("Fastest was "..Fastest..", at iteration "..FastestI);
	print("Slowest was "..Slowest..", at iteration "..SlowestI);
	CLEAR(Times);
end;
