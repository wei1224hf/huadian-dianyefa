--OP80工站 先导阀装配

--[[
request：  AO
0 默认值
1 请求执行 3轴桁架螺丝口定位
2 请求执行 进料盘 叉入动作
3 请求执行 出口盘 叉出动作
4 请求执行 进料盘 叉出动作
5 请求执行 2轴桁架给先导阀顶螺丝 动作
6 请求执行 阀体上打螺丝
7 请求执行 初始化状态
8 请求执行 进料盘换盘
9 请求执行 2轴桁架释放先导阀
]]--


--横移气缸纠偏变量
FaTi_Kind = 0
Truss_x = 0

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
    M5_chuiru = 9,               -- 请求执行 M5螺丝吹入
}  

--将所有轴当前关节点位赋值给移动点
Keep_joint_yuan = 30
function Keep_joint(Joint_dian)
  Keep_joint_yuan = GetJointTarget("Xyzuvw")
  Joint_dian.robax.rax_1 = Keep_joint_yuan.robax.rax_1
  Joint_dian.robax.rax_2 = Keep_joint_yuan.robax.rax_2
  Joint_dian.robax.rax_3 = Keep_joint_yuan.robax.rax_3
  Joint_dian.robax.rax_4 = Keep_joint_yuan.robax.rax_4
  Joint_dian.robax.rax_5 = Keep_joint_yuan.robax.rax_5
  Joint_dian.robax.rax_6 = Keep_joint_yuan.robax.rax_6
  Joint_dian.extax.eax_1 = Keep_joint_yuan.extax.eax_1
  Joint_dian.extax.eax_2 = Keep_joint_yuan.extax.eax_2
  Joint_dian.extax.eax_3 = Keep_joint_yuan.extax.eax_3
end

--判断阀体种类
function Judeg_FaTi_Kind()
  FaTi_Kind = GetAI("request_vision")
end

--螺丝枪打螺丝函数
function LuoSiQiangDaKong()
  --螺丝打孔1
  Keep_joint(K20)
  K20.robax.rax_1 = 367.702
  K20.robax.rax_2 = 2.443
  K20.robax.rax_3 = 8.173
  MoveAbsJ(K20,v200,fine,tool0,wobj0,load0)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  Sleep(5000)
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  flag=WaitDI("DI_LuoSiQiang_shangshen",1,6000,true)
  if flag then
    TPWrite("DI_LuoSiQiang_shangshen_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --螺丝打孔2
  Keep_joint(K30)
  K30.robax.rax_1 = 368.582
  K30.robax.rax_2 = 32.103
  MoveAbsJ(K30,v200,fine,tool0,wobj0,load0)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  Sleep(5000)
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  flag=WaitDI("DI_LuoSiQiang_shangshen",1,6000,true)
  if flag then
    TPWrite("DI_LuoSiQiang_shangshen_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --螺丝打孔3
  Keep_joint(K40)
  K40.robax.rax_1 = 443.266
  K40.robax.rax_2 = 32.487
  MoveAbsJ(K40,v200,fine,tool0,wobj0,load0)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  Sleep(5000)
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  flag=WaitDI("DI_LuoSiQiang_shangshen",1,6000,true)
  if flag then
    TPWrite("DI_LuoSiQiang_shangshen_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --螺丝打孔4
  Keep_joint(K50)
  K50.robax.rax_1 = 443.259
  K50.robax.rax_2 = 2.626
  MoveAbsJ(K50,v200,fine,tool0,wobj0,load0)
  SetDO("DO_NJQ_ShenChu",1)
  SetDO("DO_NJQ_SuoHui",0)
  Sleep(5000)
  SetDO("DO_NJQ_SuoHui",1)
  SetDO("DO_NJQ_ShenChu",0)
  flag=WaitDI("DI_LuoSiQiang_shangshen",1,6000,true)
  if flag then
    TPWrite("DI_LuoSiQiang_shangshen_shibai")
    SetDO("DO_FengLiao",1)
    stop()
  end
end

function LuoSi_Chuiru()
  SetDO("DO_M5_FenLi",1)
  WaitDI("DI_M5_LuoSi_fenli_dakai",0)
  WaitDI("DI_M5_LuoSi_fenli_guanbi",1)
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
  Keep_joint(OP90_Home)
  OP90_Home.extax.eax_2 = 46.000
  OP90_Home.extax.eax_3 = 46.000
  TPWrite("OP90_Home点当前坐标",OP90_Home)
  --下降外轴2（右升降机）,其它轴为原点位置
  MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
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
  local ret = SearchL("DI_R_ShenJiang_DaoWei",1,P20,P30,v20,tool0,wobj0,load0,0)
  if false==ret then
    TPWrite("Sheng Jiang Ji Dao Wei Xin Hao Shi Bai!")
    SetDO("DO_FengLiao",1)
    stop()
  end
end

--进料盘叉出
function JinLiaoPan_ChaChu()
  Keep_joint(OP90_Home)
  OP90_Home.extax.eax_2 = 46.000
  --下降外轴2（左升降机）,其它轴为原点位置
  MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
  SetAO("response",3)
  SetDO("DO_R_GunTong_jinru",0)
  SetDO("DO_R_GunTong_tuichu",1)
  if WaitDI("DI_R_GunTong_DaoWei",1,8000,true) then
    TPWrite("DI_R_GunTong_DaoWei shi bai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --等一个AGV小车接收到料盘的信号
  --WaitAI("AGV_Daowei","LT",1,2000)
  SetDO("DO_R_GunTong_tuichu",0)
end

--出料盘叉出
function ChuLiaoPan_ChaChu()
  Keep_joint(OP90_Home)
  OP90_Home.extax.eax_3 = 46.000
  --下降外轴3（左升降机）,其它轴为原点位置
  MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
  SetDO("DO_L_GunTong_jinru",0)
  SetDO("DO_L_GunTong_SongChu",1)
  if WaitDI("DI_L_GunTong_DaoWei",1,8000,true) then
    TPWrite("DI_L_GunTong_DaoWei Shi Bai")
    SetDO("DO_FengLiao",1)
    stop()
  end
  --等一个AGV小车接收到料盘的信号
  --WaitAI("AGV_Daowei","GT",1,2000)
  SetDO("DO_L_GunTong_tuichu",0)
  SetDO("DO_L_GunTong_jinru",0)
end

--进料盘换盘
function JingLiaoPan_Change()
  --料盘抓打开
  SetDO("DO_ZhuaPan_GuanBi",0)
  SetDO("DO_ZhuaPan_DaKai",1)

  Keep_joint(OP90_Home)
  OP90_Home.extax.eax_1 = 9.000
  OP90_Home.extax.eax_2 = 46.000
  OP90_Home.extax.eax_3 = 46.000
  MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
  if GetDI("DI_R_ShenJiang_DaoWei") == 1 or GetDI("DI_L_ShenJiang_DaoWei") == 1 then
    TPWrite("不满足换盘条件，需要升降机到最低点")
  end

  local ret = SearchL("DI_R_ShenJiang_DaoWei",1,P20,P30,v20,tool0,wobj0,load0,0)
  if false==ret then
    TPWrite("Sheng Jiang Ji Dao Wei Xin Hao Shi Bai!")
    SetDO("DO_FengLiao",1)
    Stop()
  end
  
  if GetDI("DI_R_ShenJiang_DaoWei") == 1 then
    SetDO("DO_ZhuaPan_GuanBi",0)
    SetDO("DO_ZhuaPan_DaKai",1)
    Keep_joint(K10)
    K10.extax.eax_2 = K10.extax.eax_2 + 83
    K10.extax.eax_1 = 733.000
    --进料口托盘上移到抓取位置
    TPWrite("进料口托盘上移到抓取位置",K10)
    MoveAbsJ(K10,v200,fine,tool0,wobj0,load0)
  end
  
  SetDO("DO_ZhuaPan_GuanBi",1)
  SetDO("DO_ZhuaPan_DaKai",0)
  WaitDI("DI_ZhuaPan2_GuanBiWei",1)
  WaitDI("DI_ZhuaPan1_GuanBiWei",1)
  WaitDI("DI_ZhuaPan1_DaKaiDaoWei",0)
  WaitDI("DI_ZhuaPan2_DaKaiDaoWei",0)
  if GetDI("DI_ZhuaPan2_GuanBiWei") == 1 and GetDI("DI_ZhuaPan1_GuanBiWei") == 1 then
    --进料口托盘下降位置
    K10.extax.eax_2 = K10.extax.eax_2 - 200
    MoveAbsJ(K10,v200,fine,tool0,wobj0,load0)
  end
  Sleep(200)
  K10.extax.eax_1 = 9.000
  MoveAbsJ(K10,v200,fine,tool0,wobj0,load0)
  
  if GetDI("DI_L_ShenJiang_DaoWei") == 0 then
    Keep_joint_yuan = GetJointTarget("Xyzuvw")
    P40.extax.eax_2 = Keep_joint_yuan.extax.eax_2
    P50.extax.eax_2 = Keep_joint_yuan.extax.eax_2
    local ret = SearchL("DI_L_ShenJiang_DaoWei",1,P40,P50,v20,tool0,wobj0,load0,0)
    if false==ret then
      Keep_joint(K20)
      K20.extax.eax_3 = 765
      TPWrite(K20)
      MoveAbsJ(K20,v200,fine,tool0,wobj0,load0)
    end
  else
    TPWrite("出料盘已满！")
    Stop()
  end
  
  Keep_joint(K20)
  if GetDI("DI_L_ShenJiang_DaoWei") == 1 then
    K20.extax.eax_3 = K20.extax.eax_3 + 66
    TPWrite(K20)
  end
  MoveAbsJ(K20,v200,fine,tool0,wobj0,load0)
  
  SetDO("DO_ZhuaPan_GuanBi",0)
  SetDO("DO_ZhuaPan_DaKai",1)
  WaitDI("DI_ZhuaPan2_GuanBiWei",0)
  WaitDI("DI_ZhuaPan1_GuanBiWei",0)
  WaitDI("DI_ZhuaPan1_DaKaiDaoWei",1)
  WaitDI("DI_ZhuaPan2_DaKaiDaoWei",1)
  if GetDI("DI_ZhuaPan1_DaKaiDaoWei") == 1 and GetDI("DI_ZhuaPan2_DaKaiDaoWei") == 1 and GetDI("DI_ZhuaPan2_GuanBiWei") == 0 and GetDI("DI_ZhuaPan1_GuanBiWei") == 0 then
    --出料口托盘下降位置
    K20.extax.eax_3 = 46.000
    K20.extax.eax_2 = 46.000
    MoveAbsJ(K20,v200,fine,tool0,wobj0,load0)
  end
  Sleep(200)
  
  if GetJointTarget("Xyzuvw").extax.eax_1 <=15 then 
    Keep_joint(OP90_Home)
    OP90_Home.extax.eax_2 = 46.000
    MoveAbsJ(OP90_Home,v200,fine,tool0,wobj0,load0)
    local ret = SearchL("DI_R_ShenJiang_DaoWei",1,P20,P30,v20,tool0,wobj0,load0,0)
    if false==ret then
      TPWrite("Sheng Jiang Ji Dao Wei Xin Hao Shi Bai!")
      SetDO("DO_FengLiao",1)
      Stop()
    end
  end


end

--执行M5螺丝吹入
function M5_LuoSi_ChuiRu()
  --M5送料关闭
  SetDO("DO_M5_TouLiao",1)
  --home点
  Keep_joint(FenLi_home)
  FenLi_home.robax.rax_5 = 62.335
  FenLi_home.robax.rax_6 = 2.021
  MoveAbsJ(FenLi_home,v100,fine,tool0,wobj0,load0)
  --M5螺丝孔1
  Keep_joint(M5_1)
  M5_1.robax.rax_5 = 127.800
  M5_1.robax.rax_6 = 78.500
  MoveAbsJ(M5_1,v100,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔2
  Keep_joint(M5_2)
  M5_2.robax.rax_5 = 127.800
  M5_2.robax.rax_6 = 109.000
  MoveAbsJ(M5_2,v100,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔3
  Keep_joint(M5_3)
  M5_3.robax.rax_5 = -5.000
  M5_3.robax.rax_6 = 109.000
  MoveAbsJ(M5_3,v100,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --M5螺丝孔4
  Keep_joint(M5_4)
  M5_4.robax.rax_5 = -5.000
  M5_4.robax.rax_6 = 77.000
  MoveAbsJ(M5_4,v100,fine,tool0,wobj0,load0)
  LuoSi_Chuiru()
  --home点
  MoveAbsJ(FenLi_home,v100,fine,tool0,wobj0,load0)
  SetAO("response",9)
end

--执行M6螺丝吹入
function M6_LuoSi_ChuiRu()

end

--打螺丝
function XianDao_DLS()
  local position = {156.126,204.901,254.151,293.954,334.344,374.427,414.465,454.486}
  Keep_joint(K10)
  K10.robax.rax_4 = position[GetAI("index_assembled")]
  MoveAbsJ(K10,v200,fine,tool0,wobj0,load0)
  LuoSiQiangDaKong()
end

function main()
  while (1) do
    Sleep(200)
    if GetAI("request") == 0 then
      Sleep(200)
      if GetAI("request") == RequestEnum.MOVE_TO_3_AXIS_SCREW_POSITION then
        --request 1:回OP90_Home点。执行3轴桁架螺丝扣定位
        Gohome()
        --正在执行3轴桁架横移气缸定位
        SetAO("response",1)
        --执行横移气缸定位拍照
        HengYi_Vision(FaTi_Kind)
        SetAO("response",101)

      elseif GetAI("request") == RequestEnum.FEED_TRAY_FORK_IN then
        -- request 2:执行进料盘叉入
        SetAO("response",2)
        JinLiaoPan_ChaRu()
        SetAO("response",102)

      elseif GetAI("request") == RequestEnum.EXIT_TRAY_FORK_OUT then
        --request 3:执行出口盘叉出
        SetAO("response",3)
        -- ChuLiaoPan_ChaChu()
        SetAO("response",103)

      elseif GetAI("request") == RequestEnum.FEED_TRAY_FORK_OUT then
        --request 4:执行进料盘叉出
        SetAO("response",4)
        -- JinLiaoPan_ChaChu()
        SetAO("response",104)

      elseif GetAI("request") == RequestEnum.MOVE_2_AXIS_TO_PILOT_VALVE then
        --request 5:M6螺丝吹入
        SetAO("response",5)
        -- M5_LuoSi_ChuiRu()
        SetAO("response",105)

      elseif GetAI("request") == RequestEnum.SCREW_ON_VALVE_BODY then
        --request 6:阀体上打螺丝
        SetAO("response",6)
        XianDao_DLS()
        SetAO("response",106)

      elseif GetAI("request") == RequestEnum.INITIALIZE_STATE then
        --request 7:初始化
        SetAO("response",7)

        SetAO("response",107)

      elseif GetAI("request") == RequestEnum.CHANGE_FEED_TRAY then
        --request 8:进料盘换盘
        SetAO("response",8)
        JingLiaoPan_Change()
        SetAO("response",108)
      elseif GetAI("request") == RequestEnum.M5_chuiru then
        --request 9:M5螺丝吹入
        SetAO("response",9)
        M5_LuoSi_ChuiRu()
        SetAO("response",109)
      end
    end
  end
end

main()

local function GLOBALDATA_DEFINE()
  JOINTTARGET("OP90_Home",{26.272,24.788,69.682,7.491,77.898,5.258,0.000},{8.988,46.005,46.373,0.000,0.000,0.000,0.000})
  JOINTTARGET("K10",{26.273,24.786,69.694,7.491,77.898,5.256,0.000},{9.000,46.169,46.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("K20",{26.273,24.786,69.694,7.491,77.898,5.256,0.000},{9.000,46.169,46.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("FenLi_home",{26.272,24.788,69.682,7.491,62.335,2.021,0.000},{9.000,46.000,46.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("HengYi_Paizhao",{359.173,54.782,69.704,7.491,77.891,5.253,0.000},{8.988,46.006,46.372,0.000,0.000,0.000,0.000})
  JOINTTARGET("LSQ_home",{10.000,10.000,10.000,10.000,470.000,0.000,0.000},{0.000,0.000,0.000,0.000,0.000,0.000,0.000})
  JOINTTARGET("M5_1",{26.272,24.788,69.682,7.491,127.800,78.500,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
  JOINTTARGET("M5_2",{26.272,24.788,69.682,7.491,127.800,109.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
  JOINTTARGET("M5_3",{26.272,24.788,69.682,7.491,-5.000,109.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
  JOINTTARGET("M5_4",{26.272,24.788,69.682,7.491,-5.000,77.000,0.000},{9.000,46.373,46.373,0.000,0.000,0.000,0.000})
  ROBTARGET("P20",{125.970,-73.880,-38.840},{0.999231,0.003845,0.038929,0.002773},{0,0,0,0},{9.000,46.005,46.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P30",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,766.744,46.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P40",{125.970,-73.880,-38.840},{0.999231,0.003845,0.038929,0.002773},{0,0,0,0},{9.000,46.005,46.000,0.000,0.000,0.000,0.000},0.000)
  ROBTARGET("P50",{125.970,-73.880,-38.820},{0.999231,0.003845,0.038929,0.002772},{0,0,0,0},{9.000,46.000,650.000,0.000,0.000,0.000,0.000},0.000)
  JOINTTARGET("DLS_1",{65.201,8.410,8.033,156.126,77.897,5.254,0.000},{8.998,681.212,46.044,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_2",{65.196,8.411,8.076,204.901,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_3",{65.196,8.411,8.076,254.151,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_4",{65.196,8.411,8.076,293.954,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_5",{65.196,8.411,8.076,334.344,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_6",{65.196,8.411,8.076,374.427,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_7",{65.196,8.411,8.076,414.465,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
  JOINTTARGET("DLS_8",{65.196,8.411,8.076,454.486,77.894,5.250,0.000},{8.998,681.211,46.043,0.000,0.000,0.000,0.000})
end
print("The end!")