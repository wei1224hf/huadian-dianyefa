-- 0: 通电初始化状态         1: 工位调机状态(手动) 
-- 20: 自动-接受调度(联网)   21:工位已运行，机器人准备就绪 
-- 30:工位进入加工流程，自动联网模式    32:工位进入加工流程，自动单机模式
-- 4:工位完成一个加工动作进入待机       5: 工位故障状态

curState = 0 --当前状态

function StateInit() --0
   if GetDO("SYS_PGM_EXEC_ERROR") == 1 and GetAO("error_code") ~= 0 then
      curState = 5
	  ECI.stop_program()  --停机处理
   elseif GetDO("SYS_MANUAL_MODE") == 1 then
      curState = 1
   elseif GetDO("SYS_AUTO_MODE") == 1 and GetDI("DI_Lianji") == 1 and GetDO("SYS_MOTOR_STATE") == 0 then
      curState = 20
   elseif GetDO("SYS_AUTO_MODE") == 1 and GetDI("DI_Lianji") == 1 and  GetDI("DI_HengYi_YouLiao") == 0 and  GetDI("DI_HengYi_SongKaiDaoWei") == 1 and GetDO("SYS_MOTOR_STATE") == 1 and GetDO("SYS_PGM_RUN_STATE") == 1 and GetDO("Home") == 1 and GetDO("work_over") == 0 then
      curState = 21
   elseif GetDO("SYS_AUTO_MODE") == 1 and GetDI("DI_Lianji") == 1 and  GetDI("DI_HengYi_YouLiao") == 1 and  GetDI("DI_HengYi_SongKaiDaoWei") == 1 and GetDO("SYS_MOTOR_STATE") == 1 and GetDO("SYS_PGM_RUN_STATE") == 1 and GetDO("Home") == 1 and GetDO("work_over") == 0 then
      curState = 22
   elseif GetDO("SYS_AUTO_MODE") == 1 and GetDI("DI_Lianji") == 1  and  GetDI("DI_HengYi_YouLiao") == 1 and  GetDI("DI_HengYi_SongKaiDaoWei") == 0 and GetDO("SYS_MOTOR_STATE") == 1 and GetDO("SYS_PGM_RUN_STATE") == 1 and GetDO("Home") == 0 then
      curState = 30
   elseif GetDO("SYS_AUTO_MODE") == 1 and GetDI("DI_Lianji") == 0  and  GetDI("DI_HengYi_YouLiao") == 1 and  GetDI("DI_HengYi_SongKaiDaoWei") == 0 and GetDO("SYS_MOTOR_STATE") == 1 and GetDO("SYS_PGM_RUN_STATE") == 1 and GetDO("Home") == 0 then
      curState = 32
   elseif GetDO("SYS_AUTO_MODE") == 1 and GetDI("DI_Lianji") == 1 and GetDO("work_over") == 1 and GetDO("SYS_MOTOR_STATE") == 1 and GetDO("SYS_PGM_RUN_STATE") == 1 and GetDO("Home") == 1 then
      curState = 4
	else
	curState = 20
   end  
end


SetDO("bg2_ready",1)	
while(1) do
  StateInit() --0
  SetAO("status",curState)
  Sleep(100)
  if GetDI("DI_Error_Fuwei") == 1 then
     SetAO("error_code",0)
  end
   if GetDI("DI_HengYi_YouLiao") == 0 then
      SetDO("work_over",0)
   end
end

local function GLOBALDATA_DEFINE()

end
print("The end!")