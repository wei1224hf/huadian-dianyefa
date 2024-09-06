


--横移气缸纠偏变量
FaTi_Kind = 0
Truss_x = 0


local MOVE_TO_3_AXIS_SCREW_POSITION = 1  -- 请求执行 3轴桁架螺丝口定位
local FEED_TRAY_FORK_IN = 2              -- 请求执行 进料盘 叉入动作
local EXIT_TRAY_FORK_OUT = 3             -- 请求执行 出口盘 叉出动作
local FEED_TRAY_FORK_OUT = 4             -- 请求执行 进料盘 叉出动作
local MOVE_2_AXIS_TO_PILOT_VALVE = 5     -- 请求执行 2轴桁架给先导阀顶螺丝 动作
local SCREW_ON_VALVE_BODY = 6            -- 请求执行 阀体上打螺丝
local INITIALIZE_STATE = 7               -- 请求执行 初始化状态
local CHANGE_FEED_TRAY = 8               -- 请求执行 进料盘换盘
local M5_CHUIRU = 9               -- 请求执行 M5螺丝吹入
local DLS_HENGYI_POSITION = 10

local request_previes = -1
local next = GetJointTarget("Xyzuvw")
local TRAY_HEIGHT = 127


--判断阀体种类
function Judeg_FaTi_Kind()
  FaTi_Kind = GetAI("request_vision")
end

function screwAction()
  SetDO("DO_NJQ_PiTouDingWei",1)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  --flag = WaitDI("DI_LuoSiQiang_xiajiang",1,6000,true)
  --if flag then
  --TPWrite("DI_LuoSiQiang_shangshen is problem")
  --SetDO("DO_FengLiao",1)
  --Stop()
  --end
  Sleep(2000)
  SetAO("screw_run",1)
  Sleep(2000)
  local ret = WaitAI("screw_status","GT",0,300000)
  if false == ret then
    SetAO("screw_reset",1)
    TPWrite("screw_status is problem")
    SetDO("DO_FengLiao",1)
    Stop()
  end
  SetAO("screw_run",0)
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  flag=WaitDI("DI_LuoSiQiang_shangshen",1,6000,true)
  if flag then
    TPWrite("DI_LuoSiQiang_shangshen_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  Sleep(2000)
end

--螺丝枪打螺丝函数
function LuoSiQiangDaKong()
  --螺丝打孔1
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = KScrew1.robax.rax_1
  next.robax.rax_2 = KScrew1.robax.rax_2
  next.robax.rax_3 = KScrew1.robax.rax_3
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  screwAction()

  --螺丝打孔2
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = KScrew2.robax.rax_1
  next.robax.rax_2 = KScrew2.robax.rax_2
  next.robax.rax_3 = KScrew2.robax.rax_3
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  screwAction()

  --螺丝打孔3
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = KScrew3.robax.rax_1
  next.robax.rax_2 = KScrew3.robax.rax_2
  next.robax.rax_3 = KScrew3.robax.rax_3
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  screwAction()

  --螺丝打孔4
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_1 = KScrew4.robax.rax_1
  next.robax.rax_2 = KScrew4.robax.rax_2
  next.robax.rax_3 = KScrew4.robax.rax_3
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  screwAction()
end

function shijiao()
  MoveAbsJ(KScrew1,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(KScrew2,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(KScrew3,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(KScrew4,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(K10_CLS,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(K20_CLS,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(K30_CLS,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(K40_CLS,v_op50,fine,tool0,wobj0,load0)
  MoveAbsJ(K50_CLS,v_op50,fine,tool0,wobj0,load0)
  
end

function LuoSi_Chuiru()
  SetDO("DO_M5_FenLi",1)
  WaitDI("DI_M5_LuoSi_fenli_dakai",0)
  --WaitDI("DI_M5_LuoSi_fenli_guanbi",1)
  Sleep(200)
  SetDO("DO_M5_LuoSi_Geli",1)
  flag=WaitDI("DI_M5_LuoSi_Geli_guanbi",1,6000,true)
  if flag then
    TPWrite("M5_LuoSi_Geli_sshibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  Sleep(1000)
  SetDO("DO_M5_LuoSi_Geli",0)
  Sleep(200)
  SetDO("DO_M5_LuoSi_Chuiru",1)
  Sleep(2000)
  SetDO("DO_M5_LuoSi_Chuiru",0)
  SetDO("DO_M5_FenLi",0)
  WaitDI("DI_M5_LuoSi_fenli_dakai",1)
  WaitDI("DI_M5_LuoSi_fenli_guanbi",0)
  Sleep(5000)
end

--初始化信号位置
function Init()
  --横移气缸阀体料未到位，信号复位开始
  if GetDI("DI_HengYi_YouLiao") == 0 then
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
    SetDO("DO_FengLiao",0)
    SetDO("DO_HongDeng",0)
    --偏移位置对比状态置0
    SetDO("Md_home",0)
    --AO错误报警置0
    SetAO("error",0)
  end
end

function Gohome()
  Init()
  --横移气缸回到原点
  MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
end

--横移气缸拍照纠偏
function HengYi_Vision(FaTi_Kind)
  --3轴螺丝枪桁架移动到拍照点位
  MoveAbsJ(HengYi_Paizhao,v200,fine,tool0,wobj0,load0)
  Sleep(100)
  --阀体拍照检测
  SetAO("request_vision",FaTi_Kind)
  --等待数据解析完成后，视觉纠偏值小于1，等待时间最大2000ms
  WaitAI("vision_truss_x","LT",2,2000)
  Truss_x = GetAI("vision_truss_x")
  Truss_x = tonumber(Truss_x)/100
  --横移气缸X位置加入纠偏
  Keep_joint(HengYi_Paizhao)
  HengYi_Paizhao.extax.rax_4 = HengYi_Paizhao.extax.rax_4 + Truss_x
  MoveAbsJ(HengYi_Paizhao,v200,fine,tool0,wobj0,load0)
end

--进料盘叉入
function JinLiaoPan_ChaRu()
  TPWrite("OP90_Home点当前坐标",OP90_Home)  
  next = GetJointTarget("Xyzuvw")
  next.extax.eax_2 = 46.000
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0) 
  --到达指定点后，触发执行信号，AGV输送物料
  --WaitAI("AGV_Daowei","GT",0,8000)
  SetDO("DO_R_GunTong_tuichu",0)
  SetDO("DO_R_GunTong_jinru",1)
  --AGV小车将阀块放入滚筒
  if WaitDI("DI_R_GunTong_DaoWei",1,8000,true) then
    TPWrite("DI_R_GunTong_DaoWeishibai")
    SetDO("DO_FengLiao",1)
    SetDO("DO_R_GunTong_jinru",0)
    SetDO("DO_R_GunTong_tuichu",0)
    stop()
  end
  SetDO("DO_R_GunTong_jinru",0)
  SetDO("DO_R_GunTong_tuichu",0)  
end

local TRAY_IN_NUMBER = 1
local TRAY_OUT_NUMBER = 2
local TRAY_SUM_NOT_5 = 3
function fun_BUNK_INIT()
    --初始化时,进料舱层数 1-5 
    while( GetAI("tray_in_count")<1 or GetAI("tray_in_count")>5 )
    do
      --SetAO("Error_code",TRAY_IN_NUMBER)
      TPWrite("TRAY_IN_NUMBER")      
      Sleep(100)
      Stop()
    end
    
    --出料舱 0-4 
    while( GetAI("tray_out_count")>=5 )
    do
      --SetAO("Error_code",TRAY_OUT_NUMBER)
      TPWrite("TRAY_OUT_NUMBER")      
      Sleep(100)
      Stop()
    end
    
    --两舱和不是5
    while( (GetAI("tray_in_count")+GetAI("tray_out_count"))~=5 )
    do
      --SetAO("Error_code",TRAY_SUM_NOT_5)
      TPWrite("TRAY_SUM_NOT_5")      
      Sleep(100)
      Stop()
    end
    
    --上料舱,位置到位
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = KGRAB.extax.eax_2 - TRAY_HEIGHT* (GetAI("tray_in_count")-1)
    --下料舱,位置到位
    next.extax.eax_3 = KGRAB.extax.eax_2 - TRAY_HEIGHT* (GetAI("tray_out_count")+1)
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
end

--左侧 料盘平移
function fun_BUNK_SHIFT()

    --料舱爪子,张开
    SetDO("DO_ZhuaPan_GuanBi",0)
    SetDO("DO_ZhuaPan_DaKai",1)
    Sleep(1500)
    
    fun_BUNK_INIT()    
    
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = next.extax.eax_2 + 95
    next.extax.eax_3 = next.extax.eax_3 + 95
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)  
    
    --料舱横移,到上侧
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_1 = SHIFT_1.extax.eax_1
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)  
    
    --料舱爪子,合拢
    SetDO("DO_ZhuaPan_GuanBi",1)
    SetDO("DO_ZhuaPan_DaKai",0)
    WaitDI("DI_ZhuaPan2_GuanBiWei",1)
    WaitDI("DI_ZhuaPan1_GuanBiWei",1)
    
    --上料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_2 = next.extax.eax_2 - TRAY_HEIGHT
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)  
    
    --料舱横移,到下侧
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_1 = SHIFT_2.extax.eax_1
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0) 
    
    --下料舱,位置上升
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_3 = next.extax.eax_3 + TRAY_HEIGHT
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0) 
    
    --料舱爪子,张开
    SetDO("DO_ZhuaPan_GuanBi",0)
    SetDO("DO_ZhuaPan_DaKai",1)
    WaitDI("DI_ZhuaPan1_DaKaiDaoWei",1)
    WaitDI("DI_ZhuaPan2_DaKaiDaoWei",1)
      
    --下料舱,位置下降
    next = GetJointTarget("Xyzuvw")
    next.extax.eax_3 = next.extax.eax_3 - TRAY_HEIGHT
    MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0) 
end

--进料盘叉出
function JinLiaoPan_ChaChu()
  next = GetJointTarget("Xyzuvw")
  next.extax.eax_2 = 46
  --下降外轴2（左升降机）,其它轴为原点位置
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  SetDO("DO_R_GunTong_jinru",0)
  SetDO("DO_R_GunTong_tuichu",1)
  if WaitDI("DI_R_GunTong_DaoWei",1,8000,true) then
    TPWrite("DI_R_GunTong_DaoWei shi bai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  Sleep(10000)
  SetDO("DO_R_GunTong_tuichu",0)
end

--出料盘叉出
function ChuLiaoPan_ChaChu()
  next = GetJointTarget("Xyzuvw")
  next.extax.eax_3 = 46
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  SetDO("DO_L_GunTong_jinru",0)
  SetDO("DO_L_GunTong_SongChu",1)
  if WaitDI("DI_L_GunTong_DaoWei",1,8000,true) then
    TPWrite("DI_L_GunTong_DaoWei Shi Bai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  Sleep(10000)
  SetDO("DO_L_GunTong_tuichu",0)
  SetDO("DO_L_GunTong_jinru",0)
end

--执行M5螺丝吹入
function M5_LuoSi_ChuiRu()
  --M5送料关闭
  SetDO("DO_M5_TouLiao",1)
  --home点
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = K10_CLS.robax.rax_5
  next.robax.rax_6 = K10_CLS.robax.rax_6
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)

  --M5螺丝孔1
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = K20_CLS.robax.rax_5
  next.robax.rax_6 = K20_CLS.robax.rax_6
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔2
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = K30_CLS.robax.rax_5
  next.robax.rax_6 = K30_CLS.robax.rax_6
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔3
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = K40_CLS.robax.rax_5
  next.robax.rax_6 = K40_CLS.robax.rax_6
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔4
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = K50_CLS.robax.rax_5
  next.robax.rax_6 = K50_CLS.robax.rax_6
  MoveAbsJ(next,v_op50,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --home点
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_5 = FenLi_home.robax.rax_5
  next.robax.rax_6 = FenLi_home.robax.rax_6  
  MoveAbsJ(next,v100,fine,tool0,wobj0,load0)
  SetAO("response",9)
end

--执行M6螺丝吹入
function M6_LuoSi_ChuiRu()

end

--打螺丝
function XianDao_DLS()
  local position = {156.126,204.901,254.151,293.954,334.344,374.427,414.465,454.486}
  next = GetJointTarget("Xyzuvw")
  next.robax.rax_4 = position[GetAI("index_assembled")]
  MoveAbsJ(next,v200,fine,tool0,wobj0,load0)
  LuoSiQiangDaKong()
end

function main()
  while (1) do
    Sleep(200)
    if request_previes ~= GetAI("request") then
      request_previes = GetAI("request")

      if GetAI("request") == MOVE_TO_3_AXIS_SCREW_POSITION then
        --request 1:回OP90_Home点。执行3轴桁架螺丝扣定位
        Gohome()
        --正在执行3轴桁架横移气缸定位
        SetAO("response",MOVE_TO_3_AXIS_SCREW_POSITION)
        --执行横移气缸定位拍照
        HengYi_Vision(FaTi_Kind)
        SetAO("response",MOVE_TO_3_AXIS_SCREW_POSITION+100)

      elseif GetAI("request") == FEED_TRAY_FORK_IN then
        -- request 2:执行进料盘叉入
        SetAO("response",FEED_TRAY_FORK_IN)
        --JinLiaoPan_ChaRu()
        fun_BUNK_INIT()
        SetAO("response",FEED_TRAY_FORK_IN+100)

      elseif GetAI("request") == EXIT_TRAY_FORK_OUT then
        --request 3:执行出口盘叉出
        SetAO("response",EXIT_TRAY_FORK_OUT)
        -- ChuLiaoPan_ChaChu()
        SetAO("response",EXIT_TRAY_FORK_OUT+100)

      elseif GetAI("request") == FEED_TRAY_FORK_OUT then
        --request 4:执行进料盘叉出
        SetAO("response",FEED_TRAY_FORK_OUT)
        -- JinLiaoPan_ChaChu()
        SetAO("response",FEED_TRAY_FORK_OUT+100)

      elseif GetAI("request") == MOVE_2_AXIS_TO_PILOT_VALVE then
        --request 5:M6螺丝吹入
        SetAO("response",MOVE_2_AXIS_TO_PILOT_VALVE)
        -- M5_LuoSi_ChuiRu()
        SetAO("response",MOVE_2_AXIS_TO_PILOT_VALVE+100)

      elseif GetAI("request") == SCREW_ON_VALVE_BODY then
        --request 6:阀体上打螺丝
        SetAO("response",SCREW_ON_VALVE_BODY)
        LuoSiQiangDaKong()
        SetAO("response",SCREW_ON_VALVE_BODY+100)

      elseif GetAI("request") == INITIALIZE_STATE then
        --request 7:初始化
        SetAO("response",7)

        SetAO("response",107)

      elseif GetAI("request") == CHANGE_FEED_TRAY then
        --request 8:进料盘换盘
        SetAO("response",CHANGE_FEED_TRAY)
        fun_BUNK_SHIFT()
        SetAO("response",CHANGE_FEED_TRAY+100)
      elseif GetAI("request") == M5_CHUIRU then
        --request 9:M5螺丝吹入
        SetAO("response",M5_CHUIRU)
        M5_LuoSi_ChuiRu()
        SetAO("response",M5_CHUIRU+100)
      elseif GetAI("request") == DLS_HENGYI_POSITION then
        --request 10:横移气缸移动到打螺丝位置
        SetAO("response",DLS_HENGYI_POSITION)
        XianDao_DLS()
        SetAO("response",DLS_HENGYI_POSITION+100)
      elseif GetAI("request") == 0 then
        Sleep(800)
        SetAO("response",0)
      end
      
    end
  end
end

main()

local function GLOBALDATA_DEFINE()
JOINTTARGET("DLS_1",{65.201,8.410,8.033,156.126,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_2",{65.196,8.411,8.076,204.901,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_3",{65.196,8.411,8.076,254.151,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_4",{65.196,8.411,8.076,293.954,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_5",{65.196,8.411,8.076,334.344,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_6",{65.196,8.411,8.076,374.427,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_7",{65.196,8.411,8.076,414.465,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("DLS_8",{65.196,8.411,8.076,454.486,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
JOINTTARGET("FenLi_home",{26.272,24.788,69.682,7.491,62.335,2.021,0.000},{9.000,46.000,46.000,0.000,0.000,0.000,0.000})
JOINTTARGET("HengYi_Paizhao",{359.173,54.782,69.704,7.491,77.891,5.253,0.000},{8.988,46.006,46.372,0.000,0.000,0.000,0.000})
JOINTTARGET("K10",{26.273,24.786,69.694,7.491,77.898,5.256,0.000},{9.000,46.169,46.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K10_CLS",{80.999,24.004,51.040,7.492,-24.397,68.060,0.000},{500.000,712.998,81.535,0.000,0.000,0.000,0.000})
JOINTTARGET("K20",{26.273,24.786,69.694,7.491,77.898,5.256,0.000},{9.000,46.169,46.000,0.000,0.000,0.000,0.000})
JOINTTARGET("K20_CLS",{80.999,24.004,51.020,7.492,71.153,1.684,0.000},{500.000,712.999,81.535,0.000,0.000,0.000,0.000})
JOINTTARGET("K30_CLS",{80.999,24.004,51.020,7.492,103.793,1.684,0.000},{500.000,712.999,81.535,0.000,0.000,0.000,0.000})
JOINTTARGET("K40_CLS",{80.999,24.004,51.038,7.492,99.695,137.196,0.000},{500.000,712.998,81.535,0.000,0.000,0.000,0.000})
JOINTTARGET("K50_CLS",{80.999,24.004,51.038,7.492,69.290,137.196,0.000},{500.000,712.998,81.535,0.000,0.000,0.000,0.000})
JOINTTARGET("KGRAB",{80.999,24.004,51.038,7.492,68.728,137.196,0.000},{500.000,496.100,496.100,0.000,0.000,0.000,0.000})
JOINTTARGET("KScrew1",{372.203,70.510,30.994,7.493,-20.760,68.179,0.000},{500.000,712.996,81.534,0.000,0.000,0.000,0.000})
JOINTTARGET("KScrew2",{371.374,101.265,30.994,7.493,-20.760,68.179,0.000},{500.000,712.996,81.534,0.000,0.000,0.000,0.000})
JOINTTARGET("KScrew3",{444.864,101.265,30.994,7.493,-20.760,68.179,0.000},{500.000,712.996,81.534,0.000,0.000,0.000,0.000})
JOINTTARGET("KScrew4",{444.864,70.510,30.994,7.493,-20.760,68.179,0.000},{500.000,712.996,81.534,0.000,0.000,0.000,0.000})
JOINTTARGET("LSQ_home",{10.000,10.000,10.000,10.000,470.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_1",{26.272,24.788,69.682,7.491,127.800,78.500,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_2",{26.272,24.788,69.682,7.491,127.800,109.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_3",{26.272,24.788,69.682,7.491,-5.000,109.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("M5_4",{26.272,24.788,69.682,7.491,-5.000,77.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("OP90_Home",{26.272,24.788,69.682,7.491,77.898,5.258,0.000},{8.988,46.005,46.373,0.000,0.000,0.000,0.000})
JOINTTARGET("SHIFT_1",{80.999,24.004,51.038,7.492,68.728,137.196,0.000},{9.000,496.100,496.100,0.000,0.000,0.000,0.000})
JOINTTARGET("SHIFT_2",{80.999,24.004,51.038,7.492,68.728,137.196,0.000},{729.000,496.100,496.100,0.000,0.000,0.000,0.000})
ROBTARGET("P20",{125.970,-73.880,-38.840},{0.999231,0.003845,0.038929,0.002773},{0,0,0,0},{9.000,46.005,46.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P30",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,766.744,46.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P40",{125.970,-73.880,-38.840},{0.999231,0.003845,0.038929,0.002773},{0,0,0,0},{9.000,46.005,46.000,0.000,0.000,0.000,0.000},0.000)
ROBTARGET("P50",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,46.000,650.000,0.000,0.000,0.000,0.000},0.000)
end
print("The end!")