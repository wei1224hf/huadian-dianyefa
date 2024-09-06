local DEFAULT = 0 --交互指令默认值
local MATERIAL_TO_TRUSS = 1 --从料盘抓取先导阀到2轴桁架台
local TRUSS_TO_VISION = 2 --从2轴桁架台抓取到视觉检测缺螺丝
local VISION_TO_TRASH = 3 --从视觉检测到
local VISION_TO_ASSEMBLE = 4 --运动到装配点
local TO_HOME = 5 --运动到HOME点(安全位置)
local ASSEMBLE_TO_HOME = 6 --从装配位置退到HOME位置

local MATERIAL_OFFSET_X = 240 --从料盘上抓先导阀时,X方向偏移量
local MATERIAL_OFFSET_Y = -50 --从料盘上抓先导阀时,Y方向偏移量

local ERROR_INDEX_TOP_TRAY_0 = 1
local ERROR_INDEX_TOP_TRAY_16 = 2

function pick_up_material()
  local index_top_tray = GetAI("index_top_tray")
  while index_top_tray <= 0 
  do
    TPWrite("ERROR_INDEX_TOP_TRAY_0")  
    SetAO("error",ERROR_INDEX_TOP_TRAY_0)
    Stop()
  end
  
  while index_top_tray > 16 
  do
    TPWrite("ERROR_INDEX_TOP_TRAY_18")  
    SetAO("error",ERROR_INDEX_TOP_TRAY_18)
    Stop()
  end
  
  local offset_y = ((index_top_tray -1) % 8) * MATERIAL_OFFSET_Y
  local offset_x = math.floor((index_top_tray-1) / 8 ) * MATERIAL_OFFSET_X
  
  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
  MoveL(Offs(P10,offset_x,offset_y,0),v200,fine,tool0,wobj0,load0)
  MoveL(Offs(P20,offset_x,offset_y,0),v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Sleep(1000)
  MoveL(Offs(P10,offset_x,offset_y,0),v200,fine,tool0,wobj0,load0)
end

function releaseDO()
  SetAO("DO_erci_LR_Jiajing_",0)
  SetAO("DO_erci_LR_Songkai_",0)
  SetAO("DO_erci_ZJ_Jiajing_",0)
  SetAO("DO_erci_ZJ_Songkai_",0)
  
  SetAO("DO_M5_TouLiao_",0)
  SetAO("DO_M5_SongLiao_",0)
end




function FaDao_DaLuoSi()
  --改变关节位姿1
  MoveAbsJ(K30,v200,fine,tool0,wobj0,load0)
  --到二次精定位处放阀岛_横放
  MoveL(P60,v200,fine,tool0,wobj0,load0)
  MoveL(P80,v20,fine,tool0,wobj0,load0)
  MoveL(P70,v20,fine,tool0,wobj0,load0)
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
  flag=WaitDI("DI_DingWei_GuanBiDaoWei1_",1,6000,true)
  flag1=WaitDI("DI_DingWei_GuanBiDaoWei2_",1,6000,true)
  flag2=WaitDI("DI_DingWei_GuanBiDaoWei3_",1,6000,true)
  if flag and flag1 and flag2 then
    TPWrite("DingWei_GuanBi_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  MoveL(P80,v200,fine,tool0,wobj0,load0)
  MoveL(P60,v200,fine,tool0,wobj0,load0)
  MoveL(P90,v200,fine,tool0,wobj0,load0)
  --改变关节位姿2
  MoveAbsJ(K80,v200,fine,tool0,wobj0,load0)
  MoveAbsJ(K120,v200,fine,tool0,wobj0,load0)
  --到二次精定位处夹阀岛_横夹
  MoveL(P100,v200,fine,tool0,wobj0,load0)
  MoveL(P110,v20,fine,tool0,wobj0,load0)
  Sleep(1000)
  Stop()
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Sleep(1000)
  --二次精定位气缸松开DO信号
  SetAO("DO_erci_LR_Jiajing_",1)
  SetAO("DO_erci_LR_Songkai_",2)
  SetAO("DO_erci_ZJ_Jiajing_",1)
  SetAO("DO_erci_ZJ_Songkai_",2)
  --等待二次精定位气缸松开到位DI信号
  flag=WaitDI("DI_DingWei_DaKaiDaoWei1_",1,6000,true)
  flag1=WaitDI("DI_DingWei_DaKaiDaoWei2_",1,6000,true)
  flag2=WaitDI("DI_DingWei_DaKaiDaoWei3_",1,6000,true)
  if flag and flag1 and flag2 then
    TPWrite("DingWei_DaKai_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  Stop()
  MoveL(P120,v20,fine,tool0,wobj0,load0)
  MoveL(P130,v200,fine,tool0,wobj0,load0)
  --改变关节位姿3
  MoveAbsJ(K130,v200,fine,tool0,wobj0,load0)
  --到二次精定位处放阀岛_竖放
  MoveL(P140,v200,fine,tool0,wobj0,load0)
  MoveL(P150,v20,fine,tool0,wobj0,load0)
  MoveL(P160,v20,fine,tool0,wobj0,load0)
  MoveL(P270,v20,fine,tool0,wobj0,load0)
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
  flag=WaitDI("DI_DingWei_GuanBiDaoWei1_",1,6000,true)
  flag1=WaitDI("DI_DingWei_GuanBiDaoWei2_",1,6000,true)
  flag2=WaitDI("DI_DingWei_GuanBiDaoWei3_",1,6000,true)
  if flag and flag1 and flag2 then
    TPWrite("DingWei_GuanBi_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  MoveL(P170,v20,fine,tool0,wobj0,load0)
  --改变关节位姿4
  MoveAbsJ(K140,v200,fine,tool0,wobj0,load0)
  --到二次精定位处夹阀岛_竖夹
  MoveL(P180,v200,fine,tool0,wobj0,load0)
  Sleep(1000)
  Stop()
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Stop()
  Sleep(1000)
  --二次精定位气缸松开DO信号
  SetAO("DO_erci_LR_Jiajing_",1)
  SetAO("DO_erci_LR_Songkai_",2)
  SetAO("DO_erci_ZJ_Jiajing_",1)
  SetAO("DO_erci_ZJ_Songkai_",2)
  --等待二次精定位气缸松开到位DI信号
  flag=WaitDI("DI_DingWei_DaKaiDaoWei1_",1,6000,true)
  flag1=WaitDI("DI_DingWei_DaKaiDaoWei2_",1,6000,true)
  flag2=WaitDI("DI_DingWei_DaKaiDaoWei3_",1,6000,true)
  if flag and flag1 and flag2 then
    TPWrite("DingWei_DaKai_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --到M5螺丝分离处放阀岛
  MoveL(P190,v20,fine,tool0,wobj0,load0)
  MoveL(P200,v200,fine,tool0,wobj0,load0)
  MoveL(P210,v20,fine,tool0,wobj0,load0)
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
  flag1=WaitDI("DI_M5_Songliao_Guanbi_2_",1,6000,true)
  flag2=WaitAO("DO_M5_TouLiao_",2,6000,true)
  if flag and flag1 and flag2 then
    TPWrite("M5_Songliao_Guanbi_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --到M5螺丝分离处夹阀岛
  MoveL(P220,v20,fine,tool0,wobj0,load0)
  Sleep(1000)
  SetDO("DO_Jiazhua_Dakai",0)
  SetDO("DO_Jiazhua_Guanbi",1)
  Stop()
  Sleep(1000)
  --M5送料_投料松开DO信号
  SetAO("DO_M5_TouLiao_",1)
  Sleep(1000)
  SetAO("DO_M5_SongLiao_",1)
  --等待M5送料_投料松开到位DI信号
  flag=WaitDI("DI_M5_Songliao_Dakai_1_",1,6000,true)
  flag1=WaitDI("DI_M5_Songliao_Dakai_2_",1,6000,true)
  flag2=WaitAO("DO_M5_TouLiao_",1,6000,true)
  if flag and flag1 and flag2 then
    TPWrite("M5_Songliao_Dakai_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  MoveL(P230,v20,fine,tool0,wobj0,load0)
  MoveL(P240,v200,fine,tool0,wobj0,load0)
  
end

function fun_VISION_TO_ASSEMBLE()
  --到横移气缸处打螺丝
  MoveAbsJ(K160,v200,fine,tool0,wobj0,load0)
  MoveAbsJ(K170,v200,fine,tool0,wobj0,load0)
  MoveAbsJ(K150,v200,fine,tool0,wobj0,load0)
  MoveL(P260,v200,fine,tool0,wobj0,load0)
  MoveL(P320,v20,fine,tool0,wobj0,load0)
  MoveL(P300,v20,fine,tool0,wobj0,load0)
end  

function fun_ASSEMBLE_TO_HOME()
  SetDO("DO_Jiazhua_Dakai",1)
  SetDO("DO_Jiazhua_Guanbi",0)
  MoveL(P320,v20,fine,tool0,wobj0,load0)
  MoveL(P260,v200,fine,tool0,wobj0,load0)
  MoveL(P310,v200,fine,tool0,wobj0,load0)
  MoveAbsJ(Robot_YuanDian,v200,fine,tool0,wobj0,load0)
end  

function fun_TRUSS_TO_VISION()
  MoveAbsJ(K10JC,v200,z10,tool0,wobj0,load0) 
  MoveAbsJ(K20JC,v200,fine,tool0,wobj0,load0)
  MoveAbsJ(K30JC,v200,fine,tool0,wobj0,load0)--luosi
end

function fun_VISION_TO_TRASH()
  Sleep(2000)
end

function fun_TO_HOME()
  MoveAbsJ(Robot_YuanDian,v200,fine,tool0,wobj0,load0)
end

function main()

  while(true)
  do
    Sleep(100)
    flag = GetAI("request")
    if flag == MATERIAL_TO_TRUSS then
      SetAO("response", MATERIAL_TO_TRUSS)
      pick_up_material()
      FaDao_DaLuoSi()
      releaseDO()
      SetAO("response", MATERIAL_TO_TRUSS+100)      
    elseif flag == TRUSS_TO_VISION then
      SetAO("response", TRUSS_TO_VISION)
      fun_TRUSS_TO_VISION()
      releaseDO()
      SetAO("response", TRUSS_TO_VISION+100)
    elseif flag == VISION_TO_TRASH then
      SetAO("response", VISION_TO_TRASH)
      fun_VISION_TO_TRASH()
      releaseDO()
      SetAO("response", VISION_TO_TRASH+100)
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
      fun_TO_HOME()
      SetAO("response", TO_HOME+100)
    end
  end
end

main()

--flag=WaitAI("request")
--while flag==1 do
--  Sleep(1000)
--
--  --抓取阀岛1
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(P10,v200,fine,tool0,wobj0,load0)
--  MoveL(P20,v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(P10,v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛2
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-49.7,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-49.7,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-49.7,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛3
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-99.4,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-99.4,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-99.4,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛4
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-149.1,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-149.1,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-149.1,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛5
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-198.8,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-198.8,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-198.8,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛6
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-248.5,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-248.5,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-248.5,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛7
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-298.2,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-298.2,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-298.2,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--  --抓取阀岛8
--  MoveAbsJ(Robot_YuanDian,v200,z10,tool0,wobj0,load0)
--  MoveAbsJ(K60,v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P10,0,-347.9,0),v200,fine,tool0,wobj0,load0)
--  MoveL(Offs(P20,0,-347.9,0),v200,fine,tool0,wobj0,load0)
--  Sleep(1000)
--  SetDO("DO_Jiazhua_Dakai",0)
--  SetDO("DO_Jiazhua_Guanbi",1)
--  Sleep(1000)
--  MoveL(Offs(P10,0,-347.9,0),v200,fine,tool0,wobj0,load0)
--  FaDao_DaLuoSi()
--end

local function GLOBALDATA_DEFINE()
  JOINTTARGET("K10",{-63.529,-7.264,13.318,0.000,83.936,-142.949,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K100",{-65.027,-3.671,20.971,0.137,72.338,-52.090,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K110",{-70.836,-3.916,28.263,97.865,70.024,-102.373,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K120",{-77.626,11.855,29.497,98.249,80.735,-121.018,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K130",{-80.291,-2.735,34.205,95.576,82.139,-23.704,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K140",{-78.437,16.541,22.801,97.098,80.525,-118.771,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K150",{-2.758,-34.378,59.827,-7.410,-26.066,14.676,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K160",{-63.675,-41.017,48.938,93.309,63.285,-88.500,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K170",{-27.942,-39.039,49.490,17.223,-4.657,-13.248,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K180",{-43.070,-18.551,8.923,0.018,99.563,56.007,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K20",{-66.709,-0.444,8.271,-0.037,82.227,-146.701,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K30",{-64.193,2.260,6.082,-0.820,81.759,129.596,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K40",{-43.487,14.695,-8.396,-0.008,83.366,147.754,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K50",{-43.479,16.465,-1.383,-0.008,74.565,147.728,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K60",{-66.682,-0.416,8.413,-0.037,82.022,-146.667,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K70",{-66.681,12.458,26.555,-0.047,51.007,-146.622,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K80",{-64.178,2.262,6.084,-0.819,81.744,-57.513,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K90",{-65.027,-3.671,20.971,0.137,72.338,126.063,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("M5_FangZhi",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("M6_FangZhi",{-43.416,16.500,-2.533,0.069,75.984,147.797,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("Robot_AnQuan",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("Robot_YuanDian",{-43.077,-18.555,8.924,0.018,99.582,56.018,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("Tuopan_1",{-65.530,0.422,9.004,0.000,80.597,37.007,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("Tuopan_2",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("Tuopan_3",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("Tuopan_4",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("XianDao_FeiPing",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("ZhuaQu",{-66.694,12.307,26.485,-0.047,51.243,-146.650,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("ZhuaQu_GuoDu",{1.670,-16.238,39.616,0.004,66.643,-75.089,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  ROBTARGET("P10",{381.740,-765.390,957.690},{0.000016,-0.642243,0.766501,0.000083},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P100",{548.990,-797.530,686.700},{0.703818,0.067834,0.703881,0.067757},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P110",{616.770,-796.690,675.640},{0.703758,0.067933,0.703930,0.067767},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P120",{627.310,-788.250,711.720},{0.703764,0.067900,0.703927,0.067763},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P130",{229.790,-788.240,814.970},{0.703747,0.067908,0.703944,0.067759},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P140",{590.390,-1003.440,725.730},{0.464939,0.531254,0.460947,0.537707},{-1,1,-1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P150",{590.390,-1001.850,653.640},{0.463846,0.537515,0.453539,0.538727},{-1,1,-1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P160",{621.640,-1004.400,654.750},{0.463438,0.537209,0.453932,0.539053},{-1,1,-1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P170",{459.240,-1005.450,620.740},{0.463332,0.537232,0.453976,0.539083},{-1,1,-1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P180",{618.360,-947.950,711.090},{0.700317,0.070282,0.707237,0.066573},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P190",{635.910,-953.570,792.810},{0.700318,0.070224,0.707252,0.066474},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P20",{381.740,-765.380,615.980},{0.000015,-0.642245,0.766500,0.000075},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P200",{619.770,-898.480,792.810},{0.700312,0.070226,0.707257,0.066475},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P210",{723.850,-895.400,765.970},{0.700417,0.072209,0.707123,0.064646},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P220",{726.640,-895.130,747.400},{0.700986,0.065688,0.707771,0.057999},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P230",{726.650,-895.120,775.290},{0.700972,0.065704,0.707782,0.058021},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P240",{342.670,-894.440,790.330},{0.701087,0.065643,0.707675,0.057997},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P250",{290.900,-397.160,790.280},{0.701059,0.065684,0.707702,0.057967},{-1,1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P260",{719.520,-98.630,630.870},{0.703951,0.065188,0.704218,0.065430},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P270",{621.640,-1005.510,629.240},{0.463412,0.537219,0.453952,0.539048},{-1,1,-1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P280",{381.970,-919.540,614.640},{0.003038,-0.642279,0.766392,0.010539},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P290",{724.180,-97.770,595.190},{0.700954,0.062363,0.707774,0.061885},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P30",{372.640,-864.670,851.610},{0.000257,0.642721,-0.766100,-0.000248},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P300",{719.530,-98.640,588.160},{0.703977,0.065187,0.704192,0.065426},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P310",{533.640,-98.220,786.600},{0.704316,0.061862,0.704468,0.061943},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P320",{719.530,-98.640,591.960},{0.703977,0.065187,0.704192,0.065426},{-1,-1,0,1},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P40",{381.940,-919.550,697.660},{0.003033,-0.642268,0.766402,0.010526},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P50",{381.920,-921.570,910.570},{0.003027,-0.642254,0.766414,0.010503},{-1,-1,-2,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P60",{831.550,-788.600,1026.480},{0.001931,0.995218,-0.097629,0.002365},{-1,-1,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P70",{831.890,-788.820,902.210},{0.002002,0.995244,-0.097358,0.002448},{-1,-1,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P80",{831.840,-788.740,928.830},{0.001989,0.995240,-0.097402,0.002439},{-1,-1,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P90",{424.210,-879.780,1022.610},{0.003191,0.992907,-0.118679,-0.006362},{-1,-1,1,0},{0.000,0.000,0.000,0.000,0.000,0.000,0.000},0.000)
JOINTTARGET("K10JC",{-65.706,34.415,2.413,145.080,95.717,-132.953,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20JC",{-45.492,15.019,-3.428,98.913,-67.165,-21.445,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K30JC",{-46.020,10.443,0.019,89.963,-63.367,-31.875,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})  
end
print("The end!")
