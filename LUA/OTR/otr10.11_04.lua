--兴达OTR项目,桁架控制程序
--设备相关: 桁架(三轴平行关节,有X Y Z三轴),成品托盘位6个(三层,每层12个),成品缓存盘5个(一层,每层12个),不良品小车(一层,每层4个),
--滚筒线末端,会将成品轮流到末端,供桁架抓取. 
--桁架末端有 RFID 读取器一个,读取轮上的RFID标签, 然后将标签值跟兴达MES系统查询,得到它的产品类型. 
--桁架末端还有一个机器视觉,用它实现抓取定位跟托盘到位拍照确定

local cjson = require "cjson"
local pam_json = cjson.new()
local visionIdx = 1
local productHeight = 212
local grabSafeHeight = 70
--在安全高度层运行
local n_safeHeight= -800.59
--下一个动作,1 放托盘, 2 放缓存 3 放不良品 4 抓缓存 0 没有动作
local nextMove = {type=0, carryToPallet={ index=1,level=1,position=1}, carryToCache={index=1,position=1}, carryToCart={position=1}, grabFromCache={index=1,position=1}}
local whileCnt = 0

--配方设置还有当前桁架的堆叠状态
local config = {
	{type="pallet",level=1,count=12,index=1,state=0,--state 0没有托盘 1有托盘等待去拍照 2可以堆叠  9堆叠满了
	status={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,2,2,2,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	coordinates={{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10}}},
	{type="pallet",level=1,count=12,index=2,state=0,
	status={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	coordinates={{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10}}},
	{type="pallet",level=2,count=12,index=3,state=1,
	status={{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	coordinates={{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10}}},
	{type="pallet",level=2,count=12,index=4,state=0,
	status={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	coordinates={{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10}}},
	{type="pallet",level=2,count=12,index=5,state=0,
	status={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	coordinates={{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10}}},
	{type="pallet",level=2,count=12,index=6,state=0,
	status={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	coordinates={{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10},{10,10}}},
	{type="caches",count=12,state=2,
	status={{1,1,1,1,1,1,1,1,1,1,1,1},{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}},
	set={{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1,1,1,1}}},
	{type="cart",count=3,state=2,status={1,1,1,0}}
	}
	
--缓存台坐标集
local posesCache = {
	{KC1_1,KC1_2,KC1_3,KC1_4,KC1_5,KC1_6,KC1_7,KC1_8,KC1_9,KC1_10,KC1_11,KC1_12},
	{KC2_1,KC2_2,KC2_3,KC2_4,KC2_5,KC2_6,KC2_7,KC2_8,KC2_9,KC2_10,KC2_11,KC2_12},
	{KC3_1,KC3_2,KC3_3,KC3_4,KC3_5,KC3_6,KC3_7,KC3_8,KC3_9,KC3_10,KC3_11,KC3_12},
	{KC4_1,KC4_2,KC4_3,KC4_4,KC4_5,KC4_6,KC4_7,KC4_8,KC4_9,KC4_10,KC4_11,KC4_12},
	{KC5_1,KC5_2,KC5_3,KC5_4,KC5_5,KC5_6,KC5_7,KC5_8,KC5_9,KC5_10,KC5_11,KC5_12}
	}	
	
--不良品坐标集	
local posesBads = {KB1,KB2,KB3,KB4}	

local palletStateNums = {"Pallet1","Pallet2","Pallet3","Pallet4","Pallet5","Pallet6"}

local i,i1,i2,i3,i4,i5 = 0

--读取配置内容,包含:6个托盘的摆放配方及当前摆放状态,所有缓存台的摆放状态. 托盘的坐标拍摄值, 不良品小车的摆放状态
function readConfig()
    local readfile = io.open("/home/controller/usr/Program/config.json","r")
    local readf = readfile:read("*a")
    readfile:close()
    config = pam_json.decode(readf)
end

--保存配置内容跟状态. 桁架的每一次动作完成都要做一次保存. 避免控制柜停电等异常情况导致的数据丢失
function saveConfig()
	local str =  pam_json.encode(config)
	local posfile = io.open("/home/controller/usr/Program/config.json","w")
	io.output(posfile)
	io.write(str)
	Sleep(500)
	posfile:close()    
  Sleep(200)
savetag.num=1

end

--当前位置上升到安全高度
function toSafeHeight()
  Knext = GetJointTarget("Xyzw")
  Knext.robax.rax_3 = n_safeHeight
  MoveAbsJ(Knext,v_vertical,fine,tool0,wobj0,load0)
end

--桁架末端移动到滚筒线末端,拍照,抓取,再上升到安全高度等待
function visionOnConveyor()
	toSafeHeight()
	VisionRequest.num = 0
	MESRequest.num = 0
        Sleep( 2000) 
	MoveAbsJ(KconveyorVisionUp,v_safeHeight,fine,tool0,wobj0,load0)  
	S_Vision.str = "000025#0111@0009&0004,0,0;0000#"
	SetDO("GuangYuan_Xiao",1)
	N_VX.num = 0
	N_VY.num = 0
	MoveAbsJ(KconveyorVision,v_vertical,fine,tool0,wobj0,load0)  
	VisionRequest.num = 1
	Sleep(200)
	whileCnt = 0
	while VisionRequest.num == 1 do
		Sleep(100)
		whileCnt = whileCnt + 1
		if whileCnt >= 500 then
			S_Error.str = "Vision_Request_fail"
			TPWrite(S_Error.str)  		
			Stop()
		end
	end
	SetDO("GuangYuan_Xiao",0)
	N_VX.num = N_VX.num/10000
	N_VY.num = N_VY.num/10000
	KconveyorGrabVH.robax.rax_1 = N_VX.num
	KconveyorGrabVH.robax.rax_2 = N_VY.num
	KconveyorGrabVH.robax.rax_3 = KconveyorVision.robax.rax_3
	KconveyorGrab.robax.rax_1 = N_VX.num
	KconveyorGrab.robax.rax_2 = N_VY.num	
	TPWrite(N_VX.num,N_VY.num)
  productType.num = 0	
  
	MoveAbsJ(KconveyorGrabVH,v_vertical,fine,tool0,wobj0,load0)  
--  MESRequest.num = 1
	KconveyorGrabVH.robax.rax_3 = KconveyorGrab.robax.rax_3 - 65
	MoveAbsJ(KconveyorGrabVH,v_vertical,fine,tool0,wobj0,load0)  
	
	
--	whileCnt = 0
--	while MESRequest.num == 1 do
--		Sleep(100)
--		whileCnt = whileCnt + 1
--		if whileCnt >= 500 then
--			S_Error.str = "MES_Request_fail"
--			TPWrite(S_Error.str)   		
--			Stop()
--		end		
--	end
end

function callRFID()
  MESRequest.num = 1
  whileCnt = 0
  while MESRequest.num == 1 do
    Sleep(100)
    whileCnt = whileCnt + 1
    if whileCnt >= 500 then
      S_Error.str = "MES_Request_fail"
      TPWrite(S_Error.str)      
      Stop()
    end   
  end
end

--从滚筒末端抓轮子
function grabFromConveyor()
  grabDone.num = 0
	MoveAbsJ(KconveyorGrab,v_grab,fine,tool0,wobj0,load0)  
	closeGrab()
	toSafeHeight()
  grabDone.num = 1
end

--空托盘拍照. 拍照4个角的坐标, 计算出剩余8个点的坐标. RT LT LB RB 分表表示4个角落
--之所以不使用三角函数,是因为控制器本身的CPU的浮点精度不高,使用三角函数会带来浮点运算误差
--所以使用4个角点坐标只做比例乘除,减少误差
function visionOnPallet(idx)
  toSafeHeight()
  VisionRequest.num = 0
	local posesAll = {{KVisionOnPallet1_RT,KVisionOnPallet1_LT,KVisionOnPallet1_LB,KVisionOnPallet1_RB},
	{KVisionOnPallet2_RT,KVisionOnPallet2_LT,KVisionOnPallet2_LB,KVisionOnPallet2_RB},
	{KVisionOnPallet3_RT,KVisionOnPallet3_LT,KVisionOnPallet3_LB,KVisionOnPallet3_RB},
	{KVisionOnPallet4_RT,KVisionOnPallet4_LT,KVisionOnPallet4_LB,KVisionOnPallet4_RB},
	{KVisionOnPallet5_RT,KVisionOnPallet5_LT,KVisionOnPallet5_LB,KVisionOnPallet5_RB},
	{KVisionOnPallet6_RT,KVisionOnPallet6_LT,KVisionOnPallet6_LB,KVisionOnPallet6_RB}
	}
	local posesH = {KVisionOnPallet1_RT_H,KVisionOnPallet2_RT_H,KVisionOnPallet3_RT_H,KVisionOnPallet4_RT_H,KVisionOnPallet5_RT_H,KVisionOnPallet6_RT_H}
	local poses = posesAll[idx]
	local posH = posesH[idx]
	--水平运动到第一个拍照点最上方
	MoveAbsJ(posH,v_safeHeight,fine,tool0,wobj0,load0)  
	for var=1,4,1 do
		S_Vision.str = "000025#0111@0009&0004,1,0;0000#"
		SetDO("GuangYuan_Da",1)
		N_VX.num = 0
		N_VY.num = 0
		MoveAbsJ(poses[var],v_vertical,fine,tool0,wobj0,load0)  
		Sleep(4000)
		VisionRequest.num = 1
		Sleep(800)
		whileCnt = 0
		while VisionRequest.num == 1 do
			Sleep(100)
			whileCnt = whileCnt + 1
			if whileCnt >= 500 then
				S_Error.str = "Vision_Request_fail"
				TPWrite(S_Error.str)   		
				Stop()
			end	
		end
		SetDO("GuangYuan_Da",0)
    N_VX.num = N_VX.num/10000
    N_VY.num = N_VY.num/10000
		Knext = GetJointTarget("Xyzw")			
		if var == 1 then			
			config[idx].coordinates[12] = {Knext.robax.rax_1-KconveyorVision.robax.rax_1 + N_VX.num,Knext.robax.rax_2-KconveyorVision.robax.rax_2 + N_VY.num}
		elseif var == 2 then
			config[idx].coordinates[10] = {Knext.robax.rax_1-KconveyorVision.robax.rax_1 + N_VX.num,Knext.robax.rax_2-KconveyorVision.robax.rax_2 + N_VY.num}
		elseif var == 3 then
			config[idx].coordinates[1] = {Knext.robax.rax_1-KconveyorVision.robax.rax_1 + N_VX.num,Knext.robax.rax_2-KconveyorVision.robax.rax_2 + N_VY.num}
		elseif var == 4 then
			config[idx].coordinates[3] = {Knext.robax.rax_1-KconveyorVision.robax.rax_1 + N_VX.num,Knext.robax.rax_2-KconveyorVision.robax.rax_2 + N_VY.num}	
		end
	end
	local cords = config[idx].coordinates
	cords[2] = {(cords[1][1]+cords[3][1])/2,(cords[1][2]+cords[3][2])/2}
	cords[11] = {(cords[12][1]+cords[10][1])/2,(cords[12][2]+cords[10][2])/2}
	local gapY1_10 = (cords[1][2] - cords[10][2])/3
	local gapX1_10 = (cords[1][1] - cords[10][1])/3
	cords[4] = {(cords[10][1]+gapX1_10*2),(cords[10][2]+gapY1_10*2)}
	cords[7] = {(cords[10][1]+gapX1_10*1),(cords[10][2]+gapY1_10*1)}
	local gapY3_12 = (cords[3][2] - cords[12][2])/3
	local gapX3_12 = (cords[3][1] - cords[12][1])/3
	cords[6] = {(cords[12][1]+gapX3_12*2),(cords[12][2]+gapY3_12*2)}
	cords[9] = {(cords[12][1]+gapX3_12*1),(cords[12][2]+gapY3_12*1)}	
	cords[5] = {(cords[4][1]+cords[6][1])/2,(cords[4][2]+cords[6][2])/2}
	cords[8] = {(cords[7][1]+cords[9][1])/2,(cords[7][2]+cords[9][2])/2}
	toSafeHeight()
	config[idx].status = {{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}}
	config[idx].count = 0
 config[idx].level = 1
	config[idx].state = 2
	saveConfig()
end

--从缓存台上抓取
function grabFromCache()
	local index = nextMove.grabFromCache.index
	local position = nextMove.grabFromCache.position
	toSafeHeight()
	openGrab()	
	local pos = posesCache[index][position]
	Knext = GetJointTarget("Xyzw")
	Knext.robax.rax_1 = pos.robax.rax_1
	Knext.robax.rax_2 = pos.robax.rax_2
    MoveAbsJ(Knext,v_safeHeight,fine,tool0,wobj0,load0)	
	Knext.robax.rax_3 = pos.robax.rax_3 - grabSafeHeight
	MoveAbsJ(Knext,v_vertical,fine,tool0,wobj0,load0)	
	Knext.robax.rax_3 = pos.robax.rax_3 
	MoveAbsJ(Knext,v_grab,fine,tool0,wobj0,load0)	

	config[7].status[index][position] = 0
	config[7].count = config[7].count - 1
	--saveConfig()
	closeGrab()	
	saveConfig()
	toSafeHeight()
end

--放置到缓存台上
function carryToCache()
	local index = nextMove.carryToCache.index
	local position = nextMove.carryToCache.position
 TPWrite("index,position:",index,"/",position)
	toSafeHeight()
	local pos = posesCache[index][position]
	Knext = GetJointTarget("Xyzw")
	Knext.robax.rax_1 = pos.robax.rax_1
	Knext.robax.rax_2 = pos.robax.rax_2
    MoveAbsJ(Knext,v_safeHeight,fine,tool0,wobj0,load0)	
	Knext.robax.rax_3 = pos.robax.rax_3 - grabSafeHeight
	MoveAbsJ(Knext,v_vertical,fine,tool0,wobj0,load0)	
	Knext.robax.rax_3 = pos.robax.rax_3 - 8
	MoveAbsJ(Knext,v_grab,fine,tool0,wobj0,load0)	

	config[7].status[index][position] = productType.num

 	openGrab()	
	saveConfig()
	toSafeHeight()
end

--放置到托盘上
function carryToPallet()
	local id = nextMove.carryToPallet.index
	local lv = nextMove.carryToPallet.level
	local idx = nextMove.carryToPallet.position

	TPWrite("id,lv,idx:",id,"/",lv,"/",idx)
	local poses = {KPallet1_RT,KPallet2_RT,KPallet3_RT,KPallet4_RT,KPallet5_RT,KPallet6_RT}
	toSafeHeight()
	local xy = config[id].coordinates[idx]
	Knext = GetJointTarget("Xyzw")
	Knext.robax.rax_1 = xy[1]
	Knext.robax.rax_2 = xy[2]
    TPWrite(Knext.robax.rax_1,Knext.robax.rax_2,Knext.robax.rax_3)
    MoveAbsJ(Knext,v_safeHeight,fine,tool0,wobj0,load0)
	Knext.robax.rax_3 = poses[id].robax.rax_3 - (lv-1) * productHeight - grabSafeHeight
    TPWrite(Knext.robax.rax_1,Knext.robax.rax_2,Knext.robax.rax_3)
	MoveAbsJ(Knext,v_vertical,fine,tool0,wobj0,load0)
  
	if (lv<=1) then
	  Knext.robax.rax_3 = poses[id].robax.rax_3 - (lv-1) * productHeight - 8
	else
	  Knext.robax.rax_3 = poses[id].robax.rax_3 - (lv-1) * productHeight - 3
	end
 
	MoveAbsJ(Knext,v_grab,fine,tool0,wobj0,load0)

	config[id].status[lv][idx] = productType.num
	config[id].count = config[id].count + 1
	if config[id].count == 12 then
		config[id].level = 2
	elseif config[id].count == 24 then
		config[id].level = 3
	elseif config[id].count >= 36 then
		config[id].state = 9

	end
 	openGrab()
	saveConfig()
	toSafeHeight()

end

--放置到不良品小车上
function carryToCart()
	local position = nextMove.carryToCart.position
	toSafeHeight()
	local pos = posesBads[position]
	Knext = GetJointTarget("Xyzw")
	Knext.robax.rax_1 = pos.robax.rax_1
	Knext.robax.rax_2 = pos.robax.rax_2
    MoveAbsJ(Knext,v_safeHeight,fine,tool0,wobj0,load0)	
	Knext.robax.rax_3 = pos.robax.rax_3 - grabSafeHeight
	MoveAbsJ(Knext,v_vertical,fine,tool0,wobj0,load0)	
	Knext.robax.rax_3 = pos.robax.rax_3 - 4
	MoveAbsJ(Knext,v_grab,fine,tool0,wobj0,load0)	

	config[8].status[position] = productType.num
	config[8].count = config[8].count + 1
	if config[8].count == 4 then
		config[8].state = 9
	end
 	openGrab()		
	saveConfig()
	toSafeHeight()
end


--滚筒末端的轮子被MES识别后
function afterMES()
	Sleep(100)

	if productType.num == 9 then
		--判定这是个不良品
		local bad = config[8]
		if bad.state == 1 then			
			nextMove.type = 3
			nextMove.carryToCart.position = bad.count+1
			return 1
		end
	end
		--尝试放托盘
		for i=1,6,1 do
			local p = config[i]
			--状态处于 可以堆叠 的托盘,可以执行
			if p.state == 2 then
				local set = p.set[p.level]
				local status = p.status[p.level]
        local position =  1 + p.count - (p.level-1)*12 
        position = 12 - position + 1

				--配方符合条件,且当前为空,可以放
				if (status[position] == 0) and (set[position] == productType.num) then						
					nextMove.type = 1
					nextMove.carryToPallet.index = i
					nextMove.carryToPallet.level = p.level						
					nextMove.carryToPallet.position = position		
					return 1
				end

			end
		end
		--没有放托盘,就放缓存
		if  config[7].state == 2 then
			local caches = config[7]
			for i=1,5,1 do
				for i1=12,1,-1 do
					--配方符合条件,且当前为空,可以放
					if (caches.set[i][i1] == productType.num) and (caches.status[i][i1] == 0) then					  
						nextMove.type = 2
						nextMove.carryToCache.index = i					
						nextMove.carryToCache.position = i1		
						return 1
					end
				end
			end			
		end
	
	nextMove.type = 0
	return 0
end

--判断当前状态能否从缓存台上抓轮子放到托盘上
function checkCacheGrab()
    --遍历5个托盘,寻找可以抓的轮子
    for i=1,5,1 do
        --每个托盘12个轮子
        for i1=1,12,1 do
            --读取轮子的状态
            local _productType = config[7].status[i][i1]
            --当前位置有轮子
            if _productType > 0 then
                TPWrite("_productType",_productType)
                --遍历6个托盘
                for i2=1,6,1 do
                    local p = config[i2]
                    --判断这个托盘能否放轮子
                    if p.state == 2 then
                        --判断托盘上的位置上,能否放这个轮子
                        local position =   p.count  - (p.level-1) * 12
                        position = 12 - position 
                        TPWrite("position",position,"i2",i2)
                        if p.set[p.level][position] == _productType then
                            TPWrite("position",position,"_productType",_productType)
                            if p.status[p.level][position]==0 then
                                nextMove.type = 3
                                productType.num = _productType
                                nextMove.grabFromCache.index = i
                                nextMove.grabFromCache.position = i1
                                nextMove.carryToPallet.index = i2
                                nextMove.carryToPallet.level = p.level
                                nextMove.carryToPallet.position = position
                                return 1
                            end
                        end
                        
                    end
                end
            end
        end
    end
    return 0
end

--打开爪子
function openGrab()
  SetDO("Zhuazi_Open",1)
  SetDO("Zhuazi_Close",0)
  Sleep(500)
  WaitDI("Zhuazi_Guan",0)  
  WaitDI("Zhuazi_Kai",1)  
  Grabbing.num = 0
end

--关闭爪子
function closeGrab()
  WaitDI("GongZiLun_GanYing",1)  
  SetDO("Zhuazi_Open",0)
  SetDO("Zhuazi_Close",1)
  Sleep(500)
  WaitDI("Zhuazi_Guan",1)
  WaitDI("Zhuazi_Kai",0)
  Grabbing.num = 1
end

--主程序开始
SetDO("GuangYuan_Xiao",0)
SetDO("GuangYuan_Da",0)
readConfig() 
while true do
	Sleep(50)
  if buliangpin_car_status.num == 1 then
		config[8].state = 1
    config[8].count = 0
    config[8].status = {0,0,0,0}
    buliangpin_car_status.num = -1
    saveConfig()
  elseif buliangpin_car_status.num == 0 then
		config[8].state = 0
    config[8].count = 0
    config[8].status = {0,0,0,0}
  end
	for i=1,6,1 do
		if GetAO(palletStateNums[i]) == 1 then
			config[i].state = 1
      config[i].count = 0
      config[i].level = 1 
			config[i].status = {{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0},{0,0,0,0,0,0,0,0,0,0,0,0}}
			visionOnPallet(i)
			SetAO(palletStateNums[i], -1)
		elseif GetAO(palletStateNums[i]) == 0 then
      
			config[i].state = 0
      config[i].count = 0
      config[i].level = 1
      TPWrite("palletStateNums",i,"val",config[i].state)
		end
	end
	
	--主循环逻辑: 滚筒末端有轮子,就去抓轮子,然后放托盘或缓存. 末端没有轮子,就根据当前缓存,抓缓存放到托盘. 

	if checkCacheGrab() == 1 then
		grabFromCache()
		carryToPallet()
		nextMove.type = 0
	else
  	if GetDI("GunTong") == 1 then
--  		visionOnConveyor()
--  		while (afterMES()==0) do
--  			S_Error.str = "no place left"
--  			TPWrite(S_Error.str)   	
--  			Stop()
--  			visionOnConveyor()
--  		end
--  		grabFromConveyor()

      visionOnConveyor()
      grabFromConveyor()
      callRFID()
      Sleep(300)
      callRFID()
      while (afterMES()==0) do
        S_Error.str = "no place left"
        TPWrite(S_Error.str)    
        Stop()
        callRFID()
        Sleep(300)
        callRFID()
      end

  		if nextMove.type == 1 then
     
  			carryToPallet()
        MoveAbsJ(KconveyorVisionUp,v_safeHeight,fine,tool0,wobj0,load0)
  		elseif nextMove.type == 2 then
  			carryToCache()
  		elseif nextMove.type == 3 then		
  			carryToCart()
  		end
  		nextMove.type = 0
  	end
  end
end

local function GLOBALDATA_DEFINE()
JOINTTARGET("K10",{6208.790,909.419,-800.582,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{5085.680,446.752,-565.740,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K30",{5085.680,446.751,-565.740,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K40",{4935.020,436.270,-651.590,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
end
print("The end!")