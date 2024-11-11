require "SocketApi"
local P_LP1 = MPointArray(P_LP1_1, P_LP1_2, P_LP1_3, P_LP1_4, P_LP1_5, P_LP1_6, P_LP1_7, P_LP1_8, P_LP1_9, P_LP1_10,
	P_LP1_11, P_LP1_12, P_LP1_13, P_LP1_14, P_LP1_15, P_LP1_16, P_LP1_17, P_LP1_18, P_LP1_19, P_LP1_20, P_LP1_21,
	P_LP1_22, P_LP1_23, P_LP1_24, P_LP1_25, P_LP1_26, P_LP1_27, P_LP1_28, P_LP1_29, P_LP1_30)
local P_LP2 = MPointArray(P_LP2_1, P_LP2_2, P_LP2_3, P_LP2_4, P_LP2_5, P_LP2_6, P_LP2_7, P_LP2_8, P_LP2_9, P_LP2_10,
	P_LP2_11, P_LP2_12, P_LP2_13, P_LP2_14, P_LP2_15, P_LP2_16, P_LP2_17, P_LP2_18, P_LP2_19, P_LP2_20, P_LP2_21,
	P_LP2_22, P_LP2_23, P_LP2_24, P_LP2_25, P_LP2_26, P_LP2_27, P_LP2_28, P_LP2_29, P_LP2_30)
local P_LP3 = MPointArray(P_LP3_1, P_LP3_2, P_LP3_3, P_LP3_4, P_LP3_5, P_LP3_6, P_LP3_7, P_LP3_8, P_LP3_9, P_LP3_10,
	P_LP3_11, P_LP3_12, P_LP3_13, P_LP3_14, P_LP3_15, P_LP3_16, P_LP3_17, P_LP3_18, P_LP3_19, P_LP3_20)
local P_LP4 = MPointArray(P_LP4_1, P_LP4_2, P_LP4_3, P_LP4_4, P_LP4_5, P_LP4_6, P_LP4_7, P_LP4_8, P_LP4_9, P_LP4_10,
	P_LP4_11, P_LP4_12, P_LP4_13, P_LP4_14, P_LP4_15, P_LP4_16, P_LP4_17, P_LP4_18, P_LP4_19, P_LP4_20)
local P_LP5 = MPointArray(P_LP5_1, P_LP5_2, P_LP5_3, P_LP5_4, P_LP5_5, P_LP5_6, P_LP5_7, P_LP5_8, P_LP5_9, P_LP5_10,
	P_LP5_11, P_LP5_12, P_LP5_13, P_LP5_14, P_LP5_15, P_LP5_16, P_LP5_17, P_LP5_18, P_LP5_19, P_LP5_20)
local P_LP6 = MPointArray(P_LP6_1, P_LP6_2, P_LP6_3, P_LP6_4, P_LP6_5, P_LP6_6, P_LP6_7, P_LP6_8, P_LP6_9, P_LP6_10,
	P_LP6_11, P_LP6_12, P_LP6_13, P_LP6_14, P_LP6_15, P_LP6_16, P_LP6_17, P_LP6_18, P_LP6_19, P_LP6_20)
local P_JC2 = MPointArray(P_JC2_1, P_JC2_2, P_JC2_3, P_JC2_4, P_JC2_5)
local P_PY = MPointArray(P_PY_1, P_PY_2, P_PY_3, P_PY_4, P_PY_5)
local P_ZhuangPei = MPointArray(P_ZhuangPei_1, P_ZhuangPei_2, P_ZhuangPei_3, P_ZhuangPei_4, P_ZhuangPei_5, P_ZhuangPei_6,
	P_ZhuangPei_7, P_ZhuangPei_8, P_ZhuangPei_9, P_ZhuangPei_10, P_ZhuangPei_11, P_ZhuangPei_12, P_ZhuangPei_13,
	P_ZhuangPei_14, P_ZhuangPei_15, P_ZhuangPei_16, P_ZhuangPei_17, P_ZhuangPei_18, P_ZhuangPei_19, P_ZhuangPei_20,
	P_ZhuangPei_21, P_ZhuangPei_22, P_ZhuangPei_23, P_ZhuangPei_24, P_ZhuangPei_25)

local socketName = "sock1"
local retVal = false
local receivedData = nil
local SJ1_str = nil
local SJ2_str = nil
local SJ3_str = nil
local SJ4_str = nil
local SJ5_str = nil
local SJ6_str = nil
local SJ7_str = nil
local SJ8_str = nil
local SJ9_str = nil
local connBroken = true

local JL_LP1 = {}
local JL_LP2 = {}
local JL_LP3 = {}
local JL_LP4 = {}
local JL_LP5 = {}
local JL_LP6 = {}

local JianCe1_JieGuo = nil
local JianCe2_JieGuo = nil


function split(str, split_char)
	local sub_str_tab = {}

	while true do
		local pos = string.find(str, split_char)
		if not pos then
			table.insert(sub_str_tab, str)
			break
		end
		local sub_str = string.sub(str, 1, pos - 1)
		table.insert(sub_str_tab, sub_str)
		str = string.sub(str, pos + 1, string.len(str))
	end
	return sub_str_tab
end

function Vision_Connect() --视觉连接
	while connBroken == true do
		SJ1_str = nil
		SJ2_str = nil
		SJ3_str = nil
		SJ4_str = nil
		SJ5_str = nil
		SJ6_str = nil
		SJ7_str = nil
		SJ8_str = nil
		SJ9_str = nil
		retVal = SocketConnect(socketName, "192.168.110.60", 3333, 5000)
		if retVal == 1 then
			connBroken = false
			TPWrite(string.format("Socket connect successfully, server name: %s.", socketName))
		else
			TPWrite(string.format("Socket connect failed, server name: %s.", socketName))
			connBroken = true
			SocketDisconnect(socketName)
			Sleep(1000)
		end
	end
end

function ChuFa_LP1()
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD1, Vmax, fine, tool0, wobj0, load0)
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	Vision_Connect()
	retVal = SocketSend(socketName, "000025#0111@0009&0004,0,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ1_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	SJ1_str = split(receivedData, ",")
	JL_LP1 = {}
	for i = 3, #SJ1_str do
		if tonumber(SJ1_str[i]) == 1 then
			JL_LP1[i - 2] = 1
		end
	end
	--物料计数
	JL_LP1_Count = 0
	for i = 1, #SJ1_str - 2 do
		if JL_LP1[i] == 1 then
			JL_LP1_Count = JL_LP1_Count + 1
		end
	end
	TPWrite("JL_LP1_Count=" .. JL_LP1_Count)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
end

function ChuFa_LP2()
	MoveAbsJ(K_JL_CCD2, Vmax, fine, tool0, wobj0, load0)
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	Vision_Connect()
	retVal = SocketSend(socketName, "000025#0111@0009&0004,0,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ2_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	SJ2_str = split(receivedData, ",")
	JL_LP2 = {}
	for i = 3, #SJ2_str do
		if tonumber(SJ2_str[i]) == 1 then
			JL_LP2[i - 2] = 1
		end
	end
	--物料计数
	JL_LP2_Count = 0
	for i = 1, #SJ2_str - 2 do
		if JL_LP2[i] == 1 then
			JL_LP2_Count = JL_LP2_Count + 1
		end
	end
	TPWrite("JL_LP2_Count=" .. JL_LP2_Count)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
end

function ChuFa_LP3()
	MoveAbsJ(K_JL_CCD3, Vmax, fine, tool0, wobj0, load0)
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	Vision_Connect()
	retVal = SocketSend(socketName, "000025#0111@0009&0004,1,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ3_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	SJ3_str = split(receivedData, ",")
	JL_LP3 = {}
	for i = 3, #SJ3_str do
		if tonumber(SJ3_str[i]) == 1 then
			JL_LP3[i - 2] = 1
		end
	end
	--物料计数
	JL_LP3_Count = 0
	for i = 1, #SJ3_str - 2 do
		if JL_LP3[i] == 1 then
			JL_LP3_Count = JL_LP3_Count + 1
		end
	end
	TPWrite("JL_LP3_Count=" .. JL_LP3_Count)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
end

function ChuFa_LP4()
	MoveAbsJ(K_JL_CCD4, Vmax, fine, tool0, wobj0, load0)
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	Vision_Connect()
	retVal = SocketSend(socketName, "000025#0111@0009&0004,1,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ4_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	SJ4_str = split(receivedData, ",")
	JL_LP4 = {}
	for i = 3, #SJ4_str do
		if tonumber(SJ4_str[i]) == 1 then
			JL_LP4[i - 2] = 1
		end
	end
	--物料计数
	JL_LP4_Count = 0
	for i = 1, #SJ4_str - 2 do
		if JL_LP4[i] == 1 then
			JL_LP4_Count = JL_LP4_Count + 1
		end
	end
	TPWrite("JL_LP4_Count=" .. JL_LP4_Count)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
end

function ChuFa_LP5()
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K40, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD6, Vmid, z200, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD5, Vmid, fine, tool0, wobj0, load0)
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	Vision_Connect()
	retVal = SocketSend(socketName, "000025#0111@0009&0004,2,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ5_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	SJ5_str = split(receivedData, ",")
	JL_LP5 = {}
	for i = 3, #SJ5_str do
		if tonumber(SJ5_str[i]) == 1 then
			JL_LP5[i - 2] = 1
		end
	end
	--物料计数
	JL_LP5_Count = 0
	for i = 1, #SJ5_str - 2 do
		if JL_LP5[i] == 1 then
			JL_LP5_Count = JL_LP5_Count + 1
		end
	end
	TPWrite("JL_LP5_Count=" .. JL_LP5_Count)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
	MoveAbsJ(K_JL_CCD6, Vmid, z200, tool1, wobj0, load10)
	MoveAbsJ(K40, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
end

function ChuFa_LP6()
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K40, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD6, Vmid, fine, tool0, wobj0, load0)
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	Vision_Connect()
	retVal = SocketSend(socketName, "000025#0111@0009&0004,2,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ6_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	SJ6_str = split(receivedData, ",")
	JL_LP6 = {}
	for i = 3, #SJ6_str do
		if tonumber(SJ6_str[i]) == 1 then
			JL_LP6[i - 2] = 1
		end
	end
	--物料计数
	JL_LP6_Count = 0
	for i = 1, #SJ6_str - 2 do
		if JL_LP6[i] == 1 then
			JL_LP6_Count = JL_LP6_Count + 1
		end
	end
	TPWrite("JL_LP6_Count=" .. JL_LP6_Count)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
	MoveAbsJ(K40, Vmax, z200, tool1, wobj0, load10)
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
end

function ChuFa_JianCe1()
	Vision_Connect()
	SetDO("DO_ZDP_CCD_GuangYuan", 1)
	Sleep(500)
	if GongXu.num >= 12 and GongXu.num <= 25 then --M10
		retVal = SocketSend(socketName, "000025#0111@0009&0004,6,0;0000#", 2000)
	else
		retVal = SocketSend(socketName, "000025#0111@0009&0004,4,0;0000#", 2000)
	end
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ7_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	TPWrite("Received data: " .. receivedData)
	SJ7_str = split(receivedData, ",")
	TPWrite(SJ7_str[3])
	SetDO("DO_ZDP_CCD_GuangYuan", 0)
	return tonumber(SJ7_str[3])
end

function ChuFa_JianCe2()
	Vision_Connect()
	SetDO("DO_PY_CCD_GuangYuan", 1)
	Sleep(500)
	if GongXu.num <= 4 then
		retVal = SocketSend(socketName, "000025#0111@0009&0004,7,0;0000#", 2000)
	elseif GongXu.num >= 6 and GongXu.num <= 9 then --M18
		retVal = SocketSend(socketName, "000025#0111@0009&0004,3,0;0000#", 2000)
	else
		TPWrite("gongxucuowu")
		Stop()
	end
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ8_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	TPWrite("Received data: " .. receivedData)
	SJ8_str = split(receivedData, ",")
	TPWrite(SJ8_str[3])
	SetDO("DO_PY_CCD_GuangYuan", 0)
	return tonumber(SJ8_str[3])
end

function ChuFa_FaTiDingWei()
	Vision_Connect()
	SetDO("DO_Rob_CCD_GuangYuan", 1)
	Sleep(500)
	retVal = SocketSend(socketName, "000025#0111@0009&0004,5,0;0000#", 2000)
	if retVal ~= 1 then
		TPWrite(string.format("Send failed: %d.", retVal))
		connBroken = true
		SJ9_str = nil
		return
	end
	retVal, receivedData = SocketReceive(socketName, 0, 30000)
	if retVal ~= 1 then
		TPWrite(string.format("Received failed: %d.", retVal))
		connBroken = true
		return
	end
	TPWrite("Received data: " .. receivedData)
	SJ9_str = split(receivedData, ",")
	SetDO("DO_Rob_CCD_GuangYuan", 0)
	if SJ9_str[3] == "#" then
		return "#"
	else
		if (166.536 - tonumber(SJ9_str[3])) >= -5 and (166.536 - tonumber(SJ9_str[3])) <= 5 then
			return (166.536 - tonumber(SJ9_str[3]))
		else
			ERR(121)
			return "#"
		end
	end
end

function LP_Vis_DingWei()
	--料盘物料检测
	if GetDO("DO_SL1_HongDeng") == 1 or GetDO("DO_SL2_HongDeng") == 1 or GetDO("DO_SL3_HongDeng") == 1 then
		if GetDI("DI_LianJi") == 1 then
			WaitAI("MD_AI_HuanLiaoWanCheng", 1)
			SetDO("DO_SL1_HongDeng", 0)
			SetDO("DO_SL2_HongDeng", 0)
			SetDO("DO_SL3_HongDeng", 0)
			SetDO("DO_LvDeng", 1)
		else
			TPWrite("huanliaoqueren")
			Stop()
		end
	end
	TuoPan_Ready.num = 0
	while (TuoPan_Ready.num ~= 3) do
		TuoPan_Ready.num = 0
		if GetDI("DI_SL1_YouLiao") == 1 and GetDI("DI_SL2_YouLiao") == 1 and GetDI("DI_SL3_YouLiao") == 1 then
			IO_check_ON("DO_SL1_QiGangDing", "DI_SL1_Shang_DaoWei", "DI_SL1_Xia_DaoWei", 1)
			IO_check_ON("DO_SL2_QiGangDing", "DI_SL2_Shang_DaoWei", "DI_SL2_Xia_DaoWei", 1)
			IO_check_ON("DO_SL3_QiGangDing", "DI_SL3_Shang_DaoWei", "DI_SL3_Xia_DaoWei", 1)
		elseif GetDI("DI_SL1_YouLiao") == 0 then
			ERR(1)
			ERR_WaitIO("DI_SL1_YouLiao", 1, 1)
		elseif GetDI("DI_SL2_YouLiao") == 0 then
			ERR(2)
			ERR_WaitIO("DI_SL2_YouLiao", 1, 2)
		elseif GetDI("DI_SL3_YouLiao") == 0 then
			ERR(3)
			ERR_WaitIO("DI_SL3_YouLiao", 1, 3)
		end

		if JL_LP1_Count == 0 and JL_LP2_Count == 0 then
			if GongXu.num <= 4 then
				ChuFa_LP1() --M24
				ChuFa_LP2() --M24
				SetAO("MD_AO_M24", (JL_LP1_Count + JL_LP2_Count))
			end
			if JL_LP1_Count == 0 and JL_LP2_Count == 0 then
				SetAO("MD_AO_M24", (JL_LP1_Count + JL_LP2_Count))
				IO_check_OFF("DO_SL1_QiGangDing", "DI_SL1_Xia_DaoWei", "DI_SL1_Shang_DaoWei", 1)
				SetDO("DO_SL1_LvDeng", 0)
				SetDO("DO_SL1_HongDeng", 1)
				TPWrite("TP1QUELIAO_" .. "LP1" .. JL_LP1_Count .. "LP2" .. JL_LP2_Count)
				if GongXu.num <= 4 then
					ERR(111)
				else
					TuoPan_Ready.num = TuoPan_Ready.num + 1
				end
			else
				SetDO("DO_SL1_HongDeng", 0)
				SetDO("DO_SL1_LvDeng", 1)
				TuoPan_Ready.num = TuoPan_Ready.num + 1
			end
		else
			SetDO("DO_SL1_HongDeng", 0)
			SetDO("DO_SL1_LvDeng", 1)
			TuoPan_Ready.num = TuoPan_Ready.num + 1
		end



		if JL_LP3_Count == 0 or JL_LP4_Count == 0 then
			if JL_LP3_Count == 0 and GongXu.num <= 5 then
				ChuFa_LP3() --滤芯
				SetAO("MD_AO_LvXin", (JL_LP3_Count))
			end
			if JL_LP4_Count == 0 and GongXu.num <= 10 then
				ChuFa_LP4() --单向阀1
				SetAO("MD_AO_DanXiangFa1", (JL_LP4_Count))
			end

			if JL_LP3_Count == 0 or JL_LP4_Count == 0 then
				if JL_LP3_Count == 0 and GongXu.num <= 5 then
					IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
					SetDO("DO_SL2_LvDeng", 0)
					SetDO("DO_SL2_HongDeng", 1)
					TPWrite("TP2QueLiao_" .. "LP3" .. JL_LP3_Count .. "LP4" .. JL_LP4_Count)
					ERR(112)
				elseif JL_LP4_Count == 0 and GongXu.num <= 10 then
					IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
					SetDO("DO_SL2_LvDeng", 0)
					SetDO("DO_SL2_HongDeng", 1)
					TPWrite("TP2QueLiao_" .. "LP3" .. JL_LP3_Count .. "LP4" .. JL_LP4_Count)
					ERR(112)
				else
					TuoPan_Ready.num = TuoPan_Ready.num + 1
				end
			else
				SetDO("DO_SL2_HongDeng", 0)
				SetDO("DO_SL2_LvDeng", 1)
				TuoPan_Ready.num = TuoPan_Ready.num + 1
			end
		else
			SetDO("DO_SL2_HongDeng", 0)
			SetDO("DO_SL2_LvDeng", 1)
			TuoPan_Ready.num = TuoPan_Ready.num + 1
		end

		if JL_LP5_Count == 0 or JL_LP6_Count == 0 then
			if JL_LP5_Count == 0 and GongXu.num <= 11 then
				ChuFa_LP5() --单向阀2
				SetAO("MD_AO_DanXiangFa2", (JL_LP5_Count))
			end
			if JL_LP6_Count == 0 and GongXu.num <= 9 then
				ChuFa_LP6() --M18
				SetAO("MD_AO_M18", (JL_LP6_Count))
			end
			if JL_LP5_Count == 0 or JL_LP6_Count == 0 then
				if JL_LP5_Count == 0 and GongXu.num <= 11 then
					IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
					SetDO("DO_SL3_LvDeng", 0)
					SetDO("DO_SL3_HongDeng", 1)
					TPWrite("TP3QueLiao" .. "LP5" .. JL_LP5_Count .. "LP6" .. JL_LP6_Count)
					ERR(113)
				elseif JL_LP6_Count == 0 and GongXu.num <= 9 then
					IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
					SetDO("DO_SL3_LvDeng", 0)
					SetDO("DO_SL3_HongDeng", 1)
					TPWrite("TP3QueLiao" .. "LP5" .. JL_LP5_Count .. "LP6" .. JL_LP6_Count)
					ERR(113)
				else
					TuoPan_Ready.num = TuoPan_Ready.num + 1
				end
			else
				SetDO("DO_SL3_HongDeng", 0)
				SetDO("DO_SL3_LvDeng", 1)
				TuoPan_Ready.num = TuoPan_Ready.num + 1
			end
		else
			SetDO("DO_SL3_HongDeng", 0)
			SetDO("DO_SL3_LvDeng", 1)
			TuoPan_Ready.num = TuoPan_Ready.num + 1
		end

		if TuoPan_Ready.num ~= 3 then
			TPWrite("TuoPan_Ready" .. TuoPan_Ready.num)
		else
			SetDO("DO_HuangDeng", 0)
		end
	end
end

function Gohome()
	while (GetAO("MD_Home") ~= 1) do
		ERR(200)
		Stop()
		while (false) do
			MoveAbsJ(K_home, Vmin, fine, toolsj, wobj0, load10)
		end
	end
	MoveAbsJ(K_home, Vmin, fine, toolsj, wobj0, load10)
end

function Wait_All_Ready()
	TPWrite("MAIN wait ready!")
	WaitDO("VIR_BG1_Ready", 1)
	WaitDO("VIR_BG2_Ready", 1)
	WaitDO("VIR_BG3_Ready", 1)
	--WaitDO("VIR_BG4_Ready",1)
	--WaitDO("VIR_BG5_Ready",1)
	TPWrite("MAIN wait ready done!")
end

function ERR(code)
	SetAO("MD_Error", code)
	SetDO("DO_FengMing", 1)
	SetDO("DO_HongDeng", 1)
	TPWrite("err" .. code)
	Stop()
	SetDO("DO_FengMing", 0)
	SetDO("DO_HongDeng", 0)
	SetDO("DO_LvDeng", 1)
	SetAO("MD_Error", 0)
	Sleep(1000)
end

function QueLiaoERR(code)
	SetAO("MD_Error", code)
	SetDO("DO_FengMing", 1)
	SetDO("DO_HuangDeng", 1)
	SetDO("DO_LvDeng", 0)
	TPWrite("QueLiaoERR" .. code)
	SetAO("MD_Error", 0)
end

function IO_check_ON(DO_set, Get_DI1, Get_DI2, code)
	for i = 1, 3, 1 do
		SetDO(DO_set, 1)
		WaitDI(Get_DI1, 1, 2000, true)
		WaitDI(Get_DI2, 0, 2000, true)
		if GetDI(Get_DI1) == 1 and GetDI(Get_DI2) == 0 then
			break
		else
			Sleep(500)
			SetDO(DO_set, 0)
		end
	end
	if GetDI(Get_DI1) == 0 or GetDI(Get_DI2) == 1 then
		ERR(code)
		while GetDI(Get_DI1) == 0 or GetDI(Get_DI2) == 1 do
			Sleep(2000)
			ERR(code)
		end
	end
end

function IO_check_ON_2(DO_set, Get_DI1, Get_DI2, code)
	for i = 1, 3, 1 do
		SetDO(DO_set, 1)
		WaitDI(Get_DI2, 0, 2000, true)
		Sleep(500)
		if GetDI(Get_DI2) == 0 then
			break
		else
			Sleep(500)
			SetDO(DO_set, 0)
		end
	end
	if GetDI(Get_DI2) == 1 then
		ERR(code)
		while GetDI(Get_DI2) == 0 do
			Sleep(2000)
			ERR(code)
		end
	end
end

function IO_check_OFF(DO_set, Get_DI1, Get_DI2, code)
	for i = 1, 3, 1 do
		SetDO(DO_set, 0)
		WaitDI(Get_DI1, 1, 2000, true)
		WaitDI(Get_DI2, 0, 2000, true)
		if GetDI(Get_DI1) == 1 and GetDI(Get_DI2) == 0 then
			break
		else
			Sleep(500)
			SetDO(DO_set, 1)
		end
	end
	if GetDI(Get_DI1) == 0 or GetDI(Get_DI2) == 1 then
		ERR(code)
		while GetDI(Get_DI1) == 0 or GetDI(Get_DI2) == 1 do
			Sleep(2000)
			ERR(code)
		end
	end
end

function ERR_WaitIO(WaitDI, ZhuangTai, errcode)
	Sleep(5000)
	while (GetDI(WaitDI) ~= ZhuangTai) do
		Sleep(5000)
		ERR(errcode)
		Stop()
	end
end

function ERR_WaitIO2(WaitDI1, ZhuangTai1, WaitDI2, ZhuangTai2, errcode)
	Sleep(5000)
	while (GetDI(WaitDI1) ~= ZhuangTai1 or GetDI(WaitDI2) ~= ZhuangTai2) do
		Sleep(5000)
		ERR(errcode)
		Stop()
	end
end

--

function Init()
	SetDO("VIR_Init_Ready", 0)
	--视觉连接
	connBroken = true
	Vision_Connect()
	--三色灯复位
	SetDO("DO_FengMing", 0)
	SetDO("DO_HongDeng", 0)
	SetDO("DO_HuangDeng", 0)
	SetDO("DO_LvDeng", 0)
	--光源复位
	SetDO("DO_ZDP_CCD_GuangYuan", 0)
	SetDO("DO_Rob_CCD_GuangYuan", 0)
	SetDO("DO_PY_CCD_GuangYuan", 0)
	--上料指示灯复位
	SetDO("DO_SL1_LvDeng", 0)
	SetDO("DO_SL2_LvDeng", 0)
	SetDO("DO_SL3_LvDeng", 0)
	SetDO("DO_SL1_HongDeng", 0)
	SetDO("DO_SL2_HongDeng", 0)
	SetDO("DO_SL3_HongDeng", 0)
	--上料气缸复位
	IO_check_OFF("DO_SL1_QiGangDing", "DI_SL1_Xia_DaoWei", "DI_SL1_Shang_DaoWei", 1)
	IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
	IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
	--振动盘气缸复位
	IO_check_OFF("DO_ZDP_QIGang", "DI_ZDP_SuoHuiDaoWei", "DI_ZDP_ShenChuDaoWei", 4)
	--机器人末端复位
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	IO_check_OFF("DO_Rob_HuBao", "DI_NJQ_HuBaoKaiDaoWei", "DI_NJQ_HuBaoGuanDaoWei", 7)
	IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)

	SetAO("MD_Error", 0)
	SetAO("MD_YunXuQuLiao", 0)
	SetAO("MD_AO_LvXin", 0)
	SetAO("MD_AO_M18", 0)
	SetAO("MD_AO_DanXiangFa2", 0)
	SetAO("MD_AO_DanXiangFa1", 0)
	SetAO("MD_AO_M24", 0)


	SetAO("MD_NJQ_ZhengZhuan", 0)
	SetAO("MD_NJQ_FanZhuan", 0)
	SetAO("MD_NJQ_ZanTing", 0)
	SetAO("MD_NJQ_MoShi", 0)
	Sleep(500)
	SetAO("MD_NJQ_FuWei", 1)
	Sleep(500)
	SetAO("MD_NJQ_FuWei", 0)
	--喷油机构复位
	IO_check_OFF("DO_PY_TuiSong", "DI_PY_SuoHuiDaoWei", "DI_PY_TuiSongDaoWei", 9)
	IO_check_OFF("DO_PY_JiaJin", "DI_PY_SongKaiDaoWei", "DI_PY_JiaJinDaoWei", 10)
	SetDO("DO_PY_ChuLiao", 1)
	Sleep(500)
	SetDO("DO_PY_ChuLiao", 0)
	SetDO("DO_PY_PenWu", 0)
	--滑台复位
	IO_check_OFF("DO_HT_JiaJin", "DI_HT_SongKaiDaoWei", "DI_HT_JiaJinDaoWei", 15)
	SetAO("MD_YunXuQuLiao", 0)
	--批头更换机构复位
	IO_check_OFF("DO_GH_SongKai1", "DI_GH_JiaJinDaoWei1", "DI_GH_SongKaiDaoWei1", 11)
	IO_check_OFF("DO_GH_SongKai2", "DI_GH_JiaJinDaoWei2", "DI_GH_SongKaiDaoWei2", 12)
	IO_check_OFF("DO_GH_SongKai3", "DI_GH_JiaJinDaoWei3", "DI_GH_SongKaiDaoWei3", 13)
	IO_check_OFF("DO_GH_SongKai4", "DI_GH_JiaJinDaoWei4", "DI_GH_SongKaiDaoWei4", 14)
	--判断批头是否到位
	if GetDI("DI_GH_YouLiao1") == 0 then
		SetDO("DO_GH_SongKai1", 1)
		ERR(100)
		ERR_WaitIO("DI_GH_YouLiao1", 1, 100)
	elseif GetDI("DI_GH_YouLiao2") == 0 then
		SetDO("DO_GH_SongKai2", 1)
		ERR(101)
		ERR_WaitIO("DI_GH_YouLiao2", 1, 101)
	elseif GetDI("DI_GH_YouLiao3") == 0 then
		SetDO("DO_GH_SongKai3", 1)
		ERR(102)
		ERR_WaitIO("DI_GH_YouLiao3", 1, 102)
	end
	--视觉参数复位
	JL_LP1 = {}
	JL_LP2 = {}
	JL_LP3 = {}
	JL_LP4 = {}
	JL_LP5 = {}
	JL_LP6 = {}

	JL_LP1_Count = 0
	JL_LP2_Count = 0
	JL_LP3_Count = 0
	JL_LP4_Count = 0
	JL_LP5_Count = 0
	JL_LP6_Count = 0
	--状态工序初始化
	PiTouZhuangTai.num = 0 --批头夹取状态  0_未夹取 1_大批头 2_中 3_小
	WuLiaoZhuangTai.num = 0 --物料夹取状态  0_未夹取 1_M24 2_滤芯 3_M18 4_大单向阀 5_小单向阀 6_M10
	GongXu.num = 1        --工序
	--等待后台启动
	Wait_All_Ready()
	--主程序初始化完成 机器人准备就绪		
	SetDO("DO_LvDeng", 1)
	SetDO("VIR_YunXuFangLiao", 0)
	SetDO("VIR_Init_Ready", 1)
	--node-red 把视觉偏移量从硬盘里读出来写入到 AI , 然后根据AI写入AO
	SetAO("offset_vision",GetAI("offset_vision_AI"))
end

function QuPiTou1()
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	if GetDI("DI_GH_YouLiao1") == 0 or GetDO("DO_GH_SongKai1") == 1 then
		ERR(100)
		ERR_WaitIO("DI_GH_YouLiao1", 1, 100)
	end
	SetAO("MD_NJQ_FuWei", 1)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	SetAO("MD_NJQ_MoShi", 12)
	SetAO("MD_NJQ_ZanTing", 0)

	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	MoveL(Offs(P_GH_1, 0, -200, 0), Vmax, z0, toolsj, wobj0, load10)
	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	SetAO("MD_NJQ_FuWei", 0)
	MoveL(P_GH_1, Vmid, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_ZhengZhuan", 1)
	while (GetAI("MD_NJQ_Zhuangtai") ~= 2) do
		if GetAI("MD_NJQ_Zhuangtai") == 3 then
			TPWrite("njqfankuiyichang")
			Stop()
			SetAO("MD_NJQ_FuWei", 1)
			SetAO("MD_NJQ_ZhengZhuan", 0)
			Sleep(500)
			SetAO("MD_NJQ_FuWei", 0)
			SetAO("MD_NJQ_ZhengZhuan", 1)
			break
		elseif GetAI("MD_NJQ_Zhuangtai") == 1 then
			break
		end
	end
	Sleep(500)
	MoveL(Offs(P_GH_1, 0, 0, -11), vv_2, fine, toolsj, wobj0, load10)
	SetDO("DO_GH_SongKai1", 1)
	MoveL(Offs(P_GH_1, 0, 0, -13), vv_2, fine, toolsj, wobj0, load10)
	--SetDO("DO_GH_SongKai1",0)
	MoveL(Offs(P_GH_1, 0, 0, -15), vv_2, fine, toolsj, wobj0, load10)
	--SetDO("DO_GH_SongKai1",1)
	MoveL(Offs(P_GH_1, 0, 0, -16), vv_2, fine, toolsj, wobj0, load10)
	--SetDO("DO_GH_SongKai1",0)
	MoveL(Offs(P_GH_1, 0, 0, -18), vv_2, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	IO_check_ON("DO_GH_SongKai1", "DI_GH_SongKaiDaoWei1", "DI_GH_JiaJinDaoWei1", 11)
	MoveL(Offs(P_GH_1, 0, 0, -21), vv_2, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_FuWei", 1)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	MoveL(P_GH_1, Vmid, fine, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_1, 0, -200, 0), Vmax, z10, toolsj, wobj0, load10)
	IO_check_ON("DO_Rob_HuBao", "DI_NJQ_HuBaoGuanDaoWei", "DI_NJQ_HuBaoKaiDaoWei", 7)
	Sleep(500)
	MoveAbsJ(K_GH_GuoDu, Vmax, z10, toolsj, wobj0, load0)
	SetAO("MD_NJQ_FuWei", 0)
	PiTouZhuangTai.num = 1
end

function QuPiTou2()
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	if GetDI("DI_GH_YouLiao2") == 0 or GetDO("DO_GH_SongKai2") == 1 then
		ERR(101)
		ERR_WaitIO("DI_GH_YouLiao2", 1, 101)
	end
	SetAO("MD_NJQ_FuWei", 1)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	SetAO("MD_NJQ_MoShi", 12)
	SetAO("MD_NJQ_ZanTing", 0)

	MoveL(Offs(P_GH_2, 0, -200, 0), Vmax, fine, toolsj, wobj0, load10)
	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	SetAO("MD_NJQ_FuWei", 0)
	MoveL(P_GH_2, Vmid, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_ZhengZhuan", 1)
	while (GetAI("MD_NJQ_Zhuangtai") ~= 2) do
		if GetAI("MD_NJQ_Zhuangtai") == 3 then
			TPWrite("njqfankuiyichang")
			Stop()
			SetAO("MD_NJQ_FuWei", 1)
			SetAO("MD_NJQ_ZhengZhuan", 0)
			Sleep(500)
			SetAO("MD_NJQ_FuWei", 0)
			SetAO("MD_NJQ_ZhengZhuan", 1)
			break
		elseif GetAI("MD_NJQ_Zhuangtai") == 1 then
			break
		end
	end
	Sleep(500)
	MoveL(Offs(P_GH_2, 0, 0, -11), vv_2, fine, toolsj, wobj0, load10)
	SetDO("DO_GH_SongKai2", 1)
	MoveL(Offs(P_GH_2, 0, 0, -13), vv_2, fine, toolsj, wobj0, load10)
	--SetDO("DO_GH_SongKai2",0)
	MoveL(Offs(P_GH_2, 0, 0, -15), vv_2, fine, toolsj, wobj0, load10)
	IO_check_ON("DO_GH_SongKai2", "DI_GH_SongKaiDaoWei2", "DI_GH_JiaJinDaoWei2", 12)
	MoveL(Offs(P_GH_2, 0, 0, -18), vv_2, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	MoveL(Offs(P_GH_2, 0, 0, -20), vv_2, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_FuWei", 1)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	MoveL(P_GH_2, Vmid, fine, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_2, 0, -200, 0), Vmax, z10, toolsj, wobj0, load10)
	IO_check_ON("DO_Rob_HuBao", "DI_NJQ_HuBaoGuanDaoWei", "DI_NJQ_HuBaoKaiDaoWei", 7)
	Sleep(500)
	MoveAbsJ(K_GH_GuoDu, Vmax, z10, toolsj, wobj0, load0)
	SetAO("MD_NJQ_FuWei", 0)
	PiTouZhuangTai.num = 2
end

function QuPiTou3()
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	if GetDI("DI_GH_YouLiao3") == 0 or GetDO("DO_GH_SongKai3") == 1 then
		ERR(102)
		ERR_WaitIO("DI_GH_YouLiao3", 1, 102)
	end
	SetAO("MD_NJQ_FuWei", 1)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	SetAO("MD_NJQ_MoShi", 12)
	SetAO("MD_NJQ_ZanTing", 0)

	MoveL(Offs(P_GH_3, 0, -200, 0), Vmax, fine, toolsj, wobj0, load10)
	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	SetAO("MD_NJQ_FuWei", 0)
	MoveL(P_GH_3, Vmid, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_ZhengZhuan", 1)
	while (GetAI("MD_NJQ_Zhuangtai") ~= 2) do
		if GetAI("MD_NJQ_Zhuangtai") == 3 then
			TPWrite("njqfankuiyichang")
			Stop()
			SetAO("MD_NJQ_FuWei", 1)
			SetAO("MD_NJQ_ZhengZhuan", 0)
			Sleep(500)
			SetAO("MD_NJQ_FuWei", 0)
			SetAO("MD_NJQ_ZhengZhuan", 1)
			break
		elseif GetAI("MD_NJQ_Zhuangtai") == 1 then
			break
		end
	end
	Sleep(500)
	MoveL(Offs(P_GH_3, 0, 0, -11), vv_2, fine, toolsj, wobj0, load10)
	SetDO("DO_GH_SongKai3", 1)
	MoveL(Offs(P_GH_3, 0, 0, -13), vv_2, fine, toolsj, wobj0, load10)
	--SetDO("DO_GH_SongKai3",0)
	MoveL(Offs(P_GH_3, 0, 0, -15), vv_2, fine, toolsj, wobj0, load10)
	IO_check_ON("DO_GH_SongKai3", "DI_GH_SongKaiDaoWei3", "DI_GH_JiaJinDaoWei3", 13)
	MoveL(Offs(P_GH_3, 0, 0, -18), vv_2, fine, toolsj, wobj0, load10)
	IO_check_ON("DO_GH_SongKai3", "DI_GH_SongKaiDaoWei3", "DI_GH_JiaJinDaoWei3", 13)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	MoveL(Offs(P_GH_3, 0, 0, -20), vv_2, fine, toolsj, wobj0, load10)
	SetAO("MD_NJQ_FuWei", 1)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	MoveL(P_GH_3, Vmid, fine, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_3, 0, -200, 0), Vmax, z10, toolsj, wobj0, load10)
	IO_check_ON("DO_Rob_HuBao", "DI_NJQ_HuBaoGuanDaoWei", "DI_NJQ_HuBaoKaiDaoWei", 7)
	Sleep(500)
	MoveAbsJ(K_GH_GuoDu, Vmax, z10, toolsj, wobj0, load0)
	SetAO("MD_NJQ_FuWei", 0)
	PiTouZhuangTai.num = 3
end

function FangPiTou1()
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	IO_check_ON("DO_GH_SongKai1", "DI_GH_SongKaiDaoWei1", "DI_GH_JiaJinDaoWei1", 11)
	MoveAbsJ(K_GH_GuoDu, Vmax, z10, toolsj, wobj0, load0)
	--IO_check_OFF("DO_Rob_HuBao","DI_NJQ_HuBaoKaiDaoWei","DI_NJQ_HuBaoGuanDaoWei",7)
	MoveL(Offs(P_GH_1, 0, -200, 0), Vmid, z10, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_1, 0, 0, -10), Vmid, fine, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_1, 0, 0, -20.5), Vmin, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_OFF("DO_GH_SongKai1", "DI_GH_JiaJinDaoWei1", "DI_GH_SongKaiDaoWei1", 11)
	Sleep(500)
	IO_check_OFF("DO_Rob_HuBao", "DI_NJQ_HuBaoKaiDaoWei", "DI_NJQ_HuBaoGuanDaoWei", 7)
	Sleep(500)
	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	Sleep(500)
	--IO_check_OFF("DO_GH_SongKai1","DI_GH_JiaJinDaoWei1","DI_GH_SongKaiDaoWei1",11)
	MoveL(P_GH_1, Vmin, fine, toolsj, wobj0, load10)
	Sleep(1000)
	MoveL(Offs(P_GH_1, 0, -200, 0), Vmid, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	PiTouZhuangTai.num = 0
end

function FangPiTou2()
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	IO_check_ON("DO_GH_SongKai2", "DI_GH_SongKaiDaoWei2", "DI_GH_JiaJinDaoWei2", 12)
	MoveAbsJ(K_GH_GuoDu, Vmax, z10, toolsj, wobj0, load0)
	--IO_check_OFF("DO_Rob_HuBao","DI_NJQ_HuBaoKaiDaoWei","DI_NJQ_HuBaoGuanDaoWei",7)
	MoveL(Offs(P_GH_2, 0, -200, 0), Vmid, z10, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_2, 0, 0, -10), Vmid, fine, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_2, 0, 0, -20.8), Vmin, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_OFF("DO_GH_SongKai2", "DI_GH_JiaJinDaoWei2", "DI_GH_SongKaiDaoWei2", 12)
	Sleep(500)
	IO_check_OFF("DO_Rob_HuBao", "DI_NJQ_HuBaoKaiDaoWei", "DI_NJQ_HuBaoGuanDaoWei", 7)
	Sleep(500)
	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	--Sleep(500)
	--IO_check_OFF("DO_GH_SongKai2","DI_GH_JiaJinDaoWei2","DI_GH_SongKaiDaoWei2",12)
	MoveL(P_GH_2, Vmin, fine, toolsj, wobj0, load10)
	Sleep(1000)
	MoveL(Offs(P_GH_2, 0, -200, 0), Vmid, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	PiTouZhuangTai.num = 0
end

function FangPiTou3()
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
	IO_check_ON("DO_GH_SongKai3", "DI_GH_SongKaiDaoWei3", "DI_GH_JiaJinDaoWei3", 13)
	MoveAbsJ(K_GH_GuoDu, Vmax, z10, toolsj, wobj0, load0)
	--IO_check_OFF("DO_Rob_HuBao","DI_NJQ_HuBaoKaiDaoWei","DI_NJQ_HuBaoGuanDaoWei",7)
	MoveL(Offs(P_GH_3, 0, -200, 0), Vmid, z10, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_3, 0, 0, -10), Vmid, fine, toolsj, wobj0, load10)
	MoveL(Offs(P_GH_3, 0, 0, -21), Vmin, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_OFF("DO_GH_SongKai3", "DI_GH_JiaJinDaoWei3", "DI_GH_SongKaiDaoWei3", 13)
	Sleep(500)
	IO_check_OFF("DO_Rob_HuBao", "DI_NJQ_HuBaoKaiDaoWei", "DI_NJQ_HuBaoGuanDaoWei", 7)
	Sleep(500)
	IO_check_ON("DO_Rob_JieSuo", "DI_NJQ_JieSuoKaiDaoWei", "DI_NJQ_JieSuoGuanDaoWei", 6)
	--IO_check_OFF("DO_GH_SongKai3","DI_GH_JiaJinDaoWei3","DI_GH_SongKaiDaoWei3",13)
	MoveL(P_GH_3, Vmin, fine, toolsj, wobj0, load10)
	Sleep(1000)
	MoveL(Offs(P_GH_3, 0, -200, 0), Vmid, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_OFF("DO_Rob_JieSuo", "DI_NJQ_JieSuoGuanDaoWei", "DI_NJQ_JieSuoKaiDaoWei", 6)
	PiTouZhuangTai.num = 0
end

function PiTouQuFang()
	if GongXu.num <= 9 then
		if PiTouZhuangTai.num == 0 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 0 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 1 then
			QuPiTou1()
		elseif PiTouZhuangTai.num == 1 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then

		elseif PiTouZhuangTai.num == 2 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then
			if GetDI("DI_GH_YouLiao2") == 0 then
				FangPiTou2()
				QuPiTou1()
			else
				TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
				ERR(101)
				ERR_WaitIO("DI_GH_YouLiao2", 0, 101)
			end
		elseif PiTouZhuangTai.num == 3 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then
			if GetDI("DI_GH_YouLiao3") == 0 then
				FangPiTou3()
				QuPiTou1()
			else
				TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
				ERR(102)
				ERR_WaitIO("DI_GH_YouLiao3", 0, 102)
			end
		else
			TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
			Stop()
		end
	elseif GongXu.num == 10 then
		if PiTouZhuangTai.num == 0 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 0 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 1 then
			QuPiTou2()
		elseif PiTouZhuangTai.num == 1 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then
			if GetDI("DI_GH_YouLiao1") == 0 then
				FangPiTou1()
				QuPiTou2()
			else
				TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
				ERR(100)
				ERR_WaitIO("DI_GH_YouLiao1", 0, 100)
			end
		elseif PiTouZhuangTai.num == 2 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then

		elseif PiTouZhuangTai.num == 3 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then
			if GetDI("DI_GH_YouLiao3") == 0 then
				FangPiTou3()
				QuPiTou2()
			else
				TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
				ERR(102)
				ERR_WaitIO("DI_GH_YouLiao3", 0, 102)
			end
		else
			TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
			Stop()
		end
	elseif GongXu.num >= 11 and GongXu.num < 26 then
		if PiTouZhuangTai.num == 0 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 0 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 1 then
			QuPiTou3()
		elseif PiTouZhuangTai.num == 1 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then
			if GetDI("DI_GH_YouLiao1") == 0 then
				FangPiTou1()
				QuPiTou3()
			else
				TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
				ERR(100)
				ERR_WaitIO("DI_GH_YouLiao1", 0, 100)
			end
		elseif PiTouZhuangTai.num == 2 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then
			if GetDI("DI_GH_YouLiao2") == 0 then
				FangPiTou2()
				QuPiTou3()
			else
				TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
				ERR(101)
				ERR_WaitIO("DI_GH_YouLiao2", 0, 101)
			end
		elseif PiTouZhuangTai.num == 3 and GetDI("DI_NJQ_HuBaoGuanDaoWei") == 1 and GetDI("DI_NJQ_HuBaoKaiDaoWei") == 0 then

		else
			TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
			Stop()
		end
	elseif GongXu.num == 26 then
		if GetDI("DI_GH_YouLiao3") == 0 then
			FangPiTou3()
		else
			TPWrite("pitouxinghaocuowu_" .. PiTouZhuangTai.num)
			ERR(102)
			ERR_WaitIO("DI_GH_YouLiao3", 0, 102)
		end
	else
		TPWrite("gongxucuowu_" .. GongXu.num)
		Stop()
	end
end

function QuLiao_M24()
	if JL_LP1_Count > 0 then
		for i = 1, 30 do
			if JL_LP1[i] == 1 then
				MoveAbsJ(K_LP12_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				MoveL(Offs(P_LP1[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveL(P_LP1[i], Vmid, fine, toolsj, wobj0, load10)
				Sleep(500)
				IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
				WuLiaoZhuangTai.num = 1
				Sleep(200)
				MoveL(Offs(P_LP1[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveAbsJ(K_LP12_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				JL_LP1[i] = 0
				JL_LP1_Count = JL_LP1_Count - 1
				break
			end
		end
	elseif JL_LP2_Count > 0 then
		for i = 1, 30 do
			if JL_LP2[i] == 1 then
				MoveAbsJ(K_LP12_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				MoveL(Offs(P_LP2[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveL(P_LP2[i], Vmid, fine, toolsj, wobj0, load10)
				Sleep(500)
				IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
				WuLiaoZhuangTai.num = 1
				Sleep(200)
				MoveL(Offs(P_LP2[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveAbsJ(K_LP12_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				JL_LP2[i] = 0
				JL_LP2_Count = JL_LP2_Count - 1
				break
			end
		end
	else
		TPWrite("M24queliao")
		Stop()
	end
	if JL_LP1_Count == 0 and JL_LP2_Count == 0 then
		SetAO("MD_AO_M24", (JL_LP1_Count + JL_LP2_Count))
		IO_check_OFF("DO_SL1_QiGangDing", "DI_SL1_Xia_DaoWei", "DI_SL1_Shang_DaoWei", 1)
		SetDO("DO_SL1_LvDeng", 0)
		SetDO("DO_SL1_HongDeng", 1)
		QueLiaoERR(111)
	else
		SetDO("DO_SL1_HongDeng", 0)
		SetDO("DO_SL1_LvDeng", 1)
	end
end

function QuLiao_LvXin()
	if JL_LP3_Count > 0 then
		for i = 1, 20 do
			if JL_LP3[i] == 1 then
				MoveAbsJ(K_LP34_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				MoveL(Offs(P_LP3[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveL(P_LP3[i], Vmid, fine, toolsj, wobj0, load10)
				Sleep(500)
				IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
				WuLiaoZhuangTai.num = 2
				Sleep(200)
				MoveL(Offs(P_LP3[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveAbsJ(K_LP34_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				JL_LP3[i] = 0
				JL_LP3_Count = JL_LP3_Count - 1
				break
			end
		end
	else
		TPWrite("LvXinqueliao")
		Stop()
	end
	if JL_LP3_Count == 0 or JL_LP4_Count == 0 then
		if JL_LP3_Count == 0 and GongXu.num <= 5 then
			IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
			SetDO("DO_SL2_LvDeng", 0)
			SetDO("DO_SL2_HongDeng", 1)
			TPWrite("TP2QueLiao_" .. "LP3" .. JL_LP3_Count .. "LP4" .. JL_LP4_Count)
			QueLiaoERR(112)
		elseif JL_LP4_Count == 0 and GongXu.num <= 10 then
			IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
			SetDO("DO_SL2_LvDeng", 0)
			SetDO("DO_SL2_HongDeng", 1)
			TPWrite("TP2QueLiao_" .. "LP3" .. JL_LP3_Count .. "LP4" .. JL_LP4_Count)
			QueLiaoERR(112)
		else
			SetDO("DO_SL2_HongDeng", 0)
			SetDO("DO_SL2_LvDeng", 1)
		end
	else
		SetDO("DO_SL2_HongDeng", 0)
		SetDO("DO_SL2_LvDeng", 1)
	end
end

function QuLiao_DanXiangFa1()
	SetDO("DO_PY_TuiSong", 1)
	MoveAbsJ(K_LP34_GuoDu, Vmax, z200, toolsj, wobj0, load10)
	WaitDI("DI_PY_SuoHuiDaoWei", 0, 6000, true)
	WaitDI("DI_PY_TuiSongDaoWei", 1, 6000, true)
	if GetDI("DI_PY_SuoHuiDaoWei") == 1 or GetDI("DI_PY_TuiSongDaoWei") == 0 then
		ERR(9)
		ERR_WaitIO2("DI_PY_TuiSongDaoWei", 1, "DI_PY_SuoHuiDaoWei", 0, 9)
	end

	if JL_LP4_Count > 0 then
		for i = 1, 20 do
			if JL_LP4[i] == 1 then
				MoveL(Offs(P_LP4[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveL(P_LP4[i], Vmid, fine, toolsj, wobj0, load10)
				Sleep(500)
				IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
				WuLiaoZhuangTai.num = 3
				Sleep(200)
				MoveL(Offs(P_LP4[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveAbsJ(K_LP34_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				JL_LP4[i] = 0
				JL_LP4_Count = JL_LP4_Count - 1
				break
			end
		end
	else
		TPWrite("DanXiangFa1queliao")
		Stop()
	end
	if JL_LP3_Count == 0 or JL_LP4_Count == 0 then
		if JL_LP3_Count == 0 and GongXu.num <= 5 then
			IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
			SetDO("DO_SL2_LvDeng", 0)
			SetDO("DO_SL2_HongDeng", 1)
			TPWrite("TP2QueLiao_" .. "LP3" .. JL_LP3_Count .. "LP4" .. JL_LP4_Count)
			QueLiaoERR(112)
		elseif JL_LP4_Count == 0 and GongXu.num <= 10 then
			IO_check_OFF("DO_SL2_QiGangDing", "DI_SL2_Xia_DaoWei", "DI_SL2_Shang_DaoWei", 2)
			SetDO("DO_SL2_LvDeng", 0)
			SetDO("DO_SL2_HongDeng", 1)
			TPWrite("TP2QueLiao_" .. "LP3" .. JL_LP3_Count .. "LP4" .. JL_LP4_Count)
			QueLiaoERR(112)
		else
			SetDO("DO_SL2_HongDeng", 0)
			SetDO("DO_SL2_LvDeng", 1)
		end
	else
		SetDO("DO_SL2_HongDeng", 0)
		SetDO("DO_SL2_LvDeng", 1)
	end
end

function QuLiao_DanXiangFa2()
	if JL_LP5_Count > 0 then
		for i = 1, 20 do
			if JL_LP5[i] == 1 then
				MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
				MoveAbsJ(K_LP56_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				MoveL(Offs(P_LP5[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveL(P_LP5[i], Vmid, fine, toolsj, wobj0, load10)
				Sleep(500)
				IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
				WuLiaoZhuangTai.num = 4
				Sleep(200)
				MoveL(Offs(P_LP5[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveAbsJ(K_LP56_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				JL_LP5[i] = 0
				JL_LP5_Count = JL_LP5_Count - 1
				break
			end
		end
	else
		TPWrite("DanXiangFa2queliao")
		Stop()
	end
	if JL_LP5_Count == 0 or JL_LP6_Count == 0 then
		if JL_LP5_Count == 0 and GongXu.num <= 11 then
			IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
			SetDO("DO_SL3_LvDeng", 0)
			SetDO("DO_SL3_HongDeng", 1)
			TPWrite("TP3QueLiao" .. "LP5" .. JL_LP5_Count .. "LP6" .. JL_LP6_Count)
			QueLiaoERR(113)
		elseif JL_LP6_Count == 0 and GongXu.num <= 9 then
			IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
			SetDO("DO_SL3_LvDeng", 0)
			SetDO("DO_SL3_HongDeng", 1)
			TPWrite("TP3QueLiao" .. "LP5" .. JL_LP5_Count .. "LP6" .. JL_LP6_Count)
			QueLiaoERR(113)
		else
			SetDO("DO_SL3_HongDeng", 0)
			SetDO("DO_SL3_LvDeng", 1)
		end
	else
		SetDO("DO_SL3_HongDeng", 0)
		SetDO("DO_SL3_LvDeng", 1)
	end
end

function QuLiao_M18()
	if JL_LP6_Count > 0 then
		for i = 1, 20 do
			if JL_LP6[i] == 1 then
				MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
				MoveAbsJ(K_LP56_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				MoveL(Offs(P_LP6[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveL(P_LP6[i], Vmid, fine, toolsj, wobj0, load10)
				Sleep(500)
				IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
				WuLiaoZhuangTai.num = 5
				Sleep(200)
				MoveL(Offs(P_LP6[i], 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
				MoveAbsJ(K_LP56_GuoDu, Vmax, z200, toolsj, wobj0, load10)
				JL_LP6[i] = 0
				JL_LP6_Count = JL_LP6_Count - 1
				break
			end
		end
	else
		TPWrite("M18queliao")
		Stop()
	end
	if JL_LP5_Count == 0 or JL_LP6_Count == 0 then
		if JL_LP5_Count == 0 and GongXu.num <= 11 then
			IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
			SetDO("DO_SL3_LvDeng", 0)
			SetDO("DO_SL3_HongDeng", 1)
			TPWrite("TP3QueLiao" .. "LP5" .. JL_LP5_Count .. "LP6" .. JL_LP6_Count)
			QueLiaoERR(113)
		elseif JL_LP6_Count == 0 and GongXu.num <= 9 then
			IO_check_OFF("DO_SL3_QiGangDing", "DI_SL3_Xia_DaoWei", "DI_SL3_Shang_DaoWei", 3)
			SetDO("DO_SL3_LvDeng", 0)
			SetDO("DO_SL3_HongDeng", 1)
			TPWrite("TP3QueLiao" .. "LP5" .. JL_LP5_Count .. "LP6" .. JL_LP6_Count)
			QueLiaoERR(113)
		else
			SetDO("DO_SL3_HongDeng", 0)
			SetDO("DO_SL3_LvDeng", 1)
		end
	else
		SetDO("DO_SL3_HongDeng", 0)
		SetDO("DO_SL3_LvDeng", 1)
	end
end

function QuLiao_M10()
	IO_check_OFF("DO_ZDP_QIGang", "DI_ZDP_SuoHuiDaoWei", "DI_ZDP_ShenChuDaoWei", 4)
	WaitDI("DI_ZDP_YouLiao", 1, 1000, true)
	if GetDI("DI_ZDP_YouLiao") == 0 then
		ERR_WaitIO("DI_ZDP_YouLiao", 1, 114)
		Sleep(1000)
	else
		Sleep(500)
	end
	SetDO("DO_ZDP_QIGang", 1)
	MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	MoveAbsJ(K_ZDP_GuoDu, Vmax, z200, toolsj, wobj0, load10)
	MoveL(Offs(P_ZDP, 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
	WaitDI("DI_ZDP_ShenChuDaoWei", 1)
	WaitDI("DI_ZDP_SuoHuiDaoWei", 0)
	IO_check_ON("DO_ZDP_QIGang", "DI_ZDP_ShenChuDaoWei", "DI_ZDP_SuoHuiDaoWei", 4)
	MoveL(P_ZDP, Vmid, fine, toolsj, wobj0, load10)
	Sleep(500)
	IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 9999)
	WuLiaoZhuangTai.num = 6
	Sleep(500)
	MoveL(Offs(P_ZDP, 0, 0, 100), Vmid, z10, toolsj, wobj0, load10)
	MoveAbsJ(K_ZDP_GuoDu, Vmid, z10, toolsj, wobj0, load10)
end

function NG_Fang()
	if GongXu.num >= 1 and GongXu.num <= 4 then --M24
		MoveAbsJ(K_NG_GuoDu1, Vmax, z200, toolsj, wobj0, load10)
		MoveL(P_NG_FangLiao1, Vmid, fine, toolsj, wobj0, load10)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		WuLiaoZhuangTai.num = 0
		MoveAbsJ(K_NG_GuoDu1, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num >= 6 and GongXu.num <= 9 then --M18
		MoveAbsJ(K_NG_GuoDu1, Vmax, z200, toolsj, wobj0, load10)
		MoveL(P_NG_FangLiao1, Vmid, fine, toolsj, wobj0, load10)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		WuLiaoZhuangTai.num = 0
		MoveAbsJ(K_NG_GuoDu1, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 5 or GongXu.num == 10 or GongXu.num == 11 then
		MoveAbsJ(K_NG_GuoDu2, Vmax, z200, toolsj, wobj0, load10)
		MoveL(P_NG_FangLiao2, Vmid, fine, toolsj, wobj0, load10)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		WuLiaoZhuangTai.num = 0
		MoveAbsJ(K_NG_GuoDu2, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num >= 12 and GongXu.num <= 25 then --M10
		MoveAbsJ(K_NG_GuoDu2, Vmax, z200, toolsj, wobj0, load10)
		MoveL(P_NG_FangLiao2, Vmid, fine, toolsj, wobj0, load10)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		WuLiaoZhuangTai.num = 0
		MoveAbsJ(K_NG_GuoDu2, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	end
end

function JianCe1()
	MoveAbsJ(K_JC1_GuoDu, Vmax, z200, toolsj, wobj0, load10)
	SetDO("DO_PY_TuiSong", 0)

	if GongXu.num == 5 then --LvXin
		MoveL(P_JC1_1, Vmid, fine, toolsj, wobj0, load10)
		JianCe1_FanKui1 = nil
		while (JianCe1_FanKui1 == nil) do
			JianCe1_FanKui1 = ChuFa_JianCe1()
			if JianCe1_FanKui1 == nil then
				Sleep(1000)
				TPWrite("TONGXUNYICHANG")
				Stop()
			end
		end
		MoveL(P_JC1_2, Vmid, fine, toolsj, wobj0, load10)
		JianCe1_FanKui2 = nil
		while (JianCe1_FanKui2 == nil) do
			JianCe1_FanKui2 = ChuFa_JianCe1()
			if JianCe1_FanKui2 == nil then
				Sleep(1000)
				TPWrite("TONGXUNYICHANG")
				Stop()
			end
		end
		if JianCe1_FanKui1 == 1 and JianCe1_FanKui2 == 1 then
			return "true"
		else
			TPWrite("JianCe1_FanKui1=" .. JianCe1_FanKui1 .. "JianCe1_FanKui2" .. JianCe1_FanKui2)
			return "false"
		end
	elseif GongXu.num == 10 then --danxiangfa1
		MoveL(P_JC1_3, Vmax, fine, toolsj, wobj0, load10)
		JianCe1_FanKui1 = nil
		while (JianCe1_FanKui1 == nil) do
			JianCe1_FanKui1 = ChuFa_JianCe1()
			if JianCe1_FanKui1 == nil then
				Sleep(1000)
				TPWrite("TONGXUNYICHANG")
				Stop()
			end
		end
		MoveL(P_JC1_4, Vmid, fine, toolsj, wobj0, load10)
		JianCe1_FanKui2 = nil
		while (JianCe1_FanKui2 == nil) do
			JianCe1_FanKui2 = ChuFa_JianCe1()
			if JianCe1_FanKui2 == nil then
				Sleep(1000)
				TPWrite("TONGXUNYICHANG")
				Stop()
			end
		end
		if JianCe1_FanKui1 == 1 and JianCe1_FanKui2 == 1 then
			return "true"
		else
			TPWrite("JianCe1_FanKui1=" .. JianCe1_FanKui1 .. "JianCe1_FanKui2" .. JianCe1_FanKui2)
			return "false"
		end
	elseif GongXu.num == 11 then --danxiangfa1
		MoveL(P_JC1_5, Vmid, fine, toolsj, wobj0, load10)
		JianCe1_FanKui1 = nil
		while (JianCe1_FanKui1 == nil) do
			JianCe1_FanKui1 = ChuFa_JianCe1()
			if JianCe1_FanKui1 == nil then
				Sleep(1000)
				TPWrite("TONGXUNYICHANG")
				Stop()
			end
		end
		if JianCe1_FanKui1 == 1 then
			return "true"
		else
			TPWrite("JianCe1_FanKui1=" .. JianCe1_FanKui1)
			return "false"
		end
	elseif GongXu.num >= 12 and GongXu.num <= 25 then --M10
		MoveL(P_JC1_6, Vmid, fine, toolsj, wobj0, load10)
		SetDO("DO_ZDP_QIGang", 0)
		JianCe1_FanKui1 = nil
		while (JianCe1_FanKui1 == nil) do
			JianCe1_FanKui1 = ChuFa_JianCe1()
			if JianCe1_FanKui1 == nil then
				Sleep(1000)
				TPWrite("TONGXUNYICHANG")
				Stop()
			end
		end
		if JianCe1_FanKui1 == 1 then
			return "true"
		else
			TPWrite("JianCe1_FanKui1=" .. JianCe1_FanKui1)
			return "false"
		end
	else
		TPWrite("gongxucuowu=" .. GongXu.num)
		Stop()
	end
end

function JianCe2()
	WaitDI("DI_PY_SuoHuiDaoWei", 1, 6000, true)
	WaitDI("DI_PY_TuiSongDaoWei", 0, 6000, true)
	if GetDI("DI_PY_SuoHuiDaoWei") == 0 or GetDI("DI_PY_TuiSongDaoWei") == 1 then
		ERR(9)
		ERR_WaitIO2("DI_PY_SuoHuiDaoWei", 1, "DI_PY_TuiSongDaoWei", 0, 9)
	end

	MoveAbsJ(K_PY_GuoDu, Vmax, z200, toolsj, wobj0, load10)
	if GongXu.num >= 1 and GongXu.num <= 4 then   --M24
		MoveL(P_JC2_1, Vmid, fine, toolsj, wobj0, load10)
	elseif GongXu.num >= 6 and GongXu.num <= 9 then --M18
		MoveL(P_JC2_2, Vmid, fine, toolsj, wobj0, load10)
	else
		TPWrite("gongxucuowu=" .. GongXu.num)
		Stop()
	end

	Sleep(500)
	JianCe2_FanKui = nil
	while (JianCe2_FanKui == nil) do
		JianCe2_FanKui = ChuFa_JianCe2()
		TPWrite(JianCe2_FanKui)
		if JianCe2_FanKui == 1 then
			return "true"
		elseif JianCe2_FanKui == 0 then
			return "false"
		else
			Sleep(1000)
			TPWrite("TONGXUNYICHANG")
			Stop()
		end
	end
end

function PenYou()
	SetDO("DO_PY_ChuLiao", 1)
	if GongXu.num <= 4 then
		MoveL(P_PY_1, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_PY_JiaJin", "DI_PY_JiaJinDaoWei", "DI_PY_SongKaiDaoWei", 10)
		Sleep(200)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		MoveL(Offs(P_PY_1, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	elseif GongXu.num >= 6 and GongXu.num <= 9 then
		MoveL(P_PY_2, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_PY_JiaJin", "DI_PY_JiaJinDaoWei", "DI_PY_SongKaiDaoWei", 10)
		Sleep(200)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		MoveL(Offs(P_PY_2, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	elseif GongXu.num == 10 then
		MoveAbsJ(K_PY_GuoDu, Vmax, z200, toolsj, wobj0, load10)
		MoveL(P_PY_3, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_PY_JiaJin", "DI_PY_JiaJinDaoWei", "DI_PY_SongKaiDaoWei", 10)
		Sleep(200)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		MoveL(Offs(P_PY_3, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	elseif GongXu.num == 11 then
		MoveAbsJ(K_PY_GuoDu, Vmax, z200, toolsj, wobj0, load10)
		MoveL(P_PY_4, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_PY_JiaJin", "DI_PY_JiaJinDaoWei", "DI_PY_SongKaiDaoWei", 10)
		Sleep(200)
		IO_check_OFF("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoKaiDaoWei", "DI_NJQ_ZhuaLiaoGuanDaoWei", 8)
		MoveL(Offs(P_PY_4, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	else
		TPWrite("gongxucuowu")
		Stop()
	end

	MoveAbsJ(K_PY_Start, Vmid, fine, toolsj, wobj0, load10)
	IO_check_ON("DO_PY_TuiSong", "DI_PY_TuiSongDaoWei", "DI_PY_SuoHuiDaoWei", 9)
	Sleep(500)
	SetDO("DO_PY_PenWu", 1)
	MoveAbsJ(K_PY_end, Vmid, z0, toolsj, wobj0, load10)
	SetDO("DO_PY_PenWu", 0)
	MoveAbsJ(K_PY_Start, Vmid, fine, toolsj, wobj0, load10)
	SetDO("DO_PY_ChuLiao", 0)
	IO_check_OFF("DO_PY_TuiSong", "DI_PY_SuoHuiDaoWei", "DI_PY_TuiSongDaoWei", 9)

	if GongXu.num <= 4 then
		MoveL(Offs(P_PY_1, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
		MoveL(P_PY_1, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 8)
		IO_check_OFF("DO_PY_JiaJin", "DI_PY_SongKaiDaoWei", "DI_PY_JiaJinDaoWei", 10)
		MoveL(Offs(P_PY_1, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	elseif GongXu.num >= 6 and GongXu.num <= 9 then
		MoveL(Offs(P_PY_2, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
		MoveL(P_PY_2, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 8)
		IO_check_OFF("DO_PY_JiaJin", "DI_PY_SongKaiDaoWei", "DI_PY_JiaJinDaoWei", 10)
		MoveL(Offs(P_PY_2, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	elseif GongXu.num == 10 then
		MoveL(Offs(P_PY_3, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
		MoveL(P_PY_3, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 8)
		IO_check_OFF("DO_PY_JiaJin", "DI_PY_SongKaiDaoWei", "DI_PY_JiaJinDaoWei", 10)
		MoveL(Offs(P_PY_3, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	elseif GongXu.num == 11 then
		MoveL(Offs(P_PY_4, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
		MoveL(P_PY_4, Vmid, fine, toolsj, wobj0, load10)
		Sleep(500)
		IO_check_ON_2("DO_Rob_ZhuaLiao", "DI_NJQ_ZhuaLiaoGuanDaoWei", "DI_NJQ_ZhuaLiaoKaiDaoWei", 8)
		IO_check_OFF("DO_PY_JiaJin", "DI_PY_SongKaiDaoWei", "DI_PY_JiaJinDaoWei", 10)
		MoveL(Offs(P_PY_4, 0, 0, 50), Vmax, z10, toolsj, wobj0, load10)
	else
		TPWrite("gongxucuowu")
		Stop()
	end
	MoveAbsJ(K_PY_GuoDu, Vmax, z200, toolsj, wobj0, load10)
end

function NingJin(offset1)
	MoveL(RelTool(P_ZhuangPei[GongXu.num], 0, 0, offset1, 0, 0, 0), Vmid, z0, toolsj, wobj0, load10)
	SetAO("MD_NJQ_FuWei", 0)
	MoveL(RelTool(P_ZhuangPei[GongXu.num], 0, 0, 0, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	SetDO("DO_Rob_TuiSong", 1)
	WaitDI("DI_NJQ_TuiSongDaoWei", 1, 2000, true)
	Sleep(100)
	SetDO("DO_Rob_ZhuaLiao", 0)
	SetAO("MD_NJQ_ZhengZhuan", 1)
	Sleep(100)
	while (1) do
		if GetAI("MD_NJQ_Zhuangtai") == 1 then
			SetAO("MD_NJQ_ZhengZhuan", 0)
			break
		elseif GetAI("MD_NJQ_Zhuangtai") == 3 then
			TPWrite("njqfankuiyichang")
			Stop()
			SetAO("MD_NJQ_FuWei", 1)
			SetAO("MD_NJQ_ZhengZhuan", 0)
			Sleep(500)
			SetAO("MD_NJQ_FuWei", 0)
			break
		end
	end
	Sleep(1000)
	MoveL(RelTool(P_ZhuangPei[GongXu.num], 0, 0, offset1, 0, 0, 0), Vmax, z0, toolsj, wobj0, load10)
	IO_check_OFF("DO_Rob_TuiSong", "DI_NJQ_SuoHuiDaoWei", "DI_NJQ_TuiSongDaoWei", 5)
end

function ZhuangPei()
	--批头1大 工序1234 M24  工序5 滤芯 工序6789 M18
	--批头2中 工序10 单向阀大
	--批头3小 工序11 单向阀小 工序 12_18 内测M10 19_25外侧M10
	SetAO("MD_NJQ_FuWei", 1)
	SetAO("MD_NJQ_ZhengZhuan", 0)
	SetAO("MD_NJQ_MoShi", 1)
	SetAO("MD_NJQ_ZanTing", 0)

	if GongXu.num == 1 or GongXu.num == 2 then
		MoveAbsJ(K_NJ_GuoDu1, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-30)
		MoveAbsJ(K_NJ_GuoDu1, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 3 or GongXu.num == 4 then
		MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
		MoveAbsJ(K_NJ_GuoDu2, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-30)
		MoveAbsJ(K_NJ_GuoDu2, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 5 then
		MoveAbsJ(K_home, Vmid, z200, tool1, wobj0, load10)
		MoveAbsJ(K_NJ_GuoDu3, Vmid, z200, toolsj, wobj0, load10)
		NingJin(-60)
		MoveAbsJ(K_NJ_GuoDu3, Vmid, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmid, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 6 or GongXu.num == 7 then
		MoveAbsJ(K_NJ_GuoDu4, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-30)
		MoveL(P_NJ_GuoDu4, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 8 or GongXu.num == 9 then
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-30)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 10 then
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-50)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num == 11 then
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-50)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num >= 12 and GongXu.num <= 18 then
		MoveAbsJ(K_NJ_GuoDu4, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-30)
		MoveL(P_NJ_GuoDu4, Vmax, z200, toolsj, wobj0, load10)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	elseif GongXu.num >= 19 and GongXu.num <= 25 then
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
		NingJin(-50)
		MoveAbsJ(K_home, Vmax, z200, toolsj, wobj0, load10)
	else
		TPWrite("gongxucuowu")
		Stop()
	end
	WuLiaoZhuangTai.num = 0
	GongXu.num = GongXu.num + 1
end

function DianYeFa_1()
	--批头1大 工序1234 M24  工序5 滤芯 工序6789 M18
	--批头2中 工序10 单向阀大
	--批头3小 工序11单向阀小 工序 12-25

	--if GetDO("DO_SL1_LvDeng") == 0 or GetDO("DO_SL2_LvDeng") == 0 or GetDO("DO_SL3_LvDeng") == 0 then
	--LP_Vis_DingWei()
	--end
	--MoveAbsJ(K_home,Vmax,z200,tool1,wobj0,load10)
	--等待放置到位
	if GetDI("DI_LianJi") == 1 then
		WaitAI("MD_DiaoDuQingQiu", 60)
		SetAO("MD_YunXuQuLiao", 0)
	else
		TPWrite("ShouDong queren youliao ")
		SetAO("MD_YunXuQuLiao", 0)
		Stop()
	end

	if GetDO("DO_SL1_LvDeng") == 0 or GetDO("DO_SL2_LvDeng") == 0 or GetDO("DO_SL3_LvDeng") == 0 then
		LP_Vis_DingWei()
	end
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)

	PiTouQuFang()
	if GetDI("DI_HT_YouLiao") == 0 then
		ERR_WaitIO("DI_HT_YouLiao", 1, 120)
	end
	SetDO("VIR_YunXuFangLiao", 0)
	IO_check_ON("DO_HT_JiaJin", "DI_HT_JiaJinDaoWei", "DI_HT_SongKaiDaoWei", 15)

	--视觉补偿
	MoveAbsJ(K_FaTi_CCD, Vmax, fine, toolsj, wobj0, load10)
	Sleep(500)
	FaTiBuChang = "#"
	while FaTiBuChang == "#" do
		FaTiBuChang = ChuFa_FaTiDingWei()		
		TPWrite("buchang=" .. FaTiBuChang)
		if FaTiBuChang ~= "#" then
			SetAO("offset_vision",FaTiBuChang*1000+30000)
			for i = 1, 25 do
				P_ZhuangPei[i].extax.eax_2 = 180 + FaTiBuChang
			end
			P_ZhuangPei[3].extax.eax_2 = 400 + FaTiBuChang
			P_ZhuangPei[4].extax.eax_2 = 400 + FaTiBuChang
		end
	end
	MoveAbsJ(K_home, Vmax, z200, tool1, wobj0, load10)
	while (1) do
		--料盘检测
		LP_Vis_DingWei()
		--取料
		if GongXu.num <= 4 then
			if PiTouZhuangTai.num == 1 then
				QuLiao_M24()
				JianCe2_JieGuo = nil
				JianCe2_JieGuo = JianCe2()
				TPWrite("PiQuanJianCe2_" .. JianCe2_JieGuo)
				while (JianCe2_JieGuo ~= "true") do
					if JianCe2_JieGuo == "false" then
						TPWrite("jiance cuowu")
						if GetDI("DI_LianJi") == 1 then
						else
							Stop()
						end
						--丢料
						NG_Fang()
						--取料
						LP_Vis_DingWei()
						QuLiao_M24()
						JianCe2_JieGuo = nil
						JianCe2_JieGuo = JianCe2()
						TPWrite("PiQuanJianCe2_" .. JianCe2_JieGuo)
					else
						TPWrite("fankui yichang")
					end
				end
				--喷油
				PenYou()
				ZhuangPei()
				PiTouQuFang()
			else
				TPWrite("pitouyichang")
				Stop()
			end
		elseif GongXu.num == 5 then
			if PiTouZhuangTai.num == 1 then
				QuLiao_LvXin()
				JianCe1_JieGuo = nil
				JianCe1_JieGuo = JianCe1()
				TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
				while (JianCe1_JieGuo ~= "true") do
					if JianCe1_JieGuo == "false" then
						TPWrite("jiance cuowu")
						if GetDI("DI_LianJi") == 1 then
						else
							Stop()
						end
						--丢料
						NG_Fang()
						--取料
						LP_Vis_DingWei()
						QuLiao_LvXin()
						JianCe1_JieGuo = nil
						JianCe1_JieGuo = JianCe1()
						TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
					else
						TPWrite("jiance yichang")
						Stop()
					end
				end
				ZhuangPei()
				PiTouQuFang()
			else
				TPWrite("pitouyichang")
				Stop()
			end
		elseif GongXu.num >= 6 and GongXu.num <= 9 then
			if PiTouZhuangTai.num == 1 then
				QuLiao_M18()
				JianCe2_JieGuo = nil
				JianCe2_JieGuo = JianCe2()
				TPWrite("PiQuanJianCe2_" .. JianCe2_JieGuo)
				while (JianCe2_JieGuo ~= "true") do
					if JianCe2_JieGuo == "false" then
						TPWrite("jiance cuowu")
						if GetDI("DI_LianJi") == 1 then
						else
							Stop()
						end
						--丢料
						NG_Fang()
						--取料
						LP_Vis_DingWei()
						QuLiao_M18()
						JianCe2_JieGuo = nil
						JianCe2_JieGuo = JianCe2()
						TPWrite("PiQuanJianCe2_" .. JianCe2_JieGuo)
					else
						TPWrite("jiance yichang")
						Stop()
					end
				end
				--喷油
				PenYou()
				ZhuangPei()
				PiTouQuFang()
			else
				TPWrite("pitouyichang")
				Stop()
			end
		elseif GongXu.num == 10 then
			if PiTouZhuangTai.num == 2 then
				QuLiao_DanXiangFa1()
				JianCe1_JieGuo = nil
				JianCe1_JieGuo = JianCe1()
				TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
				while (JianCe1_JieGuo ~= "true") do
					if JianCe1_JieGuo == "false" then
						TPWrite("jiance cuowu")
						if GetDI("DI_LianJi") == 1 then
						else
							Stop()
						end
						--丢料
						NG_Fang()
						--取料
						LP_Vis_DingWei()
						QuLiao_DanXiangFa1()
						JianCe1_JieGuo = nil
						JianCe1_JieGuo = JianCe1()
						TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
					else
						TPWrite("jiance yichang")
						Stop()
					end
				end
				--喷油
				PenYou()
				ZhuangPei()
				PiTouQuFang()
			else
				TPWrite("pitouyichang")
				Stop()
			end
		elseif GongXu.num == 11 then
			if PiTouZhuangTai.num == 3 then
				QuLiao_DanXiangFa2()
				JianCe1_JieGuo = nil
				JianCe1_JieGuo = JianCe1()
				TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
				while (JianCe1_JieGuo ~= "true") do
					if JianCe1_JieGuo == "false" then
						TPWrite("jiance cuowu")
						if GetDI("DI_LianJi") == 1 then
						else
							Stop()
						end
						--丢料
						NG_Fang()
						--取料
						LP_Vis_DingWei()
						QuLiao_DanXiangFa2()
						JianCe1_JieGuo = nil
						JianCe1_JieGuo = JianCe1()
						TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
					else
						TPWrite("jiance yichang")
						Stop()
					end
				end
				--喷油
				PenYou()
				ZhuangPei()
				PiTouQuFang()
			else
				TPWrite("pitouyichang")
				Stop()
			end
		elseif GongXu.num >= 12 and GongXu.num <= 25 then
			if PiTouZhuangTai.num == 3 then
				QuLiao_M10()
				JianCe1_JieGuo = nil
				JianCe1_JieGuo = JianCe1()
				TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
				while (JianCe1_JieGuo ~= "true") do
					if JianCe1_JieGuo == "false" then
						TPWrite("jiance cuowu")
						if GetDI("DI_LianJi") == 1 then
						else
							Stop()
						end
						--丢料
						NG_Fang()
						--取料
						QuLiao_M10()
						JianCe1_JieGuo = nil
						JianCe1_JieGuo = JianCe1()
						TPWrite("PiQuanJianCe1_" .. JianCe1_JieGuo)
					else
						TPWrite("jiance yichang")
						Stop()
					end
				end
				ZhuangPei()
				PiTouQuFang()
			else
				TPWrite("pitouyichang")
				Stop()
			end
		elseif GongXu.num == 26 then
			SetDO("DO_HT_JiaJin", 0)
			MoveAbsJ(K_home, Vmax, fine, tool1, wobj0, load10)
			IO_check_OFF("DO_HT_JiaJin", "DI_HT_SongKaiDaoWei", "DI_HT_JiaJinDaoWei", 15)
			SetAO("MD_YunXuQuLiao", 1)
			Sleep(10000)
			return
		else
			TPWrite("gongxucuowu")
			Stop()
		end
	end
end

-------------------------------------------------------------------------------
while (false) do
	--	home
	MoveAbsJ(K_home, Vmin, fine, tool1, wobj0, load10)
	--拍照
	MoveAbsJ(K_JL_CCD1, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD2, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD3, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD4, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD5, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_JL_CCD6, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_FaTi_CCD, Vmin, fine, toolsj, wobj0, load10)
	--料盘过度
	MoveAbsJ(K_LP56_GuoDu, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_LP34_GuoDu, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_LP12_GuoDu, Vmin, fine, tool1, wobj0, load10)
	--喷油过度
	MoveAbsJ(K_PY_GuoDu, Vmin, fine, tool1, wobj0, load10)
	--换批头过度
	MoveAbsJ(K_GH_GuoDu, Vmin, fine, tool1, wobj0, load10)
	--装配过度
	MoveAbsJ(K_NJ_GuoDu1, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_NJ_GuoDu2, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_NJ_GuoDu3, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_NJ_GuoDu4, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_NJ_GuoDu5, Vmin, fine, tool1, wobj0, load10)
	MoveL(RelTool(P_ZhuangPei_11, 0, 0, -60, 0, 0, 0), Vmin, fine, toolsj, wobj0, load10)
	MoveL(P_ZhuangPei_25, Vmin, fine, toolsj, wobj0, load10)
	--取料
	MoveL(RelTool(P_LP1[1], 0, 0, -30, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	MoveL(P_LP1[9], Vmid, fine, toolsj, wobj0, load10)


	MoveL(RelTool(P_LP2[i], 0, 0, -30, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	MoveL(P_LP2[30], Vmid, fine, toolsj, wobj0, load10)


	MoveL(RelTool(P_LP3[1], 0, 0, -30, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	MoveL(P_LP3[10], Vmid, fine, toolsj, wobj0, load10)

	MoveL(RelTool(P_LP4[i], 0, 0, -30, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	MoveL(P_LP4[20], Vmid, fine, toolsj, wobj0, load10)

	MoveL(RelTool(P_LP5[1], 0, 0, -30, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	MoveL(P_LP5[7], Vmid, fine, toolsj, wobj0, load10)

	MoveL(RelTool(P_LP6[2], 0, 0, -30, 0, 0, 0), Vmid, fine, toolsj, wobj0, load10)
	MoveL(P_LP6[7], Vmid, fine, toolsj, wobj0, load10)

	MoveAbsJ(K_ZDP_GuoDu, Vmin, fine, tool1, wobj0, load10) --M10过度
	MoveL(P_ZDP, Vmin, fine, toolsj, wobj0, load10) --M10取料
	--喷油点
	MoveL(P_PY[1], Vmin, fine, toolsj, wobj0, load10) --M24
	MoveL(P_PY[2], Vmin, fine, toolsj, wobj0, load10) --M18
	MoveL(P_PY[3], Vmin, fine, toolsj, wobj0, load10) --单向阀1
	MoveL(P_PY[4], Vmin, fine, toolsj, wobj0, load10) --单向阀2
	--检测点
	MoveL(P_JC2_1, Vmin, fine, toolsj, wobj0, load10) --M24
	MoveL(P_JC2_2, Vmin, fine, toolsj, wobj0, load10) --M18
	MoveL(P_JC1_1, Vmin, fine, toolsj, wobj0, load10) --滤芯上
	MoveL(P_JC1_2, Vmin, fine, toolsj, wobj0, load10) --滤芯下
	MoveL(P_JC1_3, Vmin, fine, toolsj, wobj0, load10) --单向阀1 上
	MoveL(P_JC1_4, Vmin, fine, toolsj, wobj0, load10) --单向阀1 下
	MoveL(P_JC1_5, Vmin, fine, toolsj, wobj0, load10) --单向阀2
	MoveL(P_JC1_6, Vmin, fine, toolsj, wobj0, load10) --M10
	--检测过度
	MoveAbsJ(K_PY_GuoDu, Vmin, fine, tool1, wobj0, load10)
	MoveAbsJ(K_JC1_GuoDu, Vmin, fine, toolsj, wobj0, load10)
	--NG过度 放料
	MoveAbsJ(K_NG_GuoDu1, Vmin, fine, toolsj, wobj0, load10)
	MoveAbsJ(K_NG_GuoDu2, Vmin, fine, toolsj, wobj0, load10)
	MoveL(P_NG_FangLiao1, Vmin, fine, toolsj, wobj0, load10)
	MoveL(P_NG_FangLiao2, Vmin, fine, toolsj, wobj0, load10)
end
----------------------------------------------------------------------------------------
Gohome()
Init()
while (1) do
	--while (GetAI("MD_ChanPinXingHao") ~= 0 or GetDI("DI_LianJi") == 0)  do
	PiTouZhuangTai.num = 0 --批头夹取状态  0_未夹取 1_大批头 2_中 3_小
	WuLiaoZhuangTai.num = 0 --物料夹取状态  0_未夹取 1_M24 2_滤芯 3_M18 4_大单向阀 5_小单向阀 6_M10
	GongXu.num = 1        --工序
	SetDO("VIR_YunXuFangLiao", 1)
	DianYeFa_1()
	--end
end
local function GLOBALDATA_DEFINE()
	LOADDATA("load2", 2.00, { 0.00, 0.00, 100.00 }, { 1.000000, 0.000000, 0.000000, 0.000000 }, 0.00, 0.00, 0.00, 0.00,
		0.00, 0.01)
	SPEEDDATA("SpdUser", 200.000, 50.000, 200.000, 50.000)
	JOINTTARGET("Home1", { 89.999, -85.001, -0.001, -8.001, -2.001, -79.999, 0.000 },
		{ 50.062, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K10", { 32.861, 12.919, 36.009, -63.717, -69.543, 36.647, 0.000 },
		{ 88.152, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K20", { 32.861, 12.919, 36.009, -63.717, -69.543, 36.647, 0.000 },
		{ 88.152, 500.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K30", { 2.996, -29.895, 55.181, 4.307, -27.166, -3.759, 0.000 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K40", { -71.692, -4.569, 35.791, 99.836, -105.728, -57.186, 0.000 },
		{ 0.025, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_FaTi_CCD", { -9.627, 5.926, 18.639, -21.800, -26.895, 20.323, 0.000 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_GH_GuoDu", { 37.793, 11.319, 22.168, -67.971, -61.679, 51.443, 0.000 },
		{ 0.036, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JC1_GuoDu", { -15.488, -11.306, 46.389, 98.207, -100.266, -53.535, 0.000 },
		{ -0.078, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JL_CCD1", { 94.445, 7.901, 11.579, -89.368, -85.646, 71.935, 0.000 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JL_CCD2", { 77.683, 9.730, 9.516, -94.981, -101.452, 71.568, 0.000 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JL_CCD3", { 98.270, -30.098, 49.160, -88.148, -82.042, 72.274, 0.000 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JL_CCD4", { 66.956, -25.759, 46.879, -99.580, -111.167, 68.316, 0.000 },
		{ 0.001, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JL_CCD5", { -94.276, -0.546, 31.975, 87.877, -86.493, -58.586, 0.000 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_JL_CCD6", { -73.516, 1.674, 29.729, 98.892, -104.192, -57.279, 0.000 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_LP12_GuoDu", { 76.526, -21.379, 53.758, -24.670, -34.999, 21.560, 0.000 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_LP34_GuoDu", { 67.229, -1.518, 45.190, -105.802, -106.540, 44.370, 0.000 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_LP56_GuoDu", { -62.428, 9.944, 39.305, 109.808, -106.378, -37.423, 0.000 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NG_GuoDu1", { -5.783, -11.987, 49.611, -94.033, -94.565, 53.320, 0.000 },
		{ 0.291, 180.002, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NG_GuoDu2", { -21.027, 13.191, 21.419, 94.882, -95.782, -54.515, 0.000 },
		{ -0.078, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NJ_GuoDu1", { 28.819, 23.483, 24.470, 34.510, -55.334, -111.803, 0.000 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NJ_GuoDu2", { -25.330, 22.578, 25.194, -31.413, -50.272, 112.123, 0.000 },
		{ 0.000, 400.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NJ_GuoDu3", { -10.487, 49.865, -31.863, 1.648, 72.481, -9.673, 0.000 },
		{ -0.045, 180.002, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NJ_GuoDu4", { 13.516, 5.595, 48.915, -79.467, -81.520, -54.079, 0.000 },
		{ 0.011, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_NJ_GuoDu5", { -0.880, -31.295, 50.729, -5.431, -20.166, 5.702, 0.000 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_PY_GuoDu", { 32.941, 4.573, 32.133, -69.159, -64.275, 49.285, 0.000 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_PY_Start", { 32.947, 4.574, 32.139, -69.172, -64.287, 49.294, 0.000 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_PY_end", { 32.947, 4.574, 32.139, -69.172, -64.287, 49.294, 0.000 },
		{ 200.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_ZDP_GuoDu", { -43.772, -11.532, 48.383, 55.387, -51.934, -40.380, 0.000 },
		{ -0.073, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("K_home", { -0.880, -31.289, 50.719, -5.430, -20.162, 5.701, 0.000 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	JOINTTARGET("VisionPos", { 0.000, 1.000, 0.000, 0.000, 1.000, 0.000, 0.000 },
		{ 100.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
	ROBTARGET("1TeachWobj", { -92.350, 1302.030, 200.520 }, { 0.006335, 0.713090, 0.700960, -0.010854 }, { 1, 0, -1, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P10", { 712.090, 718.700, 354.190 }, { 0.493700, -0.496790, 0.503341, 0.506070 }, { 0, -1, 0, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P20", { 1103.020, 180.290, 490.620 }, { 0.706723, 0.707166, -0.017507, 0.012375 }, { 0, 0, -2, 1 },
		{ 0.037, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P30", { 765.880, -0.970, 619.210 }, { 0.711029, -0.002504, 0.703091, 0.009738 }, { -1, -1, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_GH_1", { 759.000, 1052.500, 515.000 }, { 0.002588, 0.695421, 0.718576, -0.005698 }, { 0, -1, 0, 1 },
		{ 0.037, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_GH_2", { 658.500, 1053.000, 514.000 }, { 0.002139, 0.695418, 0.718590, -0.004157 }, { 0, -1, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_GH_3", { 558.500, 1051.200, 513.000 }, { 0.002628, 0.695427, 0.718567, -0.005910 }, { 0, -1, 0, 1 },
		{ 0.036, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_1", { 507.460, -393.450, 276.620 }, { 0.016196, -0.505710, 0.862498, 0.009577 }, { -1, 1, -1, 1 },
		{ -0.066, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_2", { 506.860, -393.460, 307.700 }, { 0.016198, -0.505701, 0.862504, 0.009570 }, { -1, 1, -1, 1 },
		{ -0.087, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_3", { 507.890, -393.510, 268.140 }, { 0.010685, -0.507702, 0.861453, 0.004771 }, { -1, 1, -1, 1 },
		{ -0.070, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_4", { 503.760, -399.250, 288.090 }, { 0.010686, -0.507702, 0.861453, 0.004770 }, { -1, 1, -1, 1 },
		{ -0.063, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_5", { 503.170, -399.520, 268.700 }, { 0.016198, -0.505708, 0.862499, 0.009574 }, { -1, 1, -1, 1 },
		{ -0.037, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_6", { 503.320, -399.540, 276.950 }, { 0.016198, -0.505694, 0.862508, 0.009573 }, { -1, 1, -1, 1 },
		{ -0.058, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC1_FangLiao", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC2_1", { 719.110, 710.010, 327.320 }, { 0.008431, 0.708775, 0.705293, -0.011363 }, { 0, -1, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC2_2", { 719.080, 710.020, 312.330 }, { 0.008432, 0.708767, 0.705301, -0.011382 }, { 0, -1, 0, 1 },
		{ 0.025, 180.001, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JC2_FangLiao", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JL_CCD_1", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JL_CCD_2", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JL_CCD_3", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JL_CCD_4", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JL_CCD_5", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_JL_CCD_6", { -38.820, 509.090, 872.660 }, { 0.483779, -0.487986, 0.518719, 0.508683 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_1", { -361.220, 969.720, 160.000 }, { 0.006295, 0.713089, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_10", { -122.010, 1031.000, 159.990 }, { 0.006303, 0.713079, 0.700971, -0.010830 }, { 1, 0, -1, 1 },
		{ 0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_11", { -361.910, 1089.650, 160.000 }, { 0.006296, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_12", { -302.080, 1089.820, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_13", { -241.980, 1090.370, 160.000 }, { 0.006295, 0.713088, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_14", { -182.140, 1090.440, 160.000 }, { 0.006296, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_15", { -122.580, 1091.050, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_16", { -362.570, 1149.520, 160.000 }, { 0.006296, 0.713089, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_17", { -302.430, 1149.950, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_18", { -242.770, 1150.300, 160.000 }, { 0.006295, 0.713089, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_19", { -182.460, 1150.720, 160.000 }, { 0.006296, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_2", { -301.280, 970.230, 160.000 }, { 0.006296, 0.713087, 0.700964, -0.010825 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_20", { -122.610, 1151.050, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_21", { -362.820, 1209.560, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_22", { -302.570, 1210.160, 159.670 }, { 0.006511, 0.713071, 0.700976, -0.010932 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_23", { -243.100, 1210.440, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_24", { -182.960, 1210.460, 160.000 }, { 0.006295, 0.713089, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_25", { -123.110, 1210.800, 160.000 }, { 0.006294, 0.713088, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_26", { -363.410, 1269.580, 160.000 }, { 0.006297, 0.713087, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_27", { -303.300, 1270.040, 160.000 }, { 0.006295, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_28", { -243.490, 1270.270, 160.000 }, { 0.006296, 0.713088, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_29", { -183.420, 1270.520, 160.000 }, { 0.006295, 0.713088, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_3", { -241.220, 970.420, 160.000 }, { 0.006297, 0.713086, 0.700965, -0.010826 }, { 1, 0, -1, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_30", { -123.190, 1270.820, 160.000 }, { 0.006295, 0.713089, 0.700962, -0.010825 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_4", { -181.450, 970.800, 160.000 }, { 0.006321, 0.713094, 0.700956, -0.010841 }, { 1, 0, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_5", { -121.610, 971.210, 160.000 }, { 0.006321, 0.713094, 0.700956, -0.010840 }, { 1, 0, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_6", { -361.470, 1029.500, 160.000 }, { 0.006296, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_7", { -301.640, 1030.040, 160.000 }, { 0.006296, 0.713088, 0.700962, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_8", { -241.610, 1030.440, 160.000 }, { 0.006296, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP1_9", { -181.940, 1030.870, 160.000 }, { 0.006296, 0.713088, 0.700963, -0.010824 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_1", { -60.860, 971.940, 160.000 }, { 0.006729, 0.713096, 0.700945, -0.011184 }, { 1, 0, -1, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_10", { 177.980, 1033.570, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_11", { -61.760, 1091.750, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 1, 0, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_12", { -1.920, 1092.290, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 1, -1, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_13", { 57.930, 1092.630, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_14", { 117.780, 1092.980, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_15", { 177.860, 1093.290, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_16", { -62.040, 1151.520, 160.000 }, { 0.006118, 0.708631, 0.705470, -0.010790 }, { 1, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_17", { -2.350, 1151.760, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 1, -1, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_18", { 57.380, 1152.060, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_19", { 117.550, 1152.580, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_2", { -1.360, 972.250, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 1, -1, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_20", { 177.250, 1152.890, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_21", { -62.530, 1211.580, 160.000 }, { 0.006119, 0.708631, 0.705470, -0.010790 }, { 1, 0, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_22", { -2.710, 1211.820, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 1, -1, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_23", { 57.140, 1212.230, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_24", { 117.130, 1212.290, 160.000 }, { 0.006118, 0.708632, 0.705470, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_25", { 177.140, 1212.620, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_26", { -62.820, 1271.500, 160.000 }, { 0.006119, 0.708631, 0.705470, -0.010789 }, { 1, 0, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_27", { -2.820, 1272.010, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 1, -1, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_28", { 56.940, 1272.210, 160.000 }, { 0.006119, 0.708632, 0.705469, -0.010789 }, { 0, -1, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_29", { 116.980, 1272.680, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_3", { 58.550, 972.570, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_30", { 176.470, 1272.690, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_4", { 118.300, 973.100, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_5", { 178.200, 973.090, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010790 }, { 0, -1, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_6", { -61.320, 1031.770, 160.000 }, { 0.006119, 0.708631, 0.705470, -0.010790 }, { 1, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_7", { -1.740, 1032.090, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010789 }, { 1, -1, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_8", { 57.660, 1032.530, 160.000 }, { 0.006118, 0.708632, 0.705469, -0.010791 }, { 0, -1, 0, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP2_9", { 118.260, 1033.010, 160.000 }, { 0.006119, 0.708632, 0.705470, -0.010790 }, { 0, -1, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_1", { -331.290, 519.160, 185.000 }, { 0.012838, -0.118860, 0.992826, -0.002175 }, { 1, -2, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_10", { -272.260, 639.400, 184.970 }, { 0.012834, -0.118857, 0.992826, -0.002150 }, { 1, -2, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_11", { -212.100, 641.300, 184.990 }, { 0.012835, -0.118859, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_12", { -151.960, 640.300, 184.990 }, { 0.012835, -0.118859, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_13", { -332.060, 699.640, 184.980 }, { 0.012834, -0.118857, 0.992826, -0.002149 }, { 1, -2, 0, 1 },
		{ 0.014, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_14", { -274.250, 700.510, 184.620 }, { 0.012835, -0.118859, 0.992826, -0.002149 }, { 1, -2, 0, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_15", { -213.510, 701.400, 184.960 }, { 0.012834, -0.118857, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.014, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_16", { -153.840, 702.300, 184.940 }, { 0.012834, -0.118859, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ -0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_17", { -333.970, 759.390, 184.910 }, { 0.012838, -0.118842, 0.992828, -0.002183 }, { 1, -2, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_18", { -272.710, 761.090, 184.970 }, { 0.012834, -0.118859, 0.992826, -0.002150 }, { 1, -2, 0, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_19", { -213.780, 758.730, 184.940 }, { 0.012835, -0.118857, 0.992826, -0.002149 }, { 0, -2, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_2", { -273.570, 519.560, 184.960 }, { 0.012834, -0.118857, 0.992826, -0.002151 }, { 1, -2, 0, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_20", { -155.450, 759.010, 184.900 }, { 0.012834, -0.118859, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.011, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_3", { -212.770, 520.790, 184.960 }, { 0.012836, -0.118857, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_4", { -152.870, 521.270, 184.970 }, { 0.012834, -0.118857, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_5", { -332.730, 578.580, 184.960 }, { 0.012835, -0.118859, 0.992826, -0.002150 }, { 1, -2, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_6", { -271.560, 581.070, 184.990 }, { 0.012834, -0.118857, 0.992826, -0.002151 }, { 1, -2, 0, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_7", { -212.700, 581.280, 184.960 }, { 0.012834, -0.118857, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_8", { -153.200, 582.840, 184.940 }, { 0.012834, -0.118857, 0.992826, -0.002150 }, { 0, -2, 0, 1 },
		{ -0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP3_9", { -331.660, 639.560, 185.000 }, { 0.012835, -0.118858, 0.992826, -0.002150 }, { 1, -2, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_1", { -31.700, 520.280, 169.020 }, { 0.006638, -0.118336, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_10", { 26.640, 640.830, 169.000 }, { 0.006639, -0.118336, 0.992945, -0.003681 }, { 0, -2, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_11", { 86.850, 641.510, 169.000 }, { 0.006637, -0.118335, 0.992945, -0.003682 }, { 0, -2, 0, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_12", { 146.760, 641.540, 169.000 }, { 0.006638, -0.118336, 0.992945, -0.003679 }, { 0, -2, 0, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_13", { -33.900, 699.730, 169.260 }, { 0.006639, -0.118336, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_14", { 25.530, 700.410, 168.980 }, { 0.006637, -0.118336, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_15", { 86.470, 701.180, 168.990 }, { 0.006637, -0.118335, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_16", { 145.370, 701.510, 168.980 }, { 0.006637, -0.118335, 0.992945, -0.003679 }, { 0, -2, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_17", { -34.340, 759.750, 168.990 }, { 0.006639, -0.118336, 0.992945, -0.003681 }, { 0, -2, 0, 1 },
		{ -0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_18", { 24.980, 760.330, 168.980 }, { 0.006638, -0.118334, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_19", { 85.390, 761.660, 168.970 }, { 0.006637, -0.118334, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_2", { 27.730, 520.890, 169.010 }, { 0.006637, -0.118335, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_20", { 144.500, 762.050, 168.950 }, { 0.006640, -0.118336, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_3", { 86.840, 521.210, 168.990 }, { 0.006620, -0.118344, 0.992944, -0.003704 }, { 0, -2, 0, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_4", { 146.840, 521.960, 168.990 }, { 0.006638, -0.118336, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.011, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_5", { -32.210, 579.840, 169.020 }, { 0.006637, -0.118334, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_6", { 27.040, 581.280, 169.010 }, { 0.006637, -0.118334, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_7", { 87.020, 580.910, 169.010 }, { 0.006637, -0.118335, 0.992945, -0.003680 }, { 0, -2, 0, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_8", { 147.290, 581.660, 169.000 }, { 0.006638, -0.118335, 0.992945, -0.003681 }, { 0, -2, 0, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP4_9", { -33.560, 639.820, 169.010 }, { 0.006637, -0.118335, 0.992945, -0.003679 }, { 0, -2, 0, 1 },
		{ -0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_1", { -325.280, -816.810, 169.110 }, { 0.007872, -0.000778, 0.999968, -0.001157 }, { -2, 0, -1, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_10", { -265.820, -695.430, 168.640 }, { 0.011925, -0.000774, 0.999928, -0.001158 }, { -2, 0, -1, 1 },
		{ -0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_11", { -207.350, -695.410, 168.810 }, { 0.011924, -0.000774, 0.999928, -0.001155 }, { -1, 1, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_12", { -146.960, -694.350, 168.920 }, { 0.011924, -0.000773, 0.999928, -0.001157 }, { -1, 1, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_13", { -326.920, -636.290, 168.830 }, { 0.011925, -0.000774, 0.999928, -0.001145 }, { -2, 0, -1, 1 },
		{ -0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_14", { -267.510, -635.700, 168.990 }, { 0.011924, -0.000774, 0.999928, -0.001161 }, { -2, 0, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_15", { -208.060, -635.430, 168.740 }, { 0.011924, -0.000774, 0.999928, -0.001158 }, { -1, 1, -1, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_16", { -148.500, -634.700, 168.610 }, { 0.011924, -0.000774, 0.999928, -0.001142 }, { -1, 1, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_17", { -328.160, -575.920, 168.990 }, { 0.011924, -0.000774, 0.999928, -0.001149 }, { -2, 0, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_18", { -268.150, -575.540, 168.450 }, { 0.011925, -0.000773, 0.999928, -0.001159 }, { -2, 0, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_19", { -208.800, -575.050, 168.950 }, { 0.011924, -0.000774, 0.999928, -0.001158 }, { -1, 1, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_2", { -265.110, -815.850, 169.300 }, { 0.010932, -0.000806, 0.999932, -0.003984 }, { -2, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_20", { -149.000, -574.620, 168.470 }, { 0.011926, -0.000773, 0.999928, -0.001158 }, { -1, 1, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_3", { -206.370, -814.800, 169.200 }, { 0.011925, -0.000771, 0.999928, -0.001130 }, { -1, 1, -1, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_4", { -146.830, -814.780, 169.160 }, { 0.011924, -0.000774, 0.999928, -0.001156 }, { -1, 1, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_5", { -326.650, -756.230, 169.020 }, { 0.011924, -0.000773, 0.999928, -0.001160 }, { -2, 0, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_6", { -267.000, -755.070, 168.950 }, { 0.011924, -0.000773, 0.999928, -0.001156 }, { -2, 0, -1, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_7", { -207.100, -755.020, 168.870 }, { 0.011924, -0.000773, 0.999928, -0.001158 }, { -1, 1, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_8", { -147.360, -753.640, 168.720 }, { 0.011924, -0.000773, 0.999928, -0.001158 }, { -1, 1, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP5_9", { -326.930, -696.520, 169.010 }, { 0.011931, -0.000777, 0.999928, -0.001150 }, { -2, 0, -1, 1 },
		{ -0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_1", { -25.780, -814.210, 158.560 }, { 0.011926, -0.000775, 0.999928, -0.001145 }, { -1, 1, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_10", { 32.950, -693.350, 157.490 }, { 0.011926, -0.000774, 0.999928, -0.001140 }, { -1, 1, -1, 1 },
		{ 0.010, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_11", { 93.050, -693.060, 157.800 }, { 0.011926, -0.000775, 0.999928, -0.001142 }, { -1, 1, -1, 1 },
		{ -0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_12", { 152.610, -692.840, 157.850 }, { 0.011926, -0.000775, 0.999928, -0.001144 }, { -1, 1, -1, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_13", { -27.390, -634.280, 157.800 }, { 0.011927, -0.000774, 0.999928, -0.001140 }, { -1, 1, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_14", { 32.510, -633.730, 156.970 }, { 0.011926, -0.000775, 0.999928, -0.001145 }, { -1, 1, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_15", { 92.800, -633.330, 157.970 }, { 0.011926, -0.000774, 0.999928, -0.001144 }, { -1, 1, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_16", { 152.710, -632.600, 157.510 }, { 0.011926, -0.000775, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_17", { -27.800, -573.800, 158.060 }, { 0.011926, -0.000774, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_18", { 32.430, -573.400, 158.680 }, { 0.011927, -0.000774, 0.999928, -0.001142 }, { -1, 1, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_19", { 92.070, -572.920, 157.940 }, { 0.011926, -0.000774, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_2", { 34.370, -813.270, 158.120 }, { 0.011926, -0.000763, 0.999928, -0.001131 }, { -1, 1, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_20", { 151.460, -572.610, 158.170 }, { 0.011927, -0.000776, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_3", { 94.010, -812.530, 157.880 }, { 0.011926, -0.000774, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ -0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_4", { 154.230, -812.590, 158.370 }, { 0.011927, -0.000775, 0.999928, -0.001138 }, { -1, 1, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_5", { -26.390, -754.180, 158.850 }, { 0.011928, -0.000775, 0.999928, -0.001141 }, { -1, 1, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_6", { 33.570, -753.200, 159.100 }, { 0.011926, -0.000775, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_7", { 93.130, -753.010, 157.930 }, { 0.011927, -0.000774, 0.999928, -0.001140 }, { -1, 1, -1, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_8", { 153.560, -752.600, 157.240 }, { 0.011926, -0.000775, 0.999928, -0.001143 }, { -1, 1, -1, 1 },
		{ 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_LP6_9", { -26.570, -694.100, 157.680 }, { 0.011929, -0.000783, 0.999928, -0.001131 }, { -1, 1, -1, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_NG_FangLiao1", { 623.040, 48.370, 174.580 }, { 0.007724, 0.708838, 0.705165, -0.015175 }, { -1, -2, 0, 1 },
		{ 0.298, 180.002, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_NG_FangLiao2", { 800.810, -572.580, 190.630 }, { 0.016414, -0.506135, 0.862248, 0.009324 }, { -1, 1, -1, 1 },
		{ -0.071, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_NG_FangLiao3", { 623.040, 48.370, 174.580 }, { 0.007724, 0.708838, 0.705165, -0.015175 }, { -1, -2, 0, 1 },
		{ 0.298, 180.002, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_NG_FangLiao4", { 623.040, 48.370, 174.580 }, { 0.007724, 0.708838, 0.705165, -0.015175 }, { -1, -2, 0, 1 },
		{ 0.298, 180.002, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_NJ_GuoDu4", { 937.650, 414.850, 572.330 }, { 0.504821, 0.507549, 0.497313, 0.490132 }, { 0, -1, -1, 1 },
		{ -0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_PY_1", { 720.740, 717.110, 328.280 }, { 0.008431, 0.708784, 0.705284, -0.011342 }, { 0, -1, 0, 1 },
		{ -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_PY_2", { 720.740, 717.110, 326.620 }, { 0.008431, 0.708784, 0.705284, -0.011342 }, { 0, -1, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_PY_3", { 720.740, 717.110, 333.940 }, { 0.008431, 0.708784, 0.705284, -0.011342 }, { 0, -1, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_PY_4", { 720.740, 717.120, 333.940 }, { 0.008431, 0.708784, 0.705284, -0.011342 }, { 0, -1, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_PY_5", { 714.840, 556.780, 609.490 }, { 0.499779, -0.495374, 0.500060, 0.504743 }, { 0, -1, 0, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZDP", { 486.150, -691.530, 225.980 }, { 0.014249, -0.738443, 0.674055, 0.012193 }, { -1, 0, -1, 1 },
		{ -0.073, 179.999, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_1", { 1102.320, 157.190, 338.000 }, { 0.704478, 0.709427, -0.016488, 0.012353 }, { 0, 0, -2, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_10", { 1107.850, -287.100, 381.620 }, { 0.000367, -0.999970, -0.003232, 0.006983 },
		{ -1, -1, 0, 1 }, { 0.003, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_11", { 1086.620, -266.520, 380.340 }, { 0.000368, -0.999970, -0.003230, 0.006984 },
		{ -1, -1, 0, 1 }, { -0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_12", { 1025.250, 161.330, 296.500 }, { 0.504701, 0.507451, 0.497415, 0.490254 }, { -1, -2, -1, 1 },
		{ -0.040, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_13", { 1025.050, 121.300, 296.420 }, { 0.504706, 0.507446, 0.497413, 0.490257 }, { -1, -2, -1, 1 },
		{ -0.041, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_14", { 1025.700, 81.380, 296.420 }, { 0.504705, 0.507445, 0.497413, 0.490258 }, { -1, -2, -1, 1 },
		{ -0.041, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_15", { 1025.680, 41.700, 296.420 }, { 0.504705, 0.507445, 0.497413, 0.490258 }, { -1, -2, -1, 1 },
		{ -0.040, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_16", { 1026.050, 1.450, 296.460 }, { 0.504708, 0.507444, 0.497414, 0.490256 }, { -1, -2, -1, 1 },
		{ -0.038, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_17", { 1026.100, -38.170, 296.590 }, { 0.504706, 0.507445, 0.497413, 0.490257 }, { -1, -2, -1, 1 },
		{ -0.037, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_18", { 1026.270, -78.240, 296.350 }, { 0.504705, 0.507444, 0.497414, 0.490258 }, { -1, -2, -1, 1 },
		{ -0.040, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_19", { 1028.590, 160.370, 381.430 }, { 0.000379, -0.999971, -0.003229, 0.006915 }, { 0, 0, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_2", { 1075.270, 154.930, 337.490 }, { 0.706248, 0.707644, -0.017310, 0.012397 }, { 0, 0, -2, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_20", { 1028.760, 120.610, 380.740 }, { 0.000375, -0.999971, -0.003230, 0.006936 }, { 0, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_21", { 1028.820, 80.810, 380.640 }, { 0.000370, -0.999970, -0.003233, 0.006964 }, { 0, 0, -1, 1 },
		{ 0.000, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_22", { 1029.010, 40.500, 381.220 }, { 0.000368, -0.999970, -0.003233, 0.006975 }, { 0, 0, -1, 1 },
		{ 0.004, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_23", { 1029.110, 0.740, 381.110 }, { 0.000367, -0.999970, -0.003234, 0.006982 }, { -1, -1, 0, 1 },
		{ 0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_24", { 1029.380, -39.280, 381.100 }, { 0.000366, -0.999970, -0.003234, 0.006986 }, { -1, -1, 0, 1 },
		{ 0.008, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_25", { 1029.170, -79.010, 381.520 }, { 0.000366, -0.999970, -0.003234, 0.006987 }, { -1, -1, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_3", { 1102.780, -70.880, 335.140 }, { 0.707202, -0.706699, 0.016384, 0.013168 }, { -1, -1, 1, 1 },
		{ -0.005, 399.018, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_4", { 1070.480, -70.090, 335.150 }, { 0.708903, -0.704992, 0.016437, 0.013177 }, { -1, -1, 1, 1 },
		{ 0.012, 399.689, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_5", { 1124.500, -265.200, 371.170 }, { 0.011008, -0.696730, -0.001640, 0.717247 }, { -1, 0, -1, 0 },
		{ -0.051, 180.002, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_6", { 1031.000, -171.390, 296.180 }, { 0.500723, 0.517687, 0.494044, 0.487029 }, { -1, -2, -1, 1 },
		{ -0.007, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_7", { 1031.000, -122.090, 296.920 }, { 0.503664, 0.509240, 0.496916, 0.489971 }, { -1, -2, -1, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_8", { 1029.810, -170.760, 377.100 }, { 0.000369, -0.999970, -0.003238, 0.006982 }, { -1, -1, 0, 1 },
		{ 0.001, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	ROBTARGET("P_ZhuangPei_9", { 1029.040, -121.640, 376.330 }, { 0.000369, -0.999970, -0.003237, 0.006985 }, { -1, -1, 0, 1 },
		{ 0.005, 180.000, 0.000, 0.000, 0.000, 0.000, 0.000 }, 0.000)
	STRINGDATA("received", "")
	STRINGDATA("send", "")
end
print("The end!")
