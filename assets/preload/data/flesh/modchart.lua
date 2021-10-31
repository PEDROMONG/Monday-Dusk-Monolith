function start (song)
end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)

    if shakehud then
        camHudAngle = 3 * math.sin(currentBeat * 20)
    end
end

function beatHit (beat)
end

function stepHit (step)

	-- hud shake timing
	if not shakehud and (step >= 400 and step < 416) then
		shakehud = true
	elseif shakehud and (step >= 416) then
		shakehud = false
		camHudAngle = 0
	end
	
	-- break notes apart at end
	if (step >= 800) and not activate then
		activate = true
		
		setActorVelocityX(-20, 0)
		setActorVelocityY(-100, 0)
		
		setActorVelocityX(-30, 1)
		setActorVelocityY(-220, 1)
		
		setActorVelocityX(50, 2)
		setActorVelocityY(-70, 2)
		
		setActorVelocityX(10, 3)
		setActorVelocityY(-200, 3)
		for i=0,3 do
			setActorAccelerationY(300, i)
		end
	end	
end