require "SocketApi"
local socketName = "sock"

local DEFAULT = 0 --交互指令默认值
local MATERIAL_TO_TRUSS = 1 --从料盘抓取先导阀到2轴桁架台
local TRUSS_TO_VISION = 2 --从2轴桁架台抓取到视觉检测缺螺丝
local VISION_TO_TRASH = 3 --从视觉检测到
local VISION_TO_ASSEMBLE = 4 --运动到装配点
local TO_HOME = 5 --运动到HOME点(安全位置)
local ASSEMBLE_TO_HOME = 6 --从装配位置退到HOME位置
local PICK_UP_MATERIAL = 7 --抓取先导阀到等待位置
local MATERIAL_OFFSET_X =-240 --从料盘上抓先导阀时,X方向偏移量
local MATERIAL_OFFSET_Y = 49.7 --从料盘上抓先导阀时,Y方向偏移量

local ERROR_INDEX_TOP_TRAY_0 = 1
local ERROR_INDEX_TOP_TRAY_16 = 2

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
  retVal = SocketConnect(socketName,"192.168.110.80",8900,2000)
  if retVal == 1 then
    TPWrite(string.format("Socket connect successfully, server name: %s.", socketName))
    break
  else
    TPWrite(string.format("Socket connect failed, server name: %s.", socketName))
    Sleep(100)
  end
end

--先导阀抓取
function pick_up_material()
  local index_top_tray = GetAI("index_top_tray")
  while index_top_tray <= 0 
  do
    TPWrite("ERROR_INDEX_TOP_TRAY_0")  
    SetAO("error",ERROR_INDEX_TOP_TRAY_0)
    
  end
  
  while index_top_tray > 16 
  do
    TPWrite("ERROR_INDEX_TOP_TRAY_18")  
    SetAO("error",ERROR_INDEX_TOP_TRAY_18)
    Stop()
  end
  

  if GetDI("DI_Jiajing_1") == 0 and GetDI("DI_Jiajing_2") == 0 and GetDI("DI_Songkai") == 0 then
    TPWrite("Jia zhua has things")
    SetAO("DO_FengLiao_",2)
    SetAO("DO_HuangDeng_",2)
    Stop()
  elseif GetDI("DI_Jiajing_2") == 1 then
    SetDO("DO_Jiazhua_Dakai",1)
    SetDO("DO_Jiazhua_Guanbi",0)
  end
  
  local offset_y = ((index_top_tray -1) % 8) * MATERIAL_OFFSET_Y
  local offset_x = math.floor((index_top_tray-1) / 8 ) * MATERIAL_OFFSET_X
  
  MoveAbsJ(Robot_YuanDian,v1000,z10,tool0,wobj0,load0)
  MoveAbsJ(K60,v1000,fine,tool0,wobj0,load0)
  MoveL(Offs(P10,offset_x,offset_y,0),v1000,fine,tool0,wobj0,load0)
  MoveL(Offs(P20,offset_x,offset_y,0),v500a200,fine,tool0,wobj0,load0)
  Sleep(500)

  for i=1,3,1 do
    SetDO("DO_Jiazhua_Dakai",0)
    SetDO("DO_Jiazhua_Guanbi",1)
    Sleep(500)
    if GetDI("DI_Jiajing_2") == 1 then
      SetDO("DO_Jiazhua_Dakai",1)
      SetDO("DO_Jiazhua_Guanbi",0)
      Sleep(2000)
    end
  end

  MoveL(Offs(P10,offset_x,offset_y,0),v500a200,z10,tool0,wobj0,load0)
end

--AO信号置位
function releaseDO()
  SetAO("DO_erci_LR_Jiajing_",0)
  SetAO("DO_erci_LR_Songkai_",0)
  SetAO("DO_erci_ZJ_Jiajing_",0)
  SetAO("DO_erci_ZJ_Songkai_",0)
  
  SetAO("DO_M5_TouLiao_",0)
  SetAO("DO_M5_SongLiao_",0)
  SetAO("DO_GangYuan_JianCe_",0)
end

function FaDao_DaLuoSi()
  --改变关节位姿1
  MoveAbsJ(K30,v500a200,fine,tool0,wobj0,load0)
  --到二次精定位处放阀岛_横放
  MoveL(P60,v1000,fine,tool0,wobj0,load0)
  MoveL(P80,v500a200,fine,tool0,wobj0,load0)
  MoveL(P70,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",1)
  SetDO("DO_Jiazhua_Guanbi",0)
  Sleep(1000)
  --二次精定位气缸夹紧DO信号
  SetAO("DO_erci_LR_Jiajing_",2)
  SetAO("DO_erci_LR_Songkai_",1)
  SetAO("DO_erci_ZJ_Jiajing_",2)
  SetAO("DO_erci_ZJ_Songkai_",1)
  --等待二次精定位气缸夹紧到位DI信号
  flag1=WaitDI("DI_DingWei_DaKaiDaoWei2_",1,6000,true)
  if flag1 then
    TPWrite("DI_DingWei_DaKaiDaoWei2_")
    --SetAO("DO_FengLiao_",2)
    Stop()
  end
  flag2=WaitDI("DI_DingWei_DaKaiDaoWei3_",1,6000,true)
  if flag2 then
    TPWrite("DI_DingWei_DaKaiDaoWei3_")
   -- SetAO("DO_FengLiao_",2)
    Stop()
  end
  MoveL(P80,v500a200,fine,tool0,wobj0,load0)
  MoveL(P60,v1000,fine,tool0,wobj0,load0)
  MoveL(P90,v1000,fine,tool0,wobj0,load0)
  --改变关节位姿2
  MoveAbsJ(K80,v1000,fine,tool0,wobj0,load0)
  MoveAbsJ(K120,v500a200,fine,tool0,wobj0,load0)
  --到二次精定位处夹阀岛_横夹
  MoveL(P100,v500,fine,tool0,wobj0,load0)
  MoveL(P110,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  --Stop()
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Sleep(1000)
  --二次精定位气缸松开DO信号
  SetAO("DO_erci_LR_Jiajing_",1)
  SetAO("DO_erci_LR_Songkai_",2)
  SetAO("DO_erci_ZJ_Jiajing_",1)
  SetAO("DO_erci_ZJ_Songkai_",2)
  --等待二次精定位气缸松开到位DI信号
  flag1=WaitDI("DI_DingWei_GuanBiDaoWei2_",1,6000,true)
  if flag1 then
    TPWrite("DI_DingWei_GuanBiDaoWei2_")
    SetAO("DO_FengLiao_",2)
    Stop()
  end
  flag2=WaitDI("DI_DingWei_GuanBiDaoWei3_",1,6000,true)
  if flag2 then
    TPWrite("DI_DingWei_GuanBiDaoWei3_")
    SetAO("DO_FengLiao_",2)
    Stop()
  end
  MoveL(P120,v200,fine,tool0,wobj0,load0)
  MoveL(P130,v1000,fine,tool0,wobj0,load0)
  --改变关节位姿3
  MoveAbsJ(K130,v500a200,fine,tool0,wobj0,load0)
  --到二次精定位处放阀岛_竖放
  MoveL(P140,v500a200,fine,tool0,wobj0,load0)
  MoveL(P150,v1000,fine,tool0,wobj0,load0)
  MoveL(P160,v1000,fine,tool0,wobj0,load0)
  MoveL(P270,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",1)
  SetDO("DO_Jiazhua_Guanbi",0)
  Sleep(1000)
  --二次精定位气缸夹紧DO信号
  SetAO("DO_erci_LR_Jiajing_",2)
  SetAO("DO_erci_LR_Songkai_",1)
  SetAO("DO_erci_ZJ_Jiajing_",2)
  SetAO("DO_erci_ZJ_Songkai_",1)
  --等待二次精定位气缸夹紧到位DI信号
  flag=WaitDI("DI_DingWei_DaKaiDaoWei1_",1,6000,true)
  if flag then
    TPWrite("DI_DingWei_DaKaiDaoWei1_")
    --SetAO("DO_FengLiao_",2)
    Stop()
  end
  flag2=WaitDI("DI_DingWei_DaKaiDaoWei3_",1,6000,true)
  if flag2 then
    TPWrite("DI_DingWei_DaKaiDaoWei3_")
    --SetAO("DO_FengLiao_",2)
    Stop()
  end
  MoveL(P170,v200,fine,tool0,wobj0,load0)
  MoveL(P560,v500a200,fine,tool0,wobj0,load0)
  --改变关节位姿4
  MoveAbsJ(K140,v500a200,fine,tool0,wobj0,load0)
  --到二次精定位处夹阀岛_竖夹
  MoveL(P330,v500a200,fine,tool0,wobj0,load0)
  MoveL(P340,v500a200,fine,tool0,wobj0,load0)
  MoveL(P180,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Sleep(1000)
  --二次精定位气缸松开DO信号
  SetAO("DO_erci_LR_Jiajing_",1)
  SetAO("DO_erci_LR_Songkai_",2)
  SetAO("DO_erci_ZJ_Jiajing_",1)
  SetAO("DO_erci_ZJ_Songkai_",2)
  --等待二次精定位气缸松开到位DI信号
  flag=WaitDI("DI_DingWei_GuanBiDaoWei1_",1,6000,true)
  if flag then
    TPWrite("DI_DingWei_GuanBiDaoWei1_")
   SetAO("DO_FengLiao_",2)
    Stop()
  end
  flag2=WaitDI("DI_DingWei_GuanBiDaoWei3_",1,6000,true)
  if flag2 then
    TPWrite("DI_DingWei_GuanBiDaoWei3_")
   SetAO("DO_FengLiao_",2)
    Stop()
  end
  --到M5螺丝分离处放阀岛
  MoveL(P190,v200,fine,tool0,wobj0,load0)
  MoveL(P200,v500a200,fine,tool0,wobj0,load0)
  MoveL(P210,v500a200,fine,tool0,wobj0,load0)
  MoveL(P350,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",1)
  SetDO("DO_Jiazhua_Guanbi",0)
  Sleep(1000)
  --M5送料_投料夹紧DO信号
  SetAO("DO_M5_TouLiao_",2)
  Sleep(1000)
  SetAO("DO_M5_SongLiao_",2)
  --等待M5送料_投料夹紧到位DI信号
  flag=WaitDI("DI_M5_Songliao_Guanbi_1_",1,6000,true)
  if flag then
    TPWrite("DI_M5_Songliao_Guanbi_1_")
    --SetAO("DO_FengLiao_",2)
    Stop()
  end
  flag1=WaitDI("DI_M5_Songliao_Guanbi_2_",1,6000,true)
  if flag1 then
    TPWrite("DI_M5_Songliao_Guanbi_2_")
    --SetAO("DO_FengLiao_",2)
    Stop()
  end
  Sleep(1000)
  --到M5螺丝分离处夹阀岛
MoveL(P600,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Sleep(2000)
  --M5送料_投料松开DO信号
  SetAO("DO_M5_TouLiao_",1)
  Sleep(3000)
  SetAO("DO_M5_SongLiao_",1)
  Sleep(2000)
  --等待M5送料_投料松开到位DI信号
  flag=WaitDI("DI_M5_Songliao_Dakai_1_",1,6000,true)
  if flag then
    TPWrite("DI_M5_Songliao_Dakai_1_")
    --SetAO("DO_FengLiao_",2)
    Stop()
  end
  flag1=WaitDI("DI_M5_Songliao_Dakai_2_",1,6000,true)
  if flag1 then
    TPWrite("DI_M5_Songliao_Dakai_2_")
    SetAO("DO_FengLiao_",2)
    Stop()
  end
  Sleep(1000)
MoveL(P610,v200,fine,tool0,wobj0,load0)
  MoveL(P240,v500a200,fine,tool0,wobj0,load0)
  
end

function fun_VISION_TO_ASSEMBLE()
  SetAO("DO_GangYuan_JianCe_",1)
  --到横移气缸处打螺丝

MoveL(P430,v500a200,fine,tool0,wobj0,load0)
MoveL(P440,v500a200,z0,tool0,wobj0,load0)
MoveL(P450,v500a200,z0,tool0,wobj0,load0)
MoveL(P460,v500a200,z0,tool0,wobj0,load0)
MoveL(P470,v200,fine,tool0,wobj0,load0)
MoveL(P620,v200,fine,tool0,wobj0,load0)
MoveL(P630,v20a200,fine,tool0,wobj0,load0)
end  

function fun_ASSEMBLE_TO_HOME()
  SetDO("DO_Jiazhua_Dakai",1)
  SetDO("DO_Jiazhua_Guanbi",0)
  Sleep(1000)
MoveL(P480,v500a200,fine,tool0,wobj0,load0)
MoveL(P490,v1000,fine,tool0,wobj0,load0)
MoveL(P500,v1000,fine,tool0,wobj0,load0)
MoveL(P510,v1000,fine,tool0,wobj0,load0)
MoveL(P530,v1000,fine,tool0,wobj0,load0)
  MoveAbsJ(Robot_YuanDian,v500a200,fine,tool0,wobj0,load0)
end  

function fun_TRUSS_TO_VISION()
  SetAO("DO_GangYuan_JianCe_",2)
  MoveAbsJ(K210,v500a200,fine,tool0,wobj0,load0)
  MoveAbsJ(K200,v500a200,z0,tool0,wobj0,load0)
  --拍照检测螺丝是否放全，点位K190
  MoveAbsJ(K190,v500a200,fine,tool0,wobj0,load0)
  Sleep(3000)
  --先导阀螺丝拍照检测
  retVal = SocketSend(socketName, "000025#0111@0009&0004,1,0;0000#", 2000)  --触发拍照
  if retVal ~= 1 then
    TPWrite(string.format("Send failed: %d.", retVal))
    return  --终止语句
  end

  retVal, receivedData = SocketReceive(socketName, 0, 30000)  --机器人接收数据
  if retVal ~= 1 then
    TPWrite(string.format("Received failed: %d.", retVal))
    SetDO("DO_FengLiao_",1)
    Stop()
    return
  end

  TPWrite("Received data: " .. receivedData)
  list_str = split(receivedData, ",") --di 1 ci yi yi , 分割
  if list_str[3] == "0" or list_str[4] == "0" or list_str[5] == "0" or list_str[6] == "0" then
    TPWrite("Luo Si Que Shao")
    SetAO("DO_FengLiao_",2)
    SetAO("DO_HuangDeng_",2)
    -- SetAO("request_vision",1)
    SetAO("request_vision",2)
    Stop()
  else
    SetAO("request_vision",2)
  end
  SetAO("DO_GangYuan_JianCe_",1)
  Sleep(1000)
  --回到拍照前原点
  MoveAbsJ(K240,v500a200,z0,tool0,wobj0,load0)
  MoveAbsJ(K230,v500a200,z0,tool0,wobj0,load0)
  MoveAbsJ(K220,v500a200,z0,tool0,wobj0,load0)
end

--把先导阀从视觉位置放置到废料盘
function fun_VISION_TO_TRASH()
  Sleep(2000)
end

--回home点
function fun_TO_HOME()
  MoveAbsJ(Robot_YuanDian,v200,fine,tool0,wobj0,load0)
end

--主函数
function main()

  while(true)
  do
    Sleep(100)
    flag = GetAI("request")
    if flag == MATERIAL_TO_TRUSS then
      SetAO("response", MATERIAL_TO_TRUSS)
      FaDao_DaLuoSi()
      releaseDO()
      SetAO("response", MATERIAL_TO_TRUSS+100)      
    elseif flag == TRUSS_TO_VISION then
      SetAO("response", TRUSS_TO_VISION)
      fun_TRUSS_TO_VISION()
      SetAO("response", TRUSS_TO_VISION+100)
    elseif flag == VISION_TO_ASSEMBLE then
      SetAO("response", VISION_TO_ASSEMBLE)
      fun_VISION_TO_ASSEMBLE()
      releaseDO()
      SetAO("response", VISION_TO_ASSEMBLE+100)
    elseif flag == ASSEMBLE_TO_HOME then
      SetAO("response", ASSEMBLE_TO_HOME)
      fun_ASSEMBLE_TO_HOME()
      releaseDO()
      SetAO("response", ASSEMBLE_TO_HOME+100)
    elseif flag == TO_HOME then
      SetAO("response", TO_HOME)
     -- fun_TO_HOME()
      SetAO("response", TO_HOME+100)
      Stop()
    elseif flag == PICK_UP_MATERIAL then
      SetAO("response", PICK_UP_MATERIAL)
      pick_up_material()
      releaseDO()
      SetAO("response", PICK_UP_MATERIAL+100)
    end
  end
end

main()

local function GLOBALDATA_DEFINE()
SPEEDDATA("v500a200",500.000,200.000,200.000,70.000)
JOINTTARGET("K10",{-63.529,-7.264,13.318,0.000,83.936,-142.949,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K100",{-65.027,-3.671,20.971,0.137,72.338,-52.090,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K110",{-70.836,-3.916,28.263,97.865,70.024,-102.373,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K120",{56.287,3.764,19.267,-105.368,59.002,116.764,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K130",{70.250,18.715,17.214,-101.772,74.605,40.644,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K140",{70.551,12.447,21.878,-102.393,72.684,125.631,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K150",{-2.758,-34.378,59.827,-7.410,-26.066,14.676,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K160",{42.779,12.634,-5.866,1.352,80.526,218.793,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K170",{-27.942,-39.039,49.490,17.223,-4.657,-13.248,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K180",{-43.070,-18.551,8.923,0.018,99.563,56.007,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K190",{42.566,12.274,0.888,-263.869,74.256,205.448,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{-66.709,-0.444,8.271,-0.037,82.227,-146.701,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K200",{36.661,-4.782,19.043,-265.098,80.050,204.861,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K210",{51.579,-7.221,28.878,-207.732,40.420,175.748,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K220",{74.182,4.984,24.742,-98.043,76.309,120.057,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K230",{51.569,-7.220,28.873,-207.693,40.412,175.715,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K240",{42.850,-5.794,23.124,-241.226,63.578,192.733,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K30",{57.179,13.699,-5.252,0.666,78.314,235.823,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K40",{-43.487,14.695,-8.396,-0.008,83.366,147.754,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K50",{-43.479,16.465,-1.383,-0.008,74.565,147.728,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K60",{51.792,4.840,14.838,-2.214,69.168,135.688,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K70",{-66.681,12.458,26.555,-0.047,51.007,-146.622,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K80",{71.434,-2.343,34.019,-100.697,74.086,122.589,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K90",{-65.027,-3.671,20.971,0.137,72.338,126.063,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_FangZhi",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("M6_FangZhi",{-43.416,16.500,-2.533,0.069,75.984,147.797,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Robot_AnQuan",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Robot_YuanDian",{37.525,-18.384,26.483,-1.742,80.263,120.924,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Tuopan_1",{-65.530,0.422,9.004,0.000,80.597,37.007,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Tuopan_2",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Tuopan_3",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("Tuopan_4",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("XianDao_FeiPing",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("ZhuaQu",{-66.694,12.307,26.485,-0.047,51.243,-146.650,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("ZhuaQu_GuoDu",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
ROBTARGET("P10",{620.360,755.620,789.630},{0.007255,-0.685493,-0.727671,-0.023264},{0,0,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P100",{617.610,783.880,919.070},{0.709650,-0.007564,0.704513,-0.001005},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P110",{617.770,784.280,713.720},{0.709592,-0.007493,0.704572,-0.001144},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P120",{617.720,770.580,809.390},{0.709578,-0.007519,0.704586,-0.001138},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P130",{351.050,762.620,812.430},{0.709774,-0.007313,0.704391,-0.000995},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P140",{449.440,986.450,722.260},{0.512226,-0.483459,0.514312,-0.489259},{0,-2,0,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P150",{545.240,996.180,711.980},{0.501893,-0.493728,0.505004,-0.499307},{0,-2,0,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P160",{625.380,995.400,708.470},{0.503200,-0.492421,0.506284,-0.497984},{0,-2,0,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P170",{381.480,987.940,689.330},{0.511727,-0.483483,0.514962,-0.489074},{0,-2,0,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P180",{615.610,932.180,741.980},{0.720593,-0.008941,0.693300,0.000887},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P190",{615.700,932.230,834.980},{0.707517,-0.008790,0.706641,0.001119},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P20",{620.370,755.620,635.310},{0.007256,-0.685494,-0.727670,-0.023274},{0,0,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P200",{612.850,879.010,834.940},{0.707497,-0.004050,0.706695,-0.003651},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P210",{725.150,882.340,819.230},{0.707495,-0.004044,0.706698,-0.003647},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P220",{711.010,881.310,798.290},{0.707470,-0.004071,0.706721,-0.003706},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P230",{719.330,881.330,863.100},{0.707459,-0.004107,0.706732,-0.003702},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P240",{392.270,881.330,863.110},{0.707456,-0.004102,0.706735,-0.003704},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P250",{290.900,-397.160,790.280},{0.701059,0.065684,0.707702,0.057967},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P260",{719.520,-98.630,630.870},{0.703951,0.065188,0.704218,0.065430},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P270",{625.370,995.390,683.400},{0.503187,-0.492426,0.506291,-0.497986},{0,-2,0,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P280",{381.970,-919.540,614.640},{0.003038,-0.642279,0.766392,0.010539},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P290",{724.180,-97.770,595.190},{0.700954,0.062363,0.707774,0.061885},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P30",{372.640,-864.670,851.610},{0.000257,0.642721,-0.766100,-0.000248},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P300",{719.530,-98.640,588.160},{0.703977,0.065187,0.704192,0.065426},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P310",{533.640,-98.220,786.600},{0.704316,0.061862,0.704468,0.061943},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P320",{719.530,-98.640,591.960},{0.703977,0.065187,0.704192,0.065426},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P330",{421.520,927.680,763.100},{0.707559,-0.014414,0.706473,0.006979},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P340",{615.660,932.240,834.920},{0.707507,-0.008821,0.706651,0.001127},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P350",{725.100,882.380,792.730},{0.707498,-0.004062,0.706694,-0.003628},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P360",{403.720,540.380,608.520},{0.719199,-0.012098,0.694525,-0.015529},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P370",{403.720,540.380,608.520},{0.719199,-0.012098,0.694525,-0.015529},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P380",{403.720,540.380,608.520},{0.719199,-0.012098,0.694525,-0.015529},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P390",{403.720,540.380,608.520},{0.719199,-0.012098,0.694525,-0.015529},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P40",{381.940,-919.550,697.660},{0.003033,-0.642268,0.766402,0.010526},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P400",{403.720,540.380,608.520},{0.719199,-0.012098,0.694525,-0.015529},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P410",{403.720,540.380,608.520},{0.719199,-0.012098,0.694525,-0.015529},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P420",{717.750,881.340,833.020},{0.707345,-0.004086,0.706846,-0.003809},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P430",{344.670,881.320,832.990},{0.707338,-0.004094,0.706853,-0.003826},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P440",{344.670,348.720,832.990},{0.707339,-0.004094,0.706853,-0.003826},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P450",{574.000,348.730,832.960},{0.707327,-0.004107,0.706864,-0.003805},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P460",{626.710,103.590,832.960},{0.707327,-0.004110,0.706864,-0.003806},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P470",{626.710,103.590,644.600},{0.707326,-0.004104,0.706865,-0.003805},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P480",{654.250,97.750,640.060},{0.719235,-0.012092,0.694490,-0.015438},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P490",{626.710,103.570,644.590},{0.707320,-0.004092,0.706871,-0.003815},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P50",{381.920,-921.570,910.570},{0.003027,-0.642254,0.766414,0.010503},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P500",{560.720,103.530,758.010},{0.707277,-0.004079,0.706914,-0.003848},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P510",{603.250,348.730,832.960},{0.707327,-0.004107,0.706864,-0.003806},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P520",{344.670,348.720,832.990},{0.707338,-0.004094,0.706853,-0.003826},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P530",{344.670,881.320,832.990},{0.707338,-0.004094,0.706853,-0.003826},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P540",{647.820,93.470,619.370},{0.724576,-0.016254,0.688865,-0.013794},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P550",{651.550,95.260,619.960},{0.721536,-0.015963,0.692078,-0.012650},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P560",{381.480,987.940,936.510},{0.511727,-0.483484,0.514962,-0.489073},{0,-2,0,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P570",{767.070,827.800,1037.710},{0.605962,-0.688043,0.084220,0.390274},{0,-3,2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P580",{767.070,827.800,1037.710},{0.605962,-0.688043,0.084220,0.390274},{0,-3,2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P590",{651.550,95.260,605.700},{0.721536,-0.015965,0.692077,-0.012650},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P60",{592.720,763.800,1109.820},{0.024297,-0.999092,-0.033431,-0.010322},{0,0,2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P600",{716.080,881.330,798.160},{0.707430,-0.004152,0.706762,-0.003720},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P610",{716.060,881.320,878.840},{0.707407,-0.004181,0.706784,-0.003748},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P620",{655.240,95.220,618.540},{0.724675,-0.013311,0.688859,-0.011934},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P630",{655.240,95.220,604.800},{0.724675,-0.013311,0.688859,-0.011935},{0,-2,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P70",{822.260,763.790,941.190},{0.024285,-0.999092,-0.033443,-0.010302},{0,0,2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P80",{822.310,763.770,1109.890},{0.024329,-0.999092,-0.033413,-0.010349},{0,0,2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P90",{610.460,760.190,990.610},{0.024475,-0.999079,-0.033636,-0.010497},{0,0,2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
end
print("The end!")