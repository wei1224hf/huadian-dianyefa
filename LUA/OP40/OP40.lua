require "SocketApi"
local socketName = "sock"
local retVal = false
local receivedData = nil

local OUTER_TO_CENTER = 100 -- 外滑块,移动到中间,供大6轴放阀体,或抓阀体
local OUTER_TO_LEFT = 110 -- 外滑块,移动到左侧,供SCARA-右放阀串 DN-10
local OUTER_TO_RIGHT = 120 -- 外滑块,移动到右侧,供SCARA-右放阀串 DN-20
local OUTER_LEFT_POSITION = 130  --外轨道视觉定位平移到装配位置
local OUTER_TO_ONLY_LEFT = 140 -- 外滑块,移动到左侧
local INNER_TO_CENTER = 200 -- 内滑块,移动到中间,供大6轴放阀体,或抓阀体
local INNER_TO_LEFT = 210 -- 内滑块,移动到左侧,供SCARA-右放阀串 DN-10
local INNER_TO_RIGHT = 220 -- 内滑块,移动到右侧,供SCARA-右放阀串 DN-20
local INNER_LEFT_POSITION = 230  --内轨道视觉定位平移到装配位置
local INNER_TO_ONLY_CENTER = 240 -- 内滑块,移动到中间
local INNER_TO_ONLY_LEFT = 250 -- 内滑块,移动到左侧
local BUNK_LEFT_FULL_IN = 300 -- 左进料舱,下降到第一层,滚筒内滚,供 AGV 到位后送料盘
local BUNK_LEFT_FULL_OUT = 310 -- 左进料舱,下降到第一层,滚筒外滚,供 AGV 到位后拉走料盘, 若AGV要将原料送还仓库, 在产线清线返还余料时
local BUNK_LEFT_EMPTY_OUT = 320 -- 左出空舱,下降到第一层,滚筒外滚,供 AGV 到位后拉走空盘
local BUNK_LEFT_SHIFT = 330 -- 左移盘架,转移一个托盘
local BUNK_LEFT_FULL_CHECK = 340 -- 左侧满料舱,缓慢上台托盘并检测
local BUNK_LEFT_EMPTY_STOP = 350 -- 左侧空盘舱,AGV拉出成功,滚筒停止
local BUNK_LEFT_FULL_STOP = 360 -- 左侧满料舱,AGV拉出成功,滚筒停止
local BUNK_RIGHT_FULL_IN = 400 -- 右进料舱,下降到第一层,滚筒内滚,供 AGV 到位后送料盘
local BUNK_RIGHT_FULL_OUT = 410 -- 右进料舱,下降到第一层,滚筒外滚,供 AGV 到位后拉走料盘, 若AGV要将原料送还仓库, 在产线清线返还余料时
local BUNK_RIGHT_EMPTY_OUT = 420 -- 右出空舱,下降到第一层,滚筒外滚,供 AGV 到位后拉走空盘
local BUNK_RIGHT_SHIFT = 430 -- 右移盘架,转移一个托盘
local BUNK_RIGHT_FULL_CHECK = 440 -- 右侧满料舱,缓慢上台托盘并检测
local BUNK_RIGHT_EMPTY_STOP = 450 -- 右侧空盘舱,AGV拉出成功,滚筒停止
local BUNK_RIGHT_FULL_STOP = 460 -- 右侧满料舱,AGV拉出成功,滚筒停止
local BUNK_INIT = 500 -- 初始化动作, 两个滑块都移动到中间, 4个托盘架先全部下降到底,再慢慢上升,直到触发光电,再移动偏移量
local OIL_LEFT = 600 -- 左喷油盒,关盒子,喷油,并转动,然后开盒子
local OIL_RIGHT = 610 -- 右喷油盒,关盒子,喷油,并转动,然后开盒子
local Left_Check = 700 -- 左侧阀串视觉检测
local Right_Check = 710 -- 右侧阀串视觉检测

local WORK_COMPLETED = 1
local offset_rax1 = 0
local offset_rax2 = 0

--信号复位
function Init()
  SetDO("left_penyou_light",0)
  SetDO("left_scara_light",0)
  SetDO("right_penyou_light",0)
  SetDO("right_scara_light",0)
  SetDO("right_penyou",0)
  SetDO("left_penyou",0)
  SetDO("youtong_jiaya",0)
  SetDO("left_penyou_tuigan",1)
  SetDO("right_penyou_tuigan",1)
  SetDO("R_work_wancheng",0)
end

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
  for i=1,5,1 do
    retVal = SocketConnect(socketName,"192.168.105.231",3333,2000)
    if retVal == 1 then
      TPWrite(string.format("Socket connect successfully, server name: %s.", socketName))
      break
    else
      TPWrite(string.format("Socket connect failed, server name: %s.", socketName))
      Sleep(100)
    end
  end

--左侧scara外轨道视觉定位
function L_scara_vision()
  SetDO("left_scara_light",1)
  Sleep(1500)

  retVal = SocketSend(socketName, "000025#0111@0009&0004,0,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    return  --终止语句
  end
  
  retVal, receivedData = SocketReceive(socketName, 0, 30000)  --机器人接收数据
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    return
  end

  --TPWrite("Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割
  if list_str[3] == "#" then
    TPWrite("No checked!")  --没有检测到，跳出循环
    return
  end

  L_scara_offset = tonumber( list_str[3])

  Sleep(300)
  SetDO("left_scara_light",0)
end

--左侧scara内轨道视觉定位
function L_scara_inner_vision()
  SetDO("left_scara_light",1)
  Sleep(1500)

  retVal = SocketSend(socketName, "000025#0111@0009&0004,3,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    return  --终止语句
  end
  
  retVal, receivedData = SocketReceive(socketName, 0, 30000)  --机器人接收数据
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    return
  end

  --TPWrite("Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割
  if list_str[3] == "#" then
    TPWrite("No checked!")  --没有检测到，跳出循环
    return
  end

  L_inner_offset = tonumber( list_str[3])

  Sleep(300)
  SetDO("left_scara_light",0)
end

--右侧scara视觉定位
function R_scara_vision()
  SetDO("right_scara_light",1)
  Sleep(1000)

  retVal = SocketSend(socketName, "000025#0111@0009&0004,0,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    return  --终止语句
  end
  
  retVal, receivedData = SocketReceive(socketName, 0, 30000)  --机器人接收数据
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    return
  end

  TPWrite("Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割
  if list_str[3] == "0" then
    TPWrite("No checked!")  --没有检测到，跳出循环
    return
  end

  R_scara_offset = tonumber( list_str[1])
end

--左侧阀串视觉检测
function L_Fachuan_Check()
  SetDO("left_penyou_light",1)
  SetAO("Left_visionResult",0)
  Sleep(1500)

  retVal = SocketSend(socketName, "000025#0111@0009&0004,1,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    return  --终止语句
  end
  
  retVal, receivedData = SocketReceive(socketName, 0, 30000)
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    return
  end

  --TPWrite("L_Fachuan_Check Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割

  L_checkresult_1 = tonumber( list_str[3])
  L_checkresult_2 = tonumber( list_str[4])
  L_checkresult_3 = tonumber( list_str[5])
  L_checkresult_4 = tonumber( list_str[6])

  if L_checkresult_1 == 1 and L_checkresult_2 == 1 and L_checkresult_3 == 1 and L_checkresult_4 == 1 then
  	L_checkresult = 1
  else
  	L_checkresult = 2
  end
  TPWrite(L_checkresult)
  Sleep(100)
  SetAO("Left_visionResult",L_checkresult)
end

--右侧阀串视觉检测
function R_Fachuan_Check()
  SetDO("right_penyou_light",1)
  SetAO("Right_visionResult",0)
  Sleep(1500)

  retVal = SocketSend(socketName, "000025#0111@0009&0004,2,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    return  --终止语句
  end
  
  retVal, receivedData = SocketReceive(socketName, 0, 30000)  --机器人接收数��?
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    return
  end

  --TPWrite("R_Fachuan_Check Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割

  R_checkresult_1 = tonumber( list_str[3])
  R_checkresult_2 = tonumber( list_str[4])
  R_checkresult_3 = tonumber( list_str[5])
  R_checkresult_4 = tonumber( list_str[6])

  if R_checkresult_1 == 1 and R_checkresult_2 == 1 and R_checkresult_3 == 1 and R_checkresult_4 == 1 then
  	R_checkresult = 1
  else
  	R_checkresult = 2
  end
  TPWrite(R_checkresult)
  Sleep(100)
  SetAO("Right_visionResult",R_checkresult)
end

function Gohome()
  MoveAbsJ(K_home,v200,fine,tool0,wobj0,load0)
end

--左侧上料
function L_shangliao()
--  if GetDI("left_qian_roller_reached") == 0 and GetDI("left_qian_ShengJiang_reached") == 0 then
--    SetDO("left_feeder_qian_roller_in",1)
--    WaitDI("left_qian_roller_reached",1)
--    Sleep(2000)
--    if GetDI("left_qian_roller_reached") == 1 then
--      SetDO("left_feeder_qian_roller_in",0)
--      Sleep(500)
--    end
    local next = GetJointTarget("Xyzuvw")
    if GetAI("tray_in_left") == 5 then
      next.extax.eax_1 = K_L_5.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_in_left") == 4 then
      next.extax.eax_1 = K_L_4.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_in_left") == 3 then
      next.extax.eax_1 = K_L_3.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_in_left") == 2 then
      next.extax.eax_1 = K_L_2.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_in_left") == 1 then
      next.extax.eax_1 = K_L_1.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    end
--  end
end

function L_chuliao()

    local next = GetJointTarget("Xyzuvw")
    if GetAI("tray_out_left") == 4 then
      next.extax.eax_2 = K_L_5.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_out_left") == 3 then
      next.extax.eax_2 = K_L_4.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_out_left") == 2 then
      next.extax.eax_2 = K_L_3.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_out_left") == 1 then
      next.extax.eax_2 = K_L_2.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    elseif GetAI("tray_out_left") == 0 then
      next.extax.eax_2 = K_L_1.extax.eax_1
      MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
    end

end

--右侧上料
function R_shangliao()
  if GetDI("right_qian_roller_reached") == 0 and GetDI("right_qian_ShengJiang_reached") == 0 then
    SetDO("right_feeder_qian_roller_in",1)
    WaitDI("right_qian_roller_reached",1)
    Sleep(2000)
    if GetDI("right_qian_roller_reached") == 1 then
      SetDO("right_feeder_qian_roller_in",0)
      Sleep(500)
    end
    if GetAI("tray_in_right") == 5 then
      MoveAbsJ(K_R_5,v_op40,fine,tool0,wobj0,load0)
    end

    if GetAI("tray_in_right") == 4 then
      MoveAbsJ(K_R_4,v_op40,fine,tool0,wobj0,load0)
    end

    if GetAI("tray_in_right") == 3 then
      MoveAbsJ(K_R_3,v_op40,fine,tool0,wobj0,load0)
    end

    if GetAI("tray_in_right") == 2 then
      MoveAbsJ(K_R_2,v_op40,fine,tool0,wobj0,load0)
    end

    if GetAI("tray_in_right") == 1 then
      MoveAbsJ(K_R_1,v_op40,fine,tool0,wobj0,load0)
    end
  end
end

local TRAY_IN_LEFT_CANT_SHIFT = 1
local TRAY_OUT_LEFT_CANT_SHIFT = 2
local TRAY_LEFT_SUM_NOT_5 = 3
function fun_BUNK_LEFT_INIT()
    --初始化时,进料舱层数 1-5 
    while( GetAI("tray_in_left")<1 or GetAI("tray_in_left")>5 )
    do
      SetAO("Error_code",TRAY_IN_LEFT_CANT_SHIFT)
      TPWrite("TRAY_IN_LEFT_CANT_SHIFT")      
      Sleep(100)
      Stop()
    end
    
    --出料舱 0-4 
    while( GetAI("tray_out_left")>=5 )
    do
      SetAO("Error_code",TRAY_OUT_LEFT_CANT_SHIFT)
      TPWrite("TRAY_OUT_LEFT_CANT_SHIFT")      
      Sleep(100)
      Stop()
    end
    
    --两舱和不是5
    while( (GetAI("tray_in_left")+GetAI("tray_out_left"))~=5 )
    do
      SetAO("Error_code",TRAY_LEFT_SUM_NOT_5)
      TPWrite("TRAY_LEFT_SUM_NOT_5")      
      Sleep(100)
      Stop()
    end
    
    --上料舱,位置到位
    local next = GetJointTarget("Xyzuvw")
    next.extax.eax_1 = K_L_1.extax.eax_1 - 115* (GetAI("tray_in_left")-1)
    --下料舱,位置到位
    next.extax.eax_2 = K_L_1.extax.eax_1 - 115* (GetAI("tray_out_left")+1)
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
end

local TRAY_IN_RIGHT_CANT_SHIFT = 4
local TRAY_OUT_RIGHT_CANT_SHIFT = 5
local TRAY_RIGHT_SUM_NOT_5 = 6
function fun_BUNK_RIGHT_INIT()
    --初始化时,进料舱层数 1-5 
    while( GetAI("tray_in_right")<1 or GetAI("tray_in_right")>5 )
    do
      SetAO("Error_code",TRAY_IN_RIGHT_CANT_SHIFT)
      TPWrite("TRAY_IN_RIGHT_CANT_SHIFT")      
      Sleep(100)
      Stop()
    end
    
    --出料舱 0-4 
    while( GetAI("tray_out_right")>=5 )
    do
      SetAO("Error_code",TRAY_OUT_RIGHT_CANT_SHIFT)
      TPWrite("TRAY_OUT_RIGHT_CANT_SHIFT")      
      Sleep(100)
      Stop()
    end
    
    --两舱和不是5
    while( (GetAI("tray_in_right")+GetAI("tray_out_right"))~=5 )
    do
      SetAO("Error_code",TRAY_RIGHT_SUM_NOT_5)
      TPWrite("TRAY_RIGHT_SUM_NOT_5")      
      Sleep(100)
      Stop()
    end
    
    --上料舱,位置到位
    local next = GetJointTarget("Xyzuvw")
    next.extax.eax_3 = K_R_1.extax.eax_1 - 115* (GetAI("tray_in_right")-1)
    --下料舱,位置到位
    next.extax.eax_4 = K_R_1.extax.eax_1 - 115* (GetAI("tray_out_right")+1)
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
end


--左侧 料盘平移
function fun_BUNK_LEFT_SHIFT()

    --料舱爪子,张开
    SetDO("left_feeder_ZhuaPanZhao",0)
    WaitDI("left_ZhuaPanZhao1_open",1)
    WaitDI("left_ZhuaPanZhao2_open",1)
    
    fun_BUNK_LEFT_INIT()    
    
    --料舱横移,到上侧
    local next = GetJointTarget("Xyzuvw")
    next.robax.rax_3 = K_xialiao_zhuaqu.robax.rax_3
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)  
    
    --料舱爪子,合拢
    SetDO("left_feeder_ZhuaPanZhao",1)
    WaitDI("left_ZhuaPanZhao1_close",1)
    WaitDI("left_ZhuaPanZhao2_close",1)
    
    --上料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_1 = next.extax.eax_1 - 115
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)  
    
    --料舱横移,到下侧
    next = GetJointTarget("Xyzuvw")
    next.robax.rax_3 = K_xialiao_wait.robax.rax_3
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
    
    --下料舱,位置上升
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = next.extax.eax_2 + 115
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
    
    --料舱爪子,张开
    SetDO("left_feeder_ZhuaPanZhao",0)
    WaitDI("left_ZhuaPanZhao1_open",1)
    WaitDI("left_ZhuaPanZhao2_open",1)
      
    --下料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = next.extax.eax_2 - 115
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
end

--右侧 料盘平移
function fun_BUNK_RIGHT_SHIFT()

    --料舱爪子,张开
    SetDO("right_feeder_ZhuaPanZhao",0)
    WaitDI("right_ZhuaPanZhao1_open",1)
    WaitDI("right_ZhuaPanZhao2_open",1)
    
    fun_BUNK_LEFT_INIT()    
    
    --料舱横移,到上侧
    local next = GetJointTarget("Xyzuvw")
    next.robax.rax_4 = K_xialiao_zhuaqu.robax.rax_3
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)  
    
    --料舱爪子,合拢
    SetDO("right_feeder_ZhuaPanZhao",1)
    WaitDI("right_ZhuaPanZhao1_close",1)
    WaitDI("right_ZhuaPanZhao2_close",1)
    
    --上料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_3 = next.extax.eax_3 - 115
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)  
    
    --料舱横移,到下侧
    next = GetJointTarget("Xyzuvw")
    next.robax.rax_4 = K_xialiao_wait.robax.rax_3
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
    
    --下料舱,位置上升
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_4 = next.extax.eax_4 + 115
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
    
    --料舱爪子,张开
    SetDO("right_feeder_ZhuaPanZhao",0)
    WaitDI("right_ZhuaPanZhao1_open",1)
    WaitDI("right_ZhuaPanZhao2_open",1)
      
    --下料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_4 = next.extax.eax_4 - 115
    MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
end

--右侧下料
function R_xialiao()
  if GetDI("right_ZhuaPanZhao1_open") == 1 and GetDI("right_ZhuaPanZhao2_open") == 1 then
    
    SetDO("right_feeder_ZhuaPanZhao",1)
    WaitDI("right_ZhuaPanZhao1_close",1)
    WaitDI("right_ZhuaPanZhao2_close",1)
    
    Sleep(1000)
    if GetDI("right_hou_roller_reached") ==1 and GetDI("right_hou_ShengJiang_reached") ==1 then
      SetDO("right_feeder_ZhuaPanZhao",0)
      WaitDI("right_ZhuaPanZhao1_open",0)
      WaitDI("right_ZhuaPanZhao2_open",0)
      
    end
  end
end

function main()
  while(1) do
    if GetAI("request") == 1 then
      SetAO("response",1)
      L_shangliao()
      SetAO("response",1)
    end
  
    if GetAI("request") == 1 then
      L_xialiao()
    end
  
    if GetAI("request") == 1 then
      R_shangliao()
    end
  
    if GetAI("request") == 1 then
      R_xialiao()
    end
  
    if GetAI("request") == 1 then
      L_Fachuan_Check()
    end
  
    if GetAI("request") == 1 then
      R_Fachuan_Check()
    end
  end
end

function fun_OUTER_TO_CENTER()
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = outer_left.robax.rax_1
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
  SetDO("qian_HengYi_gripper",0)
  WaitDI("qian_HengYi_gripper_open",1)

  SetDO("R_work_wancheng",1)
  SetDO("left_scara_light",0)
  SetDO("left_penyou_light",0)
  SetDO("right_scara_light",0)
  SetDO("right_penyou_light",0)
end

function fun_OUTER_TO_LEFT()
  SetDO("R_work_wancheng",0)
  WaitDI("qian_HengYi_youliao",1)
  SetDO("qian_HengYi_gripper",1)
  WaitDI("qian_HengYi_gripper_open",0)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = outer_left.robax.rax_1 - offset_rax1
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
end

function fun_OUTER_TO_ONLY_LEFT()
  SetDO("qian_HengYi_gripper",1)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = outer_left.robax.rax_1
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
end

function fun_OUTER_TO_RIGHT()
  WaitDI("qian_HengYi_youliao",1)
  SetDO("qian_HengYi_gripper",1)
  WaitDI("qian_HengYi_gripper_open",0)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = outer_right.robax.rax_1 - offset_rax1
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
  --SetDO("right_scara_light",1)
  --Sleep(1000)
  --SetDO("right_scara_light",0)
end

function fun_INNER_TO_CENTER()
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_2 = inner_center.robax.rax_2
  next.robax.rax_1 = outer_left.robax.rax_1
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
  SetDO("hou_HengYi_gripper",0)
  WaitDI("hou_HengYi_gripper_open",1)

  SetDO("In_workover",1)
  SetDO("left_scara_light",0)
  SetDO("left_penyou_light",0)
  SetDO("right_scara_light",0)
  SetDO("right_penyou_light",0)
end

function fun_INNER_TO_LEFT()
  SetDO("In_workover",0)
  WaitDI("hou_HengYi_youliao",1)
  SetDO("hou_HengYi_gripper",1)
  WaitDI("hou_HengYi_gripper_open",0)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_2 = inner_left.robax.rax_2 - offset_rax2
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
end

function fun_INNER_TO_ONLY_LEFT()
  SetDO("hou_HengYi_gripper",1)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_2 = inner_left.robax.rax_2
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
end

function fun_INNER_TO_ONLY_CENTER()
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_2 = inner_center.robax.rax_2
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
end

function fun_INNER_TO_RIGHT()
  WaitDI("hou_HengYi_youliao",1)
  SetDO("hou_HengYi_gripper",1)
  WaitDI("hou_HengYi_gripper_open",0)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_2 = inner_right.robax.rax_2 - offset_rax2
  MoveAbsJ(next,v_hengyi,fine,tool0,wobj0,load0)
end

function fun_BUNK_LEFT_FULL_IN()
  WaitDI("left_qian_roller_reached",0)
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_1 = K_L_bottom.extax.eax_1
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)  
  SetDO("left_feeder_qian_roller_in",1)
  WaitDI("left_qian_roller_reached",1)
  SetDO("left_feeder_qian_roller_in",0)
  next.extax.eax_1 = K_L_5.extax.eax_1
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
end

function fun_BUNK_LEFT_FULL_OUT()
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_1 = K_L_bottom.extax.eax_1
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
  SetDO("left_feeder_qian_roller_out",1)
  Sleep(5000)
  SetDO("left_feeder_qian_roller_out",0)
end

function fun_BUNK_LEFT_EMPTY_OUT()
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_2 = K_L_bottom.extax.eax_2
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
  SetDO("left_feeder_hou_roller_out",1)
  Sleep(5000)
  SetDO("left_feeder_hou_roller_out",0)
end

function fun_BUNK_RIGHT_FULL_IN()
  WaitDI("right_qian_roller_reached",0)
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_3 = K_R_bottom.extax.eax_3
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)  
  SetDO("right_feeder_qian_roller_in",1)
  WaitDI("right_qian_roller_reached",1)
  SetDO("right_feeder_qian_roller_in",0)
  next.extax.eax_3 = K_R_5.extax.eax_3
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
end

function fun_BUNK_RIGHT_FULL_OUT()
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_3 = K_R_bottom.extax.eax_3
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
  SetDO("right_feeder_qian_roller_out",1)
  Sleep(5000)
  SetDO("right_feeder_qian_roller_out",0)
end

function fun_BUNK_RIGHT_EMPTY_OUT()
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_4 = K_R_bottom.extax.eax_4
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0) 
  SetDO("right_feeder_hou_roller_out",1)
  Sleep(5000)
  SetDO("right_feeder_hou_roller_out",0)
end

function fun_OIL_LEFT()
  --SetDO("youtong_jiaya",1)
  SetDO("left_penyou_tuigan",0)
  WaitDI("left_penyou_tuigan_opened",0)
  WaitDI("left_penyou_tuigan_closed",1)

  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = left_penyou_start.robax.rax_5
  MoveAbsJ(next,v80_1,fine,tool0,wobj0,load0)
  --SetDO("left_penyou",1)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = left_penyou_stop.robax.rax_5
  MoveAbsJ(next,v80_1,fine,tool0,wobj0,load0)
  SetDO("left_penyou",0) 
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = left_penyou_start.robax.rax_5
  MoveAbsJ(next,v80_1,fine,tool0,wobj0,load0)
  SetDO("left_penyou_tuigan",1)
  WaitDI("left_penyou_tuigan_opened",1)
  WaitDI("left_penyou_tuigan_closed",0)
  SetDO("youtong_jiaya",0)
end

function fun_OIL_RIGHT()
  --SetDO("youtong_jiaya",1)
  SetDO("right_penyou_tuigan",0)
  WaitDI("right_penyou_tuigan_opened",0)
  WaitDI("right_penyou_tuigan_closed",1)

  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_6 = right_penyou_start.robax.rax_6
  MoveAbsJ(next,v80_1,fine,tool0,wobj0,load0)
  --SetDO("right_penyou",1)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_6 = right_penyou_stop.robax.rax_6
  MoveAbsJ(next,v80_1,fine,tool0,wobj0,load0)  
  SetDO("right_penyou",0)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_6 = right_penyou_start.robax.rax_6
  MoveAbsJ(next,v80_1,fine,tool0,wobj0,load0) 
  SetDO("right_penyou_tuigan",1)
  WaitDI("right_penyou_tuigan_opened",1)
  WaitDI("right_penyou_tuigan_closed",0) 
  SetDO("youtong_jiaya",0)  
end

--外轨道左侧视觉定位
function fun_OUTER_LEFT_POSITION()
  L_scara_vision()
  Sleep(200)
  offset_rax1 = L_scara_offset - 871.415
  TPWrite("offset_rax1",offset_rax1)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = outer_left.robax.rax_1 - offset_rax1
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
end

--内轨道左侧视觉定位
function fun_INNER_LEFT_POSITION()
  L_scara_inner_vision()
  Sleep(200)
  offset_rax2 = L_inner_offset - 667.973
  TPWrite("offset_rax2",offset_rax2)
  local next = GetJointTarget("Xyzuvw")
  next.robax.rax_2 = inner_left.robax.rax_2 - offset_rax2
  MoveAbsJ(next,v_op40,fine,tool0,wobj0,load0)
end

function main2()
  while(1) do
    if GetAI("request")==OUTER_TO_CENTER then 
      SetAO("response",OUTER_TO_CENTER) 
      fun_OUTER_TO_CENTER()
      SetAO("response",OUTER_TO_CENTER+1)
      --SetAO("status",WORK_COMPLETED) 
    elseif GetAI("request")==OUTER_TO_LEFT then 
      SetAO("response",OUTER_TO_LEFT) 
      fun_OUTER_TO_LEFT()
      SetAO("response",OUTER_TO_LEFT+1) 
    elseif GetAI("request")==OUTER_TO_ONLY_LEFT then 
      SetAO("response",OUTER_TO_ONLY_LEFT) 
      fun_OUTER_TO_ONLY_LEFT()
      SetAO("response",OUTER_TO_ONLY_LEFT+1) 
    elseif GetAI("request")==OUTER_TO_RIGHT then 
      SetAO("response",OUTER_TO_RIGHT) 
      fun_OUTER_TO_RIGHT()
      SetAO("response",OUTER_TO_RIGHT+1) 
    elseif GetAI("request")==OUTER_LEFT_POSITION then
      SetAO("response",OUTER_LEFT_POSITION) 
      fun_OUTER_LEFT_POSITION()
      SetAO("response",OUTER_LEFT_POSITION+1)
    elseif GetAI("request")==INNER_TO_CENTER then 
      SetAO("response",INNER_TO_CENTER) 
      fun_INNER_TO_CENTER()
      SetAO("response",INNER_TO_CENTER+1) 
    elseif GetAI("request")==INNER_TO_LEFT then 
      SetAO("response",INNER_TO_LEFT) 
      fun_INNER_TO_LEFT()
      SetAO("response",INNER_TO_LEFT+1) 
    elseif GetAI("request")==INNER_TO_ONLY_LEFT then 
      SetAO("response",INNER_TO_ONLY_LEFT) 
      fun_INNER_TO_ONLY_LEFT()
      SetAO("response",INNER_TO_ONLY_LEFT+1)
    elseif GetAI("request")==INNER_TO_ONLY_CENTER then 
      SetAO("response",INNER_TO_ONLY_CENTER) 
      fun_INNER_TO_ONLY_CENTER()
      SetAO("response",INNER_TO_ONLY_CENTER+1)
    elseif GetAI("request")==INNER_TO_RIGHT then 
      SetAO("response",INNER_TO_RIGHT) 
      fun_INNER_TO_RIGHT()
      SetAO("response",INNER_TO_RIGHT+1) 
    elseif GetAI("request")==INNER_LEFT_POSITION then
      SetAO("response",INNER_LEFT_POSITION) 
      fun_INNER_LEFT_POSITION()
      SetAO("response",INNER_LEFT_POSITION+1)
    elseif GetAI("request")==BUNK_LEFT_FULL_IN then 
      SetAO("response",BUNK_LEFT_FULL_IN) 
      fun_BUNK_LEFT_FULL_IN()
      SetAO("response",BUNK_LEFT_FULL_IN+1) 
    elseif GetAI("request")==BUNK_LEFT_FULL_OUT then 
      SetAO("response",BUNK_LEFT_FULL_OUT) 
      fun_BUNK_LEFT_FULL_OUT()
      SetAO("response",BUNK_LEFT_FULL_OUT+1) 
    elseif GetAI("request")==BUNK_LEFT_EMPTY_OUT then 
      SetAO("response",BUNK_LEFT_EMPTY_OUT) 
      fun_BUNK_LEFT_EMPTY_OUT()
      SetAO("response",BUNK_LEFT_EMPTY_OUT+1) 
    elseif GetAI("request")==BUNK_LEFT_SHIFT then 
      SetAO("response",BUNK_LEFT_SHIFT) 
      fun_BUNK_LEFT_SHIFT()
      SetAO("response",BUNK_LEFT_SHIFT+1) 
    elseif GetAI("request")==BUNK_LEFT_FULL_CHECK then 
      SetAO("response",BUNK_LEFT_FULL_CHECK)
      fun_BUNK_LEFT_INIT()
      SetAO("response",BUNK_LEFT_FULL_CHECK+1) 
    elseif GetAI("request")==BUNK_LEFT_EMPTY_STOP then 
      SetAO("response",BUNK_LEFT_EMPTY_STOP) 
      Sleep(response_sleep) 
      SetAO("response",BUNK_LEFT_EMPTY_STOP+1) 
    elseif GetAI("request")==BUNK_LEFT_FULL_STOP then 
      SetAO("response",BUNK_LEFT_FULL_STOP) 
      Sleep(response_sleep) 
      SetAO("response",BUNK_LEFT_FULL_STOP+1) 
    elseif GetAI("request")==BUNK_RIGHT_FULL_IN then 
      SetAO("response",BUNK_RIGHT_FULL_IN) 
      fun_BUNK_RIGHT_FULL_IN()
      SetAO("response",BUNK_RIGHT_FULL_IN+1) 
    elseif GetAI("request")==BUNK_RIGHT_FULL_OUT then 
      SetAO("response",BUNK_RIGHT_FULL_OUT) 
      fun_BUNK_RIGHT_FULL_OUT()
      SetAO("response",BUNK_RIGHT_FULL_OUT+1) 
    elseif GetAI("request")==BUNK_RIGHT_EMPTY_OUT then 
      SetAO("response",BUNK_RIGHT_EMPTY_OUT) 
      fun_BUNK_RIGHT_EMPTY_OUT()
      SetAO("response",BUNK_RIGHT_EMPTY_OUT+1) 
    elseif GetAI("request")==BUNK_RIGHT_SHIFT then 
      SetAO("response",BUNK_RIGHT_SHIFT) 
      fun_BUNK_RIGHT_SHIFT()
      SetAO("response",BUNK_RIGHT_SHIFT+1) 
    elseif GetAI("request")==BUNK_RIGHT_FULL_CHECK then 
      SetAO("response",BUNK_RIGHT_FULL_CHECK) 
       fun_BUNK_RIGHT_INIT()
      SetAO("response",BUNK_RIGHT_FULL_CHECK+1) 
    elseif GetAI("request")==BUNK_RIGHT_EMPTY_STOP then 
      SetAO("response",BUNK_RIGHT_EMPTY_STOP) 
      Sleep(response_sleep) 
      SetAO("response",BUNK_RIGHT_EMPTY_STOP+1) 
    elseif GetAI("request")==BUNK_RIGHT_FULL_STOP then 
      SetAO("response",BUNK_RIGHT_FULL_STOP) 
      Sleep(response_sleep) 
      SetAO("response",BUNK_RIGHT_FULL_STOP+1) 
    elseif GetAI("request")==BUNK_INIT then 
      SetAO("response",BUNK_INIT) 
      fun_BUNK_LEFT_INIT()
      fun_BUNK_RIGHT_INIT()
      etAO("response",BUNK_INIT+1) 
    elseif GetAI("request")==OIL_LEFT then 
      SetAO("response",OIL_LEFT) 
      fun_OIL_LEFT()
      SetAO("response",OIL_LEFT+1) 
    elseif GetAI("request")==OIL_RIGHT then 
      SetAO("response",OIL_RIGHT) 
      fun_OIL_RIGHT()
      SetAO("response",OIL_RIGHT+1)
    elseif GetAI("request")==Left_Check then 
      SetAO("response",Left_Check) 
      L_Fachuan_Check()
      SetAO("response",Left_Check+1)
    elseif GetAI("request")==Right_Check then 
      SetAO("response",Right_Check) 
      R_Fachuan_Check()
      SetAO("response",Right_Check+1) 
    elseif GetAI("request")==0 then 
      Sleep(800)
    SetAO("response",0)
    end    
    Sleep(200)
  end
end

Init()
--Gohome()
main2()

local function GLOBALDATA_DEFINE()
LOADDATA("load2",2.00,{0.00,0.00,100.00},{1.000000,0.000000,0.000000,0.000000},0.00,0.00,0.00,0.00,0.00,0.01)
SPEEDDATA("SpdUser",200.000,50.000,200.000,50.000)
JOINTTARGET("Feng",{380.000,380.000,42.000,42.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Fengge",{380.000,250.000,42.000,42.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Home1",{89.999,-85.001,-0.001,-8.001,-2.001,-79.999,0.000},{50.062,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K10",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{860.000,380.000,0.000,0.000,0.000,0.001,0.000},{693.600,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K30",{697.542,45.789,0.000,0.000,0.001,0.003,0.000},{693.596,269.999,693.598,311.528,0.000,0.000,0.000})
JOINTTARGET("K40",{0.000,380.000,0.000,0.000,0.001,0.002,0.000},{693.598,269.999,693.598,311.528,0.000,0.000,0.000})
JOINTTARGET("K50",{380.000,380.000,0.000,0.000,0.001,0.002,0.000},{693.597,269.999,693.598,311.528,0.000,0.000,0.000})
JOINTTARGET("K_L_1",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{698.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_L_2",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{583.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_L_3",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{468.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_L_4",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{353.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_L_5",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{238.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_L_bottom",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_R_1",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{698.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_R_2",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{583.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_R_3",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{468.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_R_4",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{353.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_R_5",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{238.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_R_bottom",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_home",{380.000,250.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_shangliao_down",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_shangliao_up",{380.000,380.000,0.000,0.000,0.001,0.002,0.000},{693.598,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_xialiao_down",{380.000,380.000,42.629,0.000,0.000,0.001,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_xialiao_out",{380.000,380.000,760.740,0.000,0.000,0.001,0.000},{400.000,400.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_xialiao_up",{380.000,380.000,42.629,0.000,0.000,0.001,0.000},{0.000,693.545,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_xialiao_wait",{380.000,380.000,42.629,0.000,0.000,0.001,0.000},{0.000,400.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K_xialiao_zhuaqu",{380.000,380.000,760.740,0.000,0.000,0.001,0.000},{693.595,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("VisionPos",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("ZFeng",{860.000,250.000,42.000,42.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("ZFeng_in",{860.000,250.000,42.000,42.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("ZFeng_out",{860.000,250.000,42.000,42.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("inner_center",{380.000,250.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("inner_left",{380.000,689.200,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("inner_right",{380.000,192.660,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("left_penyou_start",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("left_penyou_stop",{380.000,380.000,0.000,0.000,20.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("outer_center",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("outer_left",{860.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("outer_right",{0.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("right_penyou_start",{380.000,380.000,0.000,0.000,0.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("right_penyou_stop",{380.000,380.000,0.000,0.000,0.000,20.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
STRINGDATA("received","")
STRINGDATA("send","")
end
print("The end!")