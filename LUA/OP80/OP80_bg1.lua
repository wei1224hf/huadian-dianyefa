function BG2CHK_check_inposition(PointA, PointB, AllowedDisError)          
	local ret = 0
	if(nil==PointA) or (nil==PointB) or (nil==AllowedDisError) then
		print("check_in_position: ERROR! Invalid param PointA = "..tostring(PointA).." PointB = "..tostring(PointB).." AllowedDisError = "..tostring(AllowedDisError).." AllowedOriError = "..tostring(AllowedOriError))
	end
	if math.abs(PointA.robax.rax_1 -PointB.robax.rax_1) < AllowedDisError and math.abs(PointA.robax.rax_2 -PointB.robax.rax_2) < AllowedDisError and math.abs(PointA.robax.rax_3 -PointB.robax.rax_3)< AllowedDisError  and math.abs(PointA.robax.rax_4 -PointB.robax.rax_4)< AllowedDisError and 
	math.abs(PointA.robax.rax_5 -PointB.robax.rax_5)< AllowedDisError and math.abs(PointA.robax.rax_6 -PointB.robax.rax_6)< AllowedDisError and math.abs(PointA.extax.eax_1 -PointB.extax.eax_1)< AllowedDisError then
		ret = 1	
	end
	return ret

end

SetDO("bg1_ready",1)
while (1) do			
	pose_now = GetJointTarget(0,tool0,wobj0)
	if  1 == BG2CHK_check_inposition(pose_now,K10,2) then 
		SetDO("Home",1)
	elseif 1 == BG2CHK_check_inposition(pose_now,K10_1,2) then 
		SetDO("Home",1)
	elseif 1 == BG2CHK_check_inposition(pose_now,K10_2,2) then 
		SetDO("Home",1)
	elseif 1 == BG2CHK_check_inposition(pose_now,K10_3,2) then 
		SetDO("Home",1)
	elseif 1 == BG2CHK_check_inposition(pose_now,K10_4,2) then 
		SetDO("Home",1)
	elseif 1 == BG2CHK_check_inposition(pose_now,K10_5,2) then 
		SetDO("Home",1)
	else
		SetDO("Home",0)
	end
	Sleep(500)
end	

local function GLOBALDATA_DEFINE()
JOINTTARGET("K10",{79.002,26.432,59.608,7.491,-12.334,68.021,0.000},{570.266,490.000,-69.783,0.000,0.000,0.000,0.000})
JOINTTARGET("K10_1",{79.002,26.432,59.608,7.491,-12.334,68.021,0.000},{570.266,490.000,-69.783,0.000,0.000,0.000,0.000})
JOINTTARGET("K10_2",{79.002,26.432,59.608,7.491,-12.334,68.021,0.000},{570.266,361.000,-69.783,0.000,0.000,0.000,0.000})
JOINTTARGET("K10_3",{79.002,26.432,59.608,7.491,-12.334,68.021,0.000},{570.266,232.000,-69.783,0.000,0.000,0.000,0.000})
JOINTTARGET("K10_4",{79.002,26.432,59.608,7.491,-12.334,68.021,0.000},{570.266,103.000,-69.783,0.000,0.000,0.000,0.000})
JOINTTARGET("K10_5",{79.002,26.432,59.608,7.491,-12.334,68.021,0.000},{570.266,-26.000,-69.783,0.000,0.000,0.000,0.000})
end
print("The end!") 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
local function GLOBALDATA_DEFINE()
LOADDATA("load2",2.00,{0.00,0.00,100.00},{1.000000,0.000000,0.000000,0.000000},0.00,0.00,0.00,0.00,0.00,0.01)
SPEEDDATA("SpdUser",200.000,50.000,200.000,50.000)
JOINTTARGET("Home1",{89.999,-85.001,-0.001,-8.001,-2.001,-79.999,0.000},{50.062,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K10",{-86.402,137.625,-1.450,85.246,64.139,-42.594,0.000},{176.249,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{-86.402,137.625,-1.453,85.246,64.139,-42.594,0.000},{176.249,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("VisionPos",{0.000,1.000,0.000,0.000,1.000,0.000,0.000},{100.000,0.000,0.000,0.000,0.000,0.000,0.000})
STRINGDATA("received","")
STRINGDATA("send","")
end
print("The end!")