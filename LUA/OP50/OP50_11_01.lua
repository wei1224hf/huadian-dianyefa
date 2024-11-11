require "offsset"
require "SocketApi"
local socketNameL = "sockL"
local retValL = false
local receivedDataL = nil
local ng_num = 0
--字符串分割
function split(str, split_char)      
    local sub_str_tab = {}
    while true do          
        local pos = string.find(str, split_char) 
        if not pos then              
            table.insert(sub_str_tab,str)
            break
        end  
        local sub_str = string.sub(str, 1, pos - 1)              
        table.insert(sub_str_tab,sub_str)
        str = string.sub(str, pos + 1, string.len(str))
    end      
    return sub_str_tab
end

--视觉SocketTCPIP通讯
function ROB_SocketConnect()                              									
	for i=1,5,1 do
		retValL = SocketConnect(socketNameL,"192.168.105.231",3333,2000)
		if retValL == 1 then
			TPWrite(string.format("Socket connect successfully, server name: %s.", socketNameL))
			break
		else
			TPWrite(string.format("Socket connect failed, server name: %s.", socketNameL))
			Sleep(100)
		end
	end
end

--左侧视觉定位
function LeftVisionPosition()
	retValL = SocketSend(socketNameL, "000025#0111@0009&0004,0,0;0000#", 2000)  --触发拍照
	if retValL ~= 1 then
		TPWrite(string.format("Send failed: %d.", retValL))
		return  --终止语句
	end
	
	retValL, receivedDataL = SocketReceive(socketNameL, 0, 30000)  --机器人接收数据
	if retValL ~= 1 then
		TPWrite(string.format("Received failed: %d.", retValL))
		return
	end
	--TPWrite("Received data: " .. receivedDataL)
	list_str = split(receivedDataL, ",") --di 1 ci yi yi , 分割
end

--右侧视觉定位
function ReftVisionPosition()
	retValL = SocketSend(socketNameL, "000025#0111@0009&0004,1,0;0000#", 2000)  --触发拍照
	if retValL ~= 1 then
		TPWrite(string.format("Send failed: %d.", retValL))
		return  --终止语句
	end	
	retValL, receivedDataL = SocketReceive(socketNameL, 0, 30000)  --机器人接收数据
	if retValL ~= 1 then
		TPWrite(string.format("Received failed: %d.", retValL))
		return
	end
	--TPWrite("Received data: " .. receivedDataL)
	list_str = split(receivedDataL, ",") --di 1 ci yi yi , 分割
end

function IO_check_ON(DO_set,Get_DI,code)
	for i=1,3,1 do
		SetDO(DO_set,1)
		WaitDI(Get_DI,1,4000,true)
		if GetDI(Get_DI) == 1 then
			break		
		else
			SetDO(DO_set,0)				
		end
	end	
	if GetDI(Get_DI) == 0 then
		SetAO("Error_code",code)
		SetDO("alarm_bee",1)
		SetDO("alarm_red",1)
		Stop()
	end		
end	

function IO_check_OFF(DO_set,Get_DI,code)
	for i=1,3,1 do
		SetDO(DO_set,0)
		WaitDI(Get_DI,1,4000,true)
		if GetDI(Get_DI) == 1 then
			break		
		else
			SetDO(DO_set,1)				
		end
	end	
	if GetDI(Get_DI) == 0 then
		SetAO("Error_code",code)
		SetDO("alarm_bee",1)
		SetDO("alarm_red",1)
		Stop()
	end		
end

--信号复位
function Init()
		SetDO("screw_right_reset",1)
		SetDO("screw_left_reset",1)
		SetDO("L_guangyuan",1)
		SetDO("R_guangyuan",1)
		SetDO("DO_loader_gripper_jiajin",0)
		SetDO("DO_GANTRY_LEFT_xia",0)
		SetDO("DO_GANTRY_RIGHT_xia",0)
		SetDO("screw_right_run",0)
		SetDO("screw_left_run",0)
		SetDO("alarm_bee",0)
		SetDO("alarm_red",0)
		SetDO("work_over",0)
		SetAO("Error_code",0)
		SetDO("alarm_green",1)
		Sleep(1000)
		SetDO("screw_right_reset",0)
		SetDO("screw_left_reset",0)
		SetAO("response",0)
end

function L_daluosi()
	--SetDO("screw_left_reset",1)
	SetDO("screw_left_run",1)	
	Sleep(500)
	SetDO("screw_left_reset",0)
	Sleep(1500)
	SetDO("DO_GANTRY_LEFT_xia",1)
	while (1) do
		if GetAI("screw_left_status") == 1 then
			Sleep(500)
			SetDO("screw_left_run",0)
			break
		elseif GetAI("screw_left_status") == 3 then
			SetDO("screw_left_run",0)
			SetDO("screw_left_reset",1)
			Sleep(2000)
			SetDO("screw_left_reset",0)
			for i=1,3,1 do
				L_daluosi()
			end
			break
		end
	end	
	if GetAI("AI1") >= 100 then
		ng_num = 1
	end
	Sleep(1000)
	IO_check_OFF("DO_GANTRY_LEFT_xia","GANTRY_LEFT_rod_shang",1)
end

function R_daluosi()
	--SetDO("screw_right_reset",1)
	SetDO("screw_right_run",1)		
	Sleep(500)
	SetDO("screw_right_reset",0)
	Sleep(1500)
	SetDO("DO_GANTRY_RIGHT_xia",1)
	while (1) do
		if GetAI("screw_right_status") == 1 then
			Sleep(500)
			SetDO("screw_right_run",0)
			break
		elseif GetAI("screw_left_status") == 3 then
			SetDO("screw_right_run",0)
			SetDO("screw_right_reset",1)
			Sleep(2000)
			SetDO("screw_right_reset",0)
			for i=1,3,1 do
				L_daluosi()
			end
			break			
		end
	end	
	if GetAI("AI2") >= 1730 then
		ng_num = 1
	end
	Sleep(1000)
	IO_check_OFF("DO_GANTRY_RIGHT_xia","GANTRY_RIGHT_rod_shang",2)
end

function work_K_big_1()
	MoveAbsJ(K_big_1,Sp_max,fine,tool0,wobj0,load0)
	J_rax5 = 0
	gongxu = 2
	for i=1,2,1 do
		SetAO("response",gongxu)
		MoveAbsJ(JointOffs(K_big_1,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		MoveAbsJ(JointOffs(K_big_1,0,0,0,30,J_rax5,0,0),Sp_min,fine,tool0,wobj0,load0)
		Sleep(500)
		R_daluosi()
		MoveAbsJ(JointOffs(K_big_1,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		J_rax5 = J_rax5 + 49
		gongxu = gongxu + 1
	end
end

function work_K_big_2()
	MoveAbsJ(K_big_2,Sp_max,fine,tool0,wobj0,load0)
	J_rax5 = 0
	gongxu = 4
	for i=1,3,1 do
		SetAO("response",gongxu)
		MoveAbsJ(JointOffs(K_big_2,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		MoveAbsJ(JointOffs(K_big_2,0,0,0,30,J_rax5,0,0),Sp_min,fine,tool0,wobj0,load0)
		Sleep(500)
		R_daluosi()
		MoveAbsJ(JointOffs(K_big_2,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		J_rax5 = J_rax5 + 49
		gongxu = gongxu + 1
	end
end

function work_small_1()
	J_rax5 = 0
	gongxu = 7
	MoveAbsJ(K_small_1,Sp_max,fine,tool0,wobj0,load0)
	for i=1,7,1 do
		SetAO("response",gongxu)
		MoveAbsJ(JointOffs(K_small_1,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		MoveAbsJ(JointOffs(K_small_1,0,60,0,0,J_rax5,0,0),Sp_min,fine,tool0,wobj0,load0)
		Sleep(500)
		L_daluosi()
		MoveAbsJ(JointOffs(K_small_1,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		J_rax5 = J_rax5 - 40
		gongxu = gongxu + 1
	end
end

function work_small_2()
	J_rax5 = 0
	gongxu = 14
	MoveAbsJ(K_small_2,Sp_max,fine,tool0,wobj0,load0)
	for i=1,7,1 do
		SetAO("response",gongxu)
		MoveAbsJ(JointOffs(K_small_2,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		MoveAbsJ(JointOffs(K_small_2,0,60,0,0,J_rax5,0,0),Sp_min,fine,tool0,wobj0,load0)
		Sleep(500)
		L_daluosi()
		MoveAbsJ(JointOffs(K_small_2,0,0,0,0,J_rax5,0,0),Sp_max,fine,tool0,wobj0,load0)
		J_rax5 = J_rax5 - 40
		gongxu = gongxu + 1
	end
end

Init()
ROB_SocketConnect() 
while(1)do
	MoveAbsJ(OP50_Home,Sp_max,fine,tool0,wobj0,load0)
	SetAO("response",0)
	if GetAI("request") == 50 and  GetDI("loader_placed") == 1 then
	    ng_num = 0
		SetDO("work_over",0)
		SetDO("DO_loader_gripper_jiajin",1)
		--拍照位
		--SetDO("R_guangyuan",1)
		MoveAbsJ(R_paizhao,Sp_max,fine,tool0,wobj0,load0)
		SetAO("response",1)  --视觉拍照
		Sleep(200)
		ReftVisionPosition()
		R_rax_5 = tonumber(list_str[3])
		--TPWrite(rax_5)
		--SetDO("R_guangyuan",0)
		Sleep(1000)
		K_big_1.robax.rax_5 = K_big_1.robax.rax_5 - R_rax_5
		K_big_2.robax.rax_5 = K_big_2.robax.rax_5 - R_rax_5
		K_small_1.robax.rax_5 = K_small_1.robax.rax_5 - R_rax_5
		K_small_2.robax.rax_5 = K_small_2.robax.rax_5 - R_rax_5
		--TPWrite(K_big_1)
		work_K_big_1()
		work_K_big_2()
		work_small_1()
		work_small_2()
		MoveAbsJ(OP50_Home,Sp_max,fine,tool0,wobj0,load0)
		if ng_num == 1 then
			SetAO("Error_code",4)
			--Stop()
		end
		SetDO("work_over",1)
		SetDO("DO_loader_gripper_jiajin",0)
	end
	
end

local function GLOBALDATA_DEFINE()
LOADDATA("load2",2.00,{0.00,0.00,100.00},{1.000000,0.000000,0.000000,0.000000},0.00,0.00,0.00,0.00,0.00,0.01)
SPEEDDATA("Sp_max",800.000,50.000,500.000,200.000)
SPEEDDATA("Sp_min",200.000,50.000,100.000,100.000)
SPEEDDATA("SpdUser",200.000,50.000,200.000,50.000)
JOINTTARGET("Home1",{89.999,-85.001,-0.001,-8.001,-2.001,-79.999,0.000},{50.062,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K10",{-86.402,137.625,-1.450,85.246,64.139,-42.594,0.000},{176.249,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{-86.402,137.625,-1.453,85.246,64.139,-42.594,0.000},{176.249,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_big_1",{10.000,10.000,396.120,110.616,501.870,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_big_2",{10.000,10.000,441.010,110.155,463.190,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_small_1",{392.064,110.094,10.003,10.014,436.140,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_small_2",{437.335,110.026,10.000,10.000,446.36,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("L_paizhao",{359.464,74.724,10.000,10.000,455.149,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("OP50_Home",{10.000,10.000,10.000,10.000,470.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("R_paizhao",{10.000,10.000,366.789,44.718,406.468,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("VisionPos",{10.000,10.000,10.000,10.000,470.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
STRINGDATA("received","")
STRINGDATA("send","")
end
print("The end!")