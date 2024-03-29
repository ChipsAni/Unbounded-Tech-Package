--- Free Model Script by SuperSonicBoys1
--- USED IN SONIC MOONLIGHT PACKAGE ENGINE BY CHIPSANIMS
--- MOD FOR SONIC RING ENGINE

local player = game:GetService("Players").LocalPlayer     

local runservice = game:GetService("RunService")
local userinputservice = game:GetService("UserInputService")

_G.rail = nil

_G.path = false
local lastpath = nil
local patht = 0
local pathsp = 0
local pathx = 0

local jumpt = 0

local bodyvelocity,bodygyro,GrindSound,spark1,spark2,normalslide1,fastslide,running
local crouching = false

userinputservice.InputBegan:connect(function(key)
	if userinputservice:GetFocusedTextBox() == nil and player.Character then
		local keycode = key.KeyCode
		local playercharacter = player.Character
		
		if keycode == Enum.KeyCode.Space then
			if _G.rail ~= nil then
				jumpt = tick()
				_G.rail = nil
				_G.path = false
				bodyvelocity.MaxForce = Vector3.new(0, 0, 0)
				bodygyro.MaxTorque = Vector3.new(0, 0, 0)
				spark1.Enabled = false
				spark2.Enabled = false
				normalslide1:Stop()
				fastslide:Stop()
				running:Stop()
				GrindSound:Stop()
				playercharacter:WaitForChild("Humanoid").PlatformStand = false
				playercharacter:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				playercharacter:WaitForChild("HumanoidRootPart").Velocity = playercharacter:WaitForChild("HumanoidRootPart").Velocity + playercharacter:WaitForChild("HumanoidRootPart").CFrame.upVector*50
				
				playercharacter:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(playercharacter:WaitForChild("HumanoidRootPart").Position,playercharacter:WaitForChild("HumanoidRootPart").Position+(playercharacter:WaitForChild("HumanoidRootPart").Velocity-Vector3.new(0,playercharacter:WaitForChild("HumanoidRootPart").Velocity.Y,0)))
			end
		elseif keycode == Enum.KeyCode.E then
			crouching = true
			if _G.rail ~= nil and _G.path == false then
				normalslide1:Stop()
				fastslide:Play()
			end
		end
	end
end)

userinputservice.InputEnded:connect(function(key)
	if userinputservice:GetFocusedTextBox() == nil and player.Character then
		local keycode = key.KeyCode
		local playercharacter = player.Character
		
		if keycode == Enum.KeyCode.E then
			crouching = false
			if _G.rail ~= nil and _G.path == false then
				normalslide1:Play()
				fastslide:Stop()
			end
		end
	end
end)

function rails(raila)
	if (raila ~= _G.rail or _G.rail == nil) and player.Character then
		local playercharacter = player.Character
		
		if _G.rail == nil then
			local dif = math.max((playercharacter.HumanoidRootPart.Velocity.magnitude-80)/75,0)
			speedmulti = 1+dif
			print(speedmulti)
		end
		
		_G.rail = raila
		bodyvelocity.MaxForce = Vector3.new(10000, 10000, 10000)
		bodygyro.MaxTorque = Vector3.new(100000, 100000, 100000)
		
		if crouching then
			fastslide:Play()
			normalslide1:Stop()
		else
			normalslide1:Play()
			fastslide:Stop()
		end
		GrindSound.Pitch = 1
		GrindSound:Play()
		
		bodygyro.CFrame = _G.rail.CFrame
		playercharacter.Humanoid.PlatformStand = true
		if _G.rail ~= nil then
			local xoff = _G.rail.CFrame:toObjectSpace(playercharacter.HumanoidRootPart.CFrame).p.X
			pathx = xoff
			local zoff = _G.rail.CFrame:toObjectSpace(playercharacter.HumanoidRootPart.CFrame).p.Z
			local rot = playercharacter.HumanoidRootPart.CFrame-playercharacter.HumanoidRootPart.CFrame.p
			playercharacter.HumanoidRootPart.CFrame = CFrame.new((_G.rail.CFrame*CFrame.new(xoff,3,zoff)).p)*rot
			playercharacter.HumanoidRootPart.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(0, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * (80 * speedmulti)
			bodyvelocity.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(0, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * (80 * speedmulti)
		end
	end
end

function paths(patha)
	if (patha ~= _G.rail or _G.rail == nil) and player.Character and player.Character:WaitForChild("Humanoid").MoveDirection.magnitude > .5 and (player.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude > 32 or patha.CFrame.lookVector.Y < 0) then
		if not (tick()-patht < .5 and patha == lastpath) then
			local playercharacter = player.Character
			if _G.rail == nil then
				pathsp = math.max(64,playercharacter.HumanoidRootPart.Velocity.magnitude)
			end
			_G.rail = patha
			_G.path = true
			bodyvelocity.MaxForce = Vector3.new(10000, 10000, 10000)
			bodygyro.MaxTorque = Vector3.new(100000, 100000, 100000)
			
			if not running.IsPlaying then
				running:Play()
			end
			
			bodygyro.CFrame = _G.rail.CFrame
			playercharacter.Humanoid.PlatformStand = true
			if _G.rail ~= nil then
				local xoff = _G.rail.CFrame:toObjectSpace(playercharacter.HumanoidRootPart.CFrame).p.X
				if not _G.rail:FindFirstChild("Center") then
					pathx = 0
				else
					pathx = xoff
				end
				local zoff = _G.rail.CFrame:toObjectSpace(playercharacter.HumanoidRootPart.CFrame).p.Z
				local rot = playercharacter.HumanoidRootPart.CFrame-playercharacter.HumanoidRootPart.CFrame.p
				playercharacter.HumanoidRootPart.CFrame = CFrame.new((_G.rail.CFrame*CFrame.new(xoff,3,zoff)).p)*rot
				playercharacter.HumanoidRootPart.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(pathx, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * pathsp
				bodyvelocity.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(pathx, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * pathsp
			end
		end
	end
end

function bindPart(obj)
	obj.Touched:connect(function(part)
		if tick()-jumpt > 1 then
			if part.Name == "Rail" and part:IsDescendantOf(workspace:WaitForChild("Objects")) then
				rails(part)
			elseif part.Name == "Pathlock" and part:IsDescendantOf(workspace:WaitForChild("Objects")) then
				paths(part)
			end
		end
	end)
end

function characteradded(playercharacter)
	repeat wait() until playercharacter.Parent ~= nil
	local hrp = playercharacter:WaitForChild("HumanoidRootPart")
	local leftfoot = playercharacter:WaitForChild("SonicShoes")  --- Change To What part of the rig/Body it will attach to.
	local rightfoot = playercharacter:WaitForChild("SonicShoes") --- Change To What part of the rig/Body it will attach to.
	local humanoid = playercharacter:WaitForChild("Humanoid")
	
	bodyvelocity = Instance.new("BodyVelocity",hrp)
	bodygyro = Instance.new("BodyGyro",hrp)
	bodyvelocity.MaxForce = Vector3.new(0, 0, 0)
	bodygyro.MaxTorque = Vector3.new(0, 0, 0)
	bodygyro.D = 50
	
	GrindSound = script:WaitForChild("Grinding"):clone()
	spark1 = script:WaitForChild("Spark"):clone()
	spark2 = script:WaitForChild("Spark"):clone()
	GrindSound.Parent = hrp
	spark1.Parent = rightfoot
	spark2.Parent = leftfoot
	
	local anim1 = Instance.new("Animation")
	anim1.AnimationId = "rbxassetid://" --- Change the animation id
	local anim2 = Instance.new("Animation")
	anim2.AnimationId = "rbxassetid://" --- Change the animation id
	local anim3 = Instance.new("Animation")
	anim3.AnimationId = "rbxassetid://" --- Change the animation id
	normalslide1 = humanoid:LoadAnimation(anim1)
	fastslide = humanoid:LoadAnimation(anim2)
	running = humanoid:LoadAnimation(anim3)
	speedmulti = 1
	
	playercharacter.Humanoid.Changed:connect(function(change)
		if change == "Jump" and playercharacter.Humanoid.Jump == true and _G.rail ~= nil then
			playercharacter.Humanoid.Jump = false
		end
	end)
	
	playercharacter.ChildAdded:connect(function(part) if part:IsA("BasePart") then bindPart(part) end end)
	for _,part in pairs(playercharacter:GetChildren()) do if part:IsA("BasePart") then bindPart(part) end end
end

player.CharacterAdded:connect(characteradded)
if player.Character then characteradded(player.Character) end

local lt = tick()
runservice:BindToRenderStep("RailGrinding",Enum.RenderPriority.Character.Value,function()
	local dif = (tick()-lt)*60
	lt = tick()
	if _G.rail ~= nil and player.Character then
		local playercharacter = player.Character
		if ((playercharacter.HumanoidRootPart.Position - (_G.rail.CFrame * CFrame.new(pathx, 2.5, -_G.rail.Size.Z / 2 - 2)).p).magnitude < 4 or (playercharacter.HumanoidRootPart.Position - _G.rail.Position).magnitude > _G.rail.Size.Z + 2) or (_G.path == true and player.Character:WaitForChild("Humanoid").MoveDirection.magnitude < .5) then
			patht = tick()
			lastpath = _G.rail
			_G.rail = nil
			_G.path = false
			bodyvelocity.MaxForce = Vector3.new(0, 0, 0)
			local oldgyro = bodygyro.CFrame
			delay(.025,function()
				if bodygyro.CFrame == oldgyro then
				--[[
					local hrp = playercharacter:WaitForChild("HumanoidRootPart")
					local lv = Vector3.new(0,hrp.CFrame.lookVector.Y,0).unit
					local cf = CFrame.new(Vector3.new(),lv)
					delay(.0125,function()
						if bodygyro.CFrame == oldgyro then
							bodygyro.CFrame = cf
							delay(.0125,function()
				--]]
								bodygyro.MaxTorque = Vector3.new(0, 0, 0)
								playercharacter:WaitForChild("Humanoid").PlatformStand = false
								spark1.Enabled = false
								spark2.Enabled = false
								normalslide1:Stop()
								fastslide:Stop()
								running:Stop()
								GrindSound:Stop()
				--[[
							end)
						end
					end)
				--]]
				end
			end)
		else
			if _G.path then
				bodygyro.CFrame = _G.rail.CFrame
				playercharacter.HumanoidRootPart.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(pathx, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * pathsp
				bodyvelocity.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(pathx, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * pathsp
				
				if running.IsPlaying == false then
					running:Play()
				end
			else
				bodygyro.CFrame = _G.rail.CFrame
				playercharacter.HumanoidRootPart.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(0, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * (80*speedmulti)
				bodyvelocity.Velocity = CFrame.new(playercharacter.HumanoidRootPart.Position, _G.rail.CFrame * CFrame.new(0, 3, -_G.rail.Size.Z / 2 - 2).p).lookVector * (80*speedmulti)
				if math.sign(bodyvelocity.Velocity.Y) < 0 and crouching then
					if speedmulti < 2 then
						speedmulti = math.min(speedmulti+((1/60)*dif),2)
					end
				else
					if speedmulti > 1 then
						speedmulti = math.max(speedmulti-((1/60)*dif),1)
					end
				end
				
				if speedmulti > 2 then
					speedmulti = math.min(speedmulti-(speedmulti/32),2)
				end
				
				if spark1.Enabled == false or spark2.Enabled == false then
					spark1.Enabled = true
					spark2.Enabled = true
				end
			end
		end
	end
end)
