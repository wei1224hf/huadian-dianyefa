
require "SocketApi"
local socketName = "sock"
local retVal = false
local receivedData = nil
local VisionDate_init = 69.3192          --视觉模板值
local FaTi_Kind = 0
--local Truss_x = 0                             --横移气缸纠偏变量
local TRAY_IN_NUMBER = 1
local TRAY_OUT_NUMBER = 2
local TRAY_SUM_NOT_5 = 3
local next = GetJointTarget("Xyzuvw")
local TRAY_HEIGHT = 127

SimInput("DI_Error_Fuwei",true)
SetDI("DI_Error_Fuwei",0)
SetDI("DI_Error_Fuwei",1)
SetDI("DI_Error_Fuwei",0)
SimInput("DI_Error_Fuwei",false)

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
  retVal = SocketConnect(socketName,"192.168.105.231",3344,2000)
  if retVal == 1 then
    TPWrite(string.format("Socket connect successfully, server name: %s.", socketName))
    break
  else
    TPWrite(string.format("Socket connect failed, server name: %s.", socketName))
    SetDO("DO_FengLiao",1)
    SetAO("DO_HuangDeng",1)
    SetAO("error_code",8)
    Stop()
  end
end

-- 定义一个枚举表  
local RequestEnum = {  
    MOVE_TO_3_AXIS_SCREW_POSITION = 1,  -- 请求执行 3轴桁架螺丝口定位
    FEED_TRAY_FORK_IN = 2,              -- 请求执行 进料盘 叉入动作
    EXIT_TRAY_FORK_OUT = 3,             -- 请求执行 出口盘 叉出动作
    FEED_TRAY_FORK_OUT = 4,             -- 请求执行 进料盘 叉出动作
    MOVE_2_AXIS_TO_PILOT_VALVE = 5,     -- 请求执行 2轴桁架给先导阀顶螺丝 动作
    SCREW_ON_VALVE_BODY = 6,            -- 请求执行 阀体上打螺丝
    INITIALIZE_STATE = 7,               -- 请求执行 初始化状态
    CHANGE_FEED_TRAY = 8,               -- 请求执行 进料盘换盘
    M5_chuiru = 9,                      -- 请求执行 M5螺丝吹入
    DLS_HengYi_position = 10,           -- 请求执行 横移气缸移动到打螺丝位置
    FaTi_home = 11,                     -- 请求执行 阀体回原，打开气缸，work_over置1
    Da_LS_CLS = 12,                     -- 请求执行 打螺丝和吹螺丝同步执行
    Tuopan_Self_Test = 13,              -- 请求执行 开机托盘层数自检,有托盘为1，呼叫AGV卸料，无托盘0，呼叫AGV送料
}  

--判断阀体种类
function Judeg_FaTi_Kind()
  FaTi_Kind = GetAI("request_vision")
end

function FaTi_home()
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = OP90_Home.robax.rax_1
  next.robax.rax_2 = OP90_Home.robax.rax_2
  next.robax.rax_3 = OP90_Home.robax.rax_3
  next.robax.rax_4 = OP90_Home.robax.rax_4
  next.robax.rax_5 = OP90_Home.robax.rax_5
  next.robax.rax_6 = OP90_Home.robax.rax_6
  next.extax.eax_1 = OP90_Home.extax.eax_1
  next.extax.eax_3 = OP90_Home.extax.eax_3
  TPWrite(next)
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_HengYi_JiaJin",0)
  SetDO("DO_HengYi_SongKai",1)
  SetDO("work_over",1)
end

--螺丝枪打螺丝DO信号
function LuoSiQiangDaKong_1()
  SetDO("DO_NJQ_PiTouDingWei",1)
  Sleep(500)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  Sleep(1000)
  SetDO("DO_NJQ_PiTouDingWei",0)
  SetAO("screw_run",0)
  Sleep(500) 
  SetAO("screw_run",1)
  Sleep(1500)
  while (1) do
		if GetAI("screw_status") == 1 then
			Sleep(200)
      SetAO("screw_run",0)
		  break
		elseif GetAI("screw_status") == 3 then
      Sleep(500)
			SetAO("screw_run",0)
      SetAO("screw_reset",1)
      Sleep(2500)
      SetAO("screw_reset",0)
      Sleep(1000)
      SetAO("error_code",14)
      break
		end
  end
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  Sleep(2000)
  while (1) do
    Sleep(200)
    if GetDI("DI_LuoSiQiang_shangshen") == 0 then
      TPWrite("DI_LuoSiQiang_shangshen_shibai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",1)
      Stop()
    elseif GetDO("DI_LuoSiQiang_shangshen") == 1 then
      break
    end
  end
  Sleep(200)
end

--螺丝枪和吹螺丝DO信号合并
function LUOSI_M5()
  SetDO("DO_M5_LuoSi_Geli",1)
  while (1) do
    Sleep(200)
    if GetDI("DI_M5_LuoSi_Geli_guanbi") == 0 then
      TPWrite("M5_LuoSi_Geli_shibai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",2)
      Stop()
    elseif GetDI("DI_M5_LuoSi_Geli_guanbi") == 1 then
      break
    end
  end
  SetDO("DO_NJQ_PiTouDingWei",1)
  Sleep(500)
  SetDO("DO_M5_LuoSi_Geli",0)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  SetDO("DO_M5_LuoSi_Chuiru",1)
  Sleep(1000)
  SetDO("DO_NJQ_PiTouDingWei",0)
  SetAO("screw_run",0)
  Sleep(500) 
  SetAO("screw_run",1)
  Sleep(1500)
  SetDO("DO_M5_LuoSi_Chuiru",0)
  while (1) do
		if GetAI("screw_status") == 1 then
			Sleep(200)
      SetAO("screw_run",0)
		  break
		elseif GetAI("screw_status") == 3 then
      Sleep(500)
			SetAO("screw_run",0)
      SetAO("screw_reset",1)
      Sleep(2500)
      SetAO("screw_reset",0)
      SetAO("error_code",14)
      Sleep(1000)
      break
		end
  end
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  Sleep(2000)
  while (1) do
    Sleep(200)
    if GetDI("DI_LuoSiQiang_shangshen") == 0 then
      TPWrite("DI_LuoSiQiang_shangshen_shibai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",1)
      Stop()
    elseif GetDO("DI_LuoSiQiang_shangshen") == 1 then
      break
    end
  end
  Sleep(200)
end

--螺丝枪只打打螺丝函数
function Da_LS()
  --螺丝打孔1
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_1.robax.rax_1
  next.robax.rax_2 = LSK_1.robax.rax_2
  next.robax.rax_3 = LSK_1.robax.rax_3
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  LuoSiQiangDaKong_1()

  --螺丝打孔3
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_3.robax.rax_1
  next.robax.rax_2 = LSK_3.robax.rax_2
  next.robax.rax_3 = LSK_3.robax.rax_3
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  LuoSiQiangDaKong_1()

  --螺丝打孔2
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_2.robax.rax_1
  next.robax.rax_2 = LSK_2.robax.rax_2
  next.robax.rax_3 = LSK_2.robax.rax_3
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  LuoSiQiangDaKong_1()

  --螺丝打孔4
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_4.robax.rax_1
  next.robax.rax_2 = LSK_4.robax.rax_2
  next.robax.rax_3 = LSK_4.robax.rax_3
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  LuoSiQiangDaKong_1()
  SetDO("DO_NJQ_PiTouDingWei",0)
  --回到原点
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSQ_home.robax.rax_1
  next.robax.rax_2 = LSQ_home.robax.rax_2
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
end

--螺丝枪打螺丝+吹螺丝函数
function Da_LS_CLS()
  --螺丝打孔1
  SetDO("DO_M5_TouLiao",1)
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_1.robax.rax_1
  next.robax.rax_2 = LSK_1.robax.rax_2
  next.robax.rax_3 = LSK_1.robax.rax_3
  next.robax.rax_5 = M5_1.robax.rax_5
  next.robax.rax_6 = M5_1.robax.rax_6
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  LUOSI_M5()

  --螺丝打孔3
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_3.robax.rax_1
  next.robax.rax_2 = LSK_3.robax.rax_2
  next.robax.rax_3 = LSK_3.robax.rax_3
  next.robax.rax_5 = M5_2.robax.rax_5
  next.robax.rax_6 = M5_2.robax.rax_6
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  LUOSI_M5()

  --螺丝打孔2
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_2.robax.rax_1
  next.robax.rax_2 = LSK_2.robax.rax_2
  next.robax.rax_3 = LSK_2.robax.rax_3
  next.robax.rax_5 = M5_3.robax.rax_5
  next.robax.rax_6 = M5_3.robax.rax_6
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  LUOSI_M5()

  --螺丝打孔4
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSK_4.robax.rax_1
  next.robax.rax_2 = LSK_4.robax.rax_2
  next.robax.rax_3 = LSK_4.robax.rax_3
  next.robax.rax_5 = M5_4.robax.rax_5
  next.robax.rax_6 = M5_4.robax.rax_6
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  LUOSI_M5()
  SetDO("DO_NJQ_PiTouDingWei",0)
  --回到原点
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = LSQ_home.robax.rax_1
  next.robax.rax_2 = LSQ_home.robax.rax_2
  next.robax.rax_5 = FenLi_home.robax.rax_5
  next.robax.rax_6 = FenLi_home.robax.rax_6
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
end

function LuoSi_Chuiru()
  SetDO("DO_M5_LuoSi_Geli",1)
  Sleep(500)
  while (1) do
    Sleep(200)
    if GetDI("DI_M5_LuoSi_Geli_guanbi") == 0 then
      TPWrite("M5_LuoSi_Geli_shibai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",2)
      Stop()
    elseif GetDI("DI_M5_LuoSi_Geli_guanbi") == 1 then
      break
    end
  end
  Sleep(200)
  SetDO("DO_M5_LuoSi_Geli",0)
  Sleep(200)
  SetDO("DO_M5_LuoSi_Chuiru",1)
  Sleep(2000)
  SetDO("DO_M5_LuoSi_Chuiru",0)
  Sleep(1000)
end

--初始化信号位置
function Init()
    --螺丝枪收回
    SetDO("DO_NJQ_ShenChu",0)
    SetDO("DO_NJQ_SuoHui",1)
    --横移气缸夹爪松开
    SetDO("DO_HengYi_JiaJin",0)
    SetDO("DO_HengYi_SongKai",1)
    --横移顶升气缸收回
    SetDO("DO_HengYi_ShangShen",0)
    SetDO("DO_HengYi_XiaJiang",1)
    --送料机抓盘抓松开
    SetDO("DO_ZhuaPan_GuanBi",0)
    SetDO("DO_ZhuaPan_DaKai",1)
    --蜂鸣器复位
    -- SetDO("DO_FengLiao",0)
    SetDO("DO_HongDeng",0)
    --偏移位置对比状态置0
    SetDO("Md_home",0)
    --AO错误报警置0
    SetAO("error_code",0)
end

function Gohome()
  Init()
  -- SetDO("work_over",0)
  --横移气缸回到原点
  MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
end

--横移气缸拍照纠偏
function HengYi_Vision()
  if GetDI("DI_HengYi_YouLiao") == 1 then
    SetDO("DO_HengYi_JiaJin",1)
    SetDO("DO_HengYi_SongKai",0)
  end
  --3轴螺丝枪桁架移动到拍照点位
  SetDO("DO_GangYuan_XYZ",1)
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = HengYi_Paizhao.robax.rax_1
  next.robax.rax_2 = HengYi_Paizhao.robax.rax_2
  next.robax.rax_3 = HengYi_Paizhao.robax.rax_3
  next.robax.rax_4 = HengYi_Paizhao.robax.rax_4
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  Sleep(200)
  --阀体拍照检测
  retVal = SocketSend(socketName, "000025#0111@0009&0004,0,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    next = GetJointTarget("Xyzuvw")
    next.robax.rax_1 = OP90_Home.robax.rax_1
    next.robax.rax_2 = OP90_Home.robax.rax_2
    next.robax.rax_3 = OP90_Home.robax.rax_3
    MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
    Stop()
  end
  
  retVal, receivedData = SocketReceive(socketName, 0, 30000)  --机器人接收数据
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    SetDO("DO_FengLiao",1)
    SetAO("DO_HuangDeng",1)
    next = GetJointTarget("Xyzuvw")
    next.robax.rax_1 = OP90_Home.robax.rax_1
    next.robax.rax_2 = OP90_Home.robax.rax_2
    next.robax.rax_3 = OP90_Home.robax.rax_3
    MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
    Stop()
  end

  TPWrite("Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割
  if list_str[1] == "0" then
    TPWrite("No checked!")  --没有检测到，跳出循环
    SetDO("DO_FengLiao",1)
    SetAO("DO_HuangDeng",1)
    SetAO("error_code",13)
    next = GetJointTarget("Xyzuvw")
    next.robax.rax_1 = OP90_Home.robax.rax_1
    next.robax.rax_2 = OP90_Home.robax.rax_2
    next.robax.rax_3 = OP90_Home.robax.rax_3
    MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
    Stop()
  end

  --视觉纠偏是相对于视觉模板的偏差位置，修改视觉位置，注意修改lua中的被检值
  truss_x.num = tonumber( list_str[2]) - VisionDate_init
  SetAO("request_vision",truss_x.num*1000)
  if truss_x.num >=5 or truss_x.num <=-5 then
    TPWrite("Truss > 5 or < -5")
    SetDO("error_code",9)
    --Stop()
  end
  SyncVar(truss_x)
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = OP90_Home.robax.rax_1
  next.robax.rax_2 = OP90_Home.robax.rax_2
  next.robax.rax_3 = OP90_Home.robax.rax_3
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  SetDO("DO_GangYuan_XYZ",0)

end



--左侧 料盘平移
function fun_BUNK_INIT()
    --初始化时,进料舱层数 1-5 
    while( GetAI("tray_in_count")<1 or GetAI("tray_in_count")>5 )
    do
      SetAO("Error_code",10)
      TPWrite("TRAY_IN_NUMBER")      
      Sleep(100)
      Stop()
    end
    
    --出料舱 0-4 
    while( GetAI("tray_out_count")>=5 )
    do
      SetAO("Error_code",11)
      TPWrite("TRAY_OUT_NUMBER")      
      Sleep(100)
      Stop()
    end
    
    --两舱和不是5
    --while( (GetAI("tray_in_count")+GetAI("tray_out_count"))~=5 )
    --do
    --  SetAO("Error_code",12)
    --  TPWrite("TRAY_SUM_NOT_5")      
    --  Sleep(100)
    --  Stop()
    --end
    
    --上料舱,位置到位
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = KGRAB.extax.eax_2 - TRAY_HEIGHT* (GetAI("tray_in_count")-1)
    --下料舱,位置到位
    next.extax.eax_3 = KGRAB.extax.eax_2 - TRAY_HEIGHT* (GetAI("tray_out_count")+1)
    MoveAbsJ(next,v_op90,fine,tool0,wobj0,load0)
end

--进料盘叉入
function JinLiaoPan_ChaRu()
     if GetAI("tray_out_count") == 5 then
    TPWrite("Tray count is wrong")
    SetAO("error_code",15)
    Stop()
  end
  next = GetJointTarget("Xyzuvw")
  next.extax.eax_2 = 46.000
  next.extax.eax_1 = 9.000
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  --到达指定点后，触发执行信号，AGV输送物料
  SetDO("DO_R_GunTong_tuichu",0)
  SetDO("DO_R_GunTong_jinru",1)
  flag = WaitDI("DI_R_GunTong_DaoWei",1,600000,true)
  --AGV小车将阀块放入滚筒
  while flag do
    Sleep(200)
    if GetDI("DI_R_GunTong_DaoWei") == 0 then
      TPWrite("DI_R_GunTong_DaoWeishibai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",3)
      SetDO("DO_R_GunTong_jinru",0)
      SetDO("DO_R_GunTong_tuichu",0)
      Stop()
    elseif GetDI("DI_R_GunTong_DaoWei") == 1 then
      SetDO("DO_R_GunTong_jinru",0)
      SetDO("DO_R_GunTong_tuichu",0)
      break
    end
  end
  SetDO("DO_R_GunTong_jinru",0)
  SetDO("DO_R_GunTong_tuichu",0)
end

--进料盘叉出
function JinLiaoPan_ChaChu()
  next = GetJointTarget("Xyzuvw")
  next.extax.eax_2 = 46.000
  --下降外轴2（左升降机）,其它轴为原点位置
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  SetAO("response",3)
  SetDO("DO_R_GunTong_jinru",0)
  SetDO("DO_R_GunTong_tuichu",1)
  flag = WaitDI("DI_R_GunTong_DaoWei",0,20000,true)
  while flag do
    Sleep(200)
    if GetDI("DI_R_GunTong_DaoWei") == 1 then
      TPWrite("DI_R_GunTong_DaoWei shi bai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",4)
      SetDO("DO_R_GunTong_tuichu",0)
      SetDO("DO_R_GunTong_jinru",0)
      Stop()
    elseif GetDI("DI_R_GunTong_DaoWei") == 0 then
      break
    end
  end
  Sleep(10000)
  SetDO("DO_R_GunTong_tuichu",0)
  SetDO("DO_R_GunTong_jinru",0)
end

--出料盘叉出
function ChuLiaoPan_ChaChu()
  next = GetJointTarget("Xyzuvw")
  next.extax.eax_3 = 46.000
  --下降外轴3（左升降机）,其它轴为原点位置
  MoveAbsJ(next,vmax500,fine,tool0,wobj0,load0)
  SetDO("DO_L_GunTong_JinRu",0)
  SetDO("DO_L_GunTong_SongChu",1)
  flag = WaitDI("DI_L_GunTong_DaoWei",0,20000,true)
  while flag do
    Sleep(200)
    if GetDI("DI_L_GunTong_DaoWei") == 1 then
      TPWrite("DI_L_GunTong_DaoWei Shi Bai")
      SetDO("DO_FengLiao",1)
      SetAO("DO_HuangDeng",1)
      SetAO("error_code",5)
      SetDO("DO_L_GunTong_SongChu",0)
      SetDO("DO_L_GunTong_JinRu",0)
      Stop()
    elseif GetDI("DI_L_GunTong_DaoWei") == 0 then
      break
    end
  end
  Sleep(10000)
  SetDO("DO_L_GunTong_SongChu",0)
  SetDO("DO_L_GunTong_JinRu",0)
end

--进料盘换盘
function JingLiaoPan_Change()
    --料舱爪子,张开
    SetDO("DO_ZhuaPan_GuanBi",0)
    SetDO("DO_ZhuaPan_DaKai",1)
    Sleep(1500)
    
    fun_BUNK_INIT()    
    
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = next.extax.eax_2 + 85
    next.extax.eax_3 = next.extax.eax_3
    MoveAbsJ(next,v50,fine,tool0,wobj0,load0)  
    
    --料舱横移,到上侧
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_1 = SHIFT_1.extax.eax_1
    MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
    Sleep(500)  
    
    --料舱爪子,合拢
    SetDO("DO_ZhuaPan_GuanBi",1)
    SetDO("DO_ZhuaPan_DaKai",0)
    Sleep(1000)
    while (1) do
      Sleep(200)
      if GetDI("DI_ZhuaPan2_GuanBiWei") == 0 or GetDI("DI_ZhuaPan1_GuanBiWei") == 0 then
        TPWrite("ZhuaPan guan bi Shi bai")
        SetDO("DO_FengLiao",1)
        SetAO("DO_HuangDeng",1)
        SetAO("error_code",6)
        Stop()
      elseif  GetDI("DI_ZhuaPan2_GuanBiWei") == 1 and GetDI("DI_ZhuaPan1_GuanBiWei") == 1 then
        break
      end
    end
    
    --上料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = next.extax.eax_2 - 150
    MoveAbsJ(next,v50,fine,tool0,wobj0,load0)  
    
    --料舱横移,到下侧
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_1 = SHIFT_2.extax.eax_1
    MoveAbsJ(next,v50,fine,tool0,wobj0,load0) 
    
    --下料舱,位置上升
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_3 = next.extax.eax_3 + TRAY_HEIGHT + 85
    MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
    Sleep(500)
    
    --料舱爪子,张开
    SetDO("DO_ZhuaPan_GuanBi",0)
    SetDO("DO_ZhuaPan_DaKai",1)
    Sleep(1000)
    while (1) do
      Sleep(200)
      if GetDI("DI_ZhuaPan1_DaKaiDaoWei") == 0 or GetDI("DI_ZhuaPan2_DaKaiDaoWei") == 0 then
        TPWrite("ZhuaPan da kai Shi bai")
        SetDO("DO_FengLiao",1)
        SetAO("DO_HuangDeng",1)
        SetAO("error_code",7)
        Stop()
      elseif  GetDI("DI_ZhuaPan2_DaKaiDaoWei") == 1 and GetDI("DI_ZhuaPan1_DaKaiDaoWei") == 1 then
        break
      end
    end
      
    --下料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    if GetAI("tray_in_count") ~= 1 then
      next.extax.eax_2 = next.extax.eax_2 + 190
    elseif GetAI("tray_in_count") == 1 then
      next.extax.eax_2 = 46
    end
    next.extax.eax_3 = next.extax.eax_3 - TRAY_HEIGHT - 85
    MoveAbsJ(next,v50,fine,tool0,wobj0,load0) 
end

--判断开机托盘层数自检
function Tuopan_Self_Test()
  if GetDI("DI_L_GunTong_DaoWei") == 1 or GetDI("DI_R_GunTong_DaoWei") == 1 then
    TPWrite("Left Gun Tong Has Things")
    SetAO("Pallet_count",1)
  end
end


--料盘数量计算
function fun_LiaoPan_count()
  local next = GetJointTarget("Xyzuvw")
  next.extax.eax_2 = 0
  next.extax.eax_3 = 0
  MoveAbsJ(next, v50, fine, tool0, wobj0, load0)

  SetDO("DO_R_GunTong_tuichu", 0)
  SetDO("DO_R_GunTong_jinru", 1)
  Sleep(3000)
  SetDO("DO_R_GunTong_tuichu", 0)

  local Rob_Point_1 = GetRobTarget("Xyzuvw", tool0, wobj0)
  Rob_Point_1.extax.eax_2 = 717
  local ret = SearchL("DI_R_ShenJiang_DaoWei", 1, P60, Rob_Point_1, v50, tool0, wobj0, load0, 0)

  Sleep(500)
  local Rob_eax1 = GetRobTarget("Xyzuvw", tool0, wobj0)
  local pos_1 = 685
  if Rob_eax1.extax.eax_2>pos_1 and Rob_eax1.extax.eax_2<(pos_1+25) then
    SetAO("R_tuopan_count", 1)
  elseif Rob_eax1.extax.eax_2>(pos_1-TRAY_HEIGHT) and Rob_eax1.extax.eax_2<(pos_1+25-TRAY_HEIGHT) then
    SetAO("R_tuopan_count", 2)
  elseif Rob_eax1.extax.eax_2>(pos_1-TRAY_HEIGHT*2) and Rob_eax1.extax.eax_2<(pos_1+25-TRAY_HEIGHT*2) then
    SetAO("R_tuopan_count", 3)
  elseif Rob_eax1.extax.eax_2>(pos_1-TRAY_HEIGHT*3) and Rob_eax1.extax.eax_2<(pos_1+25-TRAY_HEIGHT*3) then
    SetAO("R_tuopan_count", 4)
  elseif Rob_eax1.extax.eax_2>(pos_1-TRAY_HEIGHT*4) and Rob_eax1.extax.eax_2<(pos_1+25-TRAY_HEIGHT*4) then
    SetAO("R_tuopan_count", 5)
  else
    SetAO("R_tuopan_count", 0)
  end

  SetDO("DO_R_GunTong_tuichu", 0)
  SetDO("DO_R_GunTong_jinru", 1)
  Sleep(3000)
  SetDO("DO_R_GunTong_tuichu", 0)

  Rob_Point_1 = GetRobTarget("Xyzuvw", tool0, wobj0)
  Rob_Point_1.extax.eax_3 = 717
  local ret = SearchL("DI_L_ShenJiang_DaoWei", 1, P60, Rob_Point_1, v50, tool0, wobj0, load0, 0)

  Sleep(500)
  local Rob_eax1 = GetRobTarget("Xyzuvw", tool0, wobj0)
  local pos_1 = 685
  if Rob_eax1.extax.eax_3>pos_1 and Rob_eax1.extax.eax_3<(pos_1+25) then
    SetAO("L_tuopan_count", 1)
  elseif Rob_eax1.extax.eax_3>(pos_1-TRAY_HEIGHT) and Rob_eax1.extax.eax_3<(pos_1+25-TRAY_HEIGHT) then
    SetAO("L_tuopan_count", 2)
  elseif Rob_eax1.extax.eax_3>(pos_1-TRAY_HEIGHT*2) and Rob_eax1.extax.eax_3<(pos_1+25-TRAY_HEIGHT*2) then
    SetAO("L_tuopan_count", 3)
  elseif Rob_eax1.extax.eax_3>(pos_1-TRAY_HEIGHT*3) and Rob_eax1.extax.eax_3<(pos_1+25-TRAY_HEIGHT*3) then
    SetAO("L_tuopan_count", 4)
  elseif Rob_eax1.extax.eax_3>(pos_1-TRAY_HEIGHT*4) and Rob_eax1.extax.eax_3<(pos_1+25-TRAY_HEIGHT*4) then
    SetAO("L_tuopan_count", 5)
  else
    SetAO("L_tuopan_count", 0)
  end
end

--执行M5螺丝吹入
function M5_LuoSi_ChuiRu()
  --M5送料关闭
  SetDO("DO_M5_TouLiao",1)
  --home点
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = FenLi_home.robax.rax_5
  next.robax.rax_6 = FenLi_home.robax.rax_6
  MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
  --M5螺丝孔1
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = M5_1.robax.rax_5
  next.robax.rax_6 = M5_1.robax.rax_6
  MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔2
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = M5_2.robax.rax_5
  next.robax.rax_6 = M5_2.robax.rax_6
  MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔3
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = M5_3.robax.rax_5
  next.robax.rax_6 = M5_3.robax.rax_6
  MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔4
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = M5_4.robax.rax_5
  next.robax.rax_6 = M5_4.robax.rax_6
  MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --home点
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = FenLi_home.robax.rax_5
  next.robax.rax_6 = FenLi_home.robax.rax_6
  MoveAbsJ(next,v50,fine,tool0,wobj0,load0)
  SetAO("response",9)
end

--执行M6螺丝吹入
function M6_LuoSi_ChuiRu()

end

--横移气缸打螺丝位置
function XianDao_DLS()
  -- local position = {156.126,204.901,254.151,293.954,334.344,374.427,414.465,454.486}
  -- local position = {154.63}
  -- local position = {157.371}
  
  --local position = {156.07}
  local position = {153.98}
  next = GetJointTarget("Xyzuvw")
  index_assemable_count = GetAI("index_assembled")
  TPWrite(truss_x.num,index_assemable_count)
  if index_assemable_count > 0 and index_assemable_count < 4 then
    next.robax.rax_4 = position[1] + (index_assemable_count-1)*49 + truss_x.num
  elseif index_assemable_count >= 4 and index_assemable_count <= 9 then
    next.robax.rax_4 = position[1] + 138 + (index_assemable_count-4)*40 + truss_x.num
  end
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
end

function main()
  while (1) do
    Sleep(200)
    if GetDO("DO_LvDeng") ~= 1 then
      SetDO("DO_LvDeng",1)
    end
    if GetDO("bg1_ready") == 1 and GetDO("bg2_ready") == 1 and GetDO("bg3_ready") == 1 and GetDO("work_over") == 0 then
      if GetAI("request") == RequestEnum.MOVE_TO_3_AXIS_SCREW_POSITION then
          --request 1:回OP90_Home点。执行3轴桁架螺丝扣定位
        Init()
        --正在执行3轴桁架横移气缸定位
        SetAO("response", 1)
        --执行横移气缸定位拍照
        HengYi_Vision(FaTi_Kind)
        SetAO("response", 101)
      elseif GetAI("request") == RequestEnum.FEED_TRAY_FORK_IN then
        -- request 2:执行进料盘叉入
        SetAO("response", 2)
        JinLiaoPan_ChaRu()
        SetAO("response", 102)
      elseif GetAI("request") == RequestEnum.EXIT_TRAY_FORK_OUT then
        --request 3:执行出口盘叉出
        SetAO("response", 3)
        ChuLiaoPan_ChaChu()
        SetAO("response", 103)
      elseif GetAI("request") == RequestEnum.FEED_TRAY_FORK_OUT then
        --request 4:执行进料盘叉出
        SetAO("response", 4)
        JinLiaoPan_ChaChu()
        SetAO("response", 104)

      elseif GetAI("request") == RequestEnum.MOVE_2_AXIS_TO_PILOT_VALVE then
        --request 5:M6螺丝吹入
        SetAO("response", 5)
        M5_LuoSi_ChuiRu()
        SetAO("response", 105)
      elseif GetAI("request") == RequestEnum.SCREW_ON_VALVE_BODY then
        --request 6:阀体上打螺丝
        SetAO("response", 6)
        Da_LS()
        SetAO("response", 106)

      elseif GetAI("request") == RequestEnum.INITIALIZE_STATE then
        --request 7:初始化
        SetAO("response", 7)

        SetAO("response", 107)
      elseif GetAI("request") == RequestEnum.CHANGE_FEED_TRAY then
        --request 8:进料盘换盘
        SetAO("response", 8)
        JingLiaoPan_Change()
        SetAO("response", 108)
      elseif GetAI("request") == RequestEnum.M5_chuiru then
        --request 9:M5螺丝吹入
        SetAO("response", 9)
        M5_LuoSi_ChuiRu()
        SetAO("response", 109)
      elseif GetAI("request") == RequestEnum.DLS_HengYi_position then
        --request 10:横移气缸移动到打螺丝位置
        SetAO("response", 10)
        XianDao_DLS()
        SetAO("response", 110)
      elseif GetAI("request") == RequestEnum.FaTi_home then
        --request 11:阀体回原，打开气缸，work_over置1
        SetAO("response",11)
        FaTi_home()
        SetAO("response",111)
      elseif GetAI("request") == RequestEnum.Da_LS_CLS then
        --request 12:打螺丝吹螺丝一起
        SetAO("response",12)
        Da_LS_CLS()
        SetAO("response",112)
      elseif GetAI("request") == RequestEnum.Tuopan_Self_Test then
        --request 13:AGV换盘调用前，检索当前进料盘升降机位置
        SetAO("response",13)
        fun_LiaoPan_count()
        SetAO("response",113)
      end
    end
  end
end

main()

local function GLOBALDATA_DEFINE()
LOADDATA("load2",2.00,{0.00,0.00,100.00},{1.000000,0.000000,0.000000,0.000000},0.00,0.00,0.00,0.00,0.00,0.01)
SPEEDDATA("SpdUser",200.000,50.000,200.000,50.000)
JOINTTARGET("DLS_1",{65.201,8.410,8.033,156.126,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_2",{65.196,8.411,8.076,204.901,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_3",{65.196,8.411,8.076,254.151,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_4",{65.196,8.411,8.076,293.954,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_5",{65.196,8.411,8.076,334.344,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_6",{65.196,8.411,8.076,374.427,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_7",{65.196,8.411,8.076,414.465,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_8",{65.196,8.411,8.076,454.486,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("FenLi_home",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("HengYi_Paizhao",{329.860,50.860,69.730,20.640,77.891,5.253,0.000},{8.988,46.006,46.372,0.000,0.000,0.000,0.000})
JOINTTARGET("Home1",{89.999,-85.001,-0.001,-8.001,-2.001,-79.999,0.000},{50.062,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K10",{26.273,24.786,69.694,7.491,77.898,5.256,0.000},{9.000,46.169,46.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{26.273,24.786,69.694,7.491,77.898,5.256,0.000},{9.000,46.169,46.000,0.000,0.000,0.000,0.000})
JOINTTARGET("KGRAB",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,680.000,680.000,0.000,0.000,0.000,0.000})
JOINTTARGET("LSK_1",{367.702,7.543,8.173,156.125,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
JOINTTARGET("LSK_2",{367.668,37.292,8.200,156.125,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
JOINTTARGET("LSK_3",{441.368,37.287,8.263,156.120,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
JOINTTARGET("LSK_4",{441.874,7.993,8.325,156.125,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
JOINTTARGET("LSQ_home",{26.272,3.000,8.000,7.000,77.898,5.258,0.000},{8.988,46.000,46.000,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_1",{26.272,24.788,69.682,7.491,128.623,78.310,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_2",{26.272,24.788,69.682,7.491,128.640,108.510,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_3",{26.272,24.788,69.682,7.491,-4.740,106.290,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_4",{26.272,24.788,69.682,7.491,-5.000,77.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,46.005,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home_1",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,680.000,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home_2",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,553.000,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home_3",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,426.000,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home_4",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,299.000,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home_5",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,172.000,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("SHIFT_1",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{727.000,680.000,680.000,0.000,0.000,0.000,0.000})
JOINTTARGET("SHIFT_2",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{9.000,680.000,680.000,0.000,0.000,0.000,0.000})
JOINTTARGET("VisionPos",{0.000,1.000,0.000,0.000,1.000,0.000,0.000},{100.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("yuandian",{26.272,3.000,8.000,7.491,77.898,5.258,0.000},{8.988,46.005,46.373,0.000,0.000,0.000,0.000})
ROBTARGET("P20",{125.970,-73.880,-38.840},{0.999231,0.003845,0.038929,0.002773},{0,0,0,0},{9.000,46.005,46.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P30",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,766.744,46.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P40",{125.970,-73.880,-38.840},{0.999231,0.003845,0.038929,0.002773},{0,0,0,0},{9.000,46.005,46.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P50",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,46.000,650.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P60",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,46.000,650.000,0.000,0.000,0.000,0.000},0.000)
STRINGDATA("received","")
STRINGDATA("send","")
end
print("The end!")