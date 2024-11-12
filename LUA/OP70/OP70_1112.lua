require "SocketApi"
local socketName = "sock1"
local retValL = false
local receivedDataL = nil

local exist_Left
local exist_Right
local Vision_First
local Vision_First_ce1
local Vision_First_ce2
local Vision_First_hou
local rax_1 = 0
local rax_2 = 0
local rax_3 = 0
local rax_4 = 0
local rax_5 = 0
local rax_6 = 0

local rax2_1 = 0
local rax2_2 = 0
local rax2_3 = 0
local rax2_4 = 0
local rax2_5 = 0
local rax2_6 = 0

local rax3_1 = 0
local rax3_2 = 0
local rax3_3 = 0
local rax3_4 = 0
local rax3_5 = 0
local rax3_6 = 0
--视觉偏移值
local offset_vision_1 = 0
local offset_vision_2 = 0
local offset_vision_5 = 0
local offset_vision_6 = 0

--后方螺丝偏移值
local offset_rear1 = 19
local offset_rear2 = 30
local offset_rear3 = 21
local offset_rear_D = 0
local offset_rear_E = 0.06
--上方螺丝偏移量
local offset_rearA = 19
local offset_rearB = 30
local offset_rearC = 21
local offset_rear_U = 0

local ce1_rax_5 = 0
local ce2_rax_5 = 0
local ce1_rax_6 = 0
local ce2_rax_6 = 0
local ce3_rax_5 = 0
local ce3_rax_6 = 0
local ce1_rax_4 = 0
local ce2_rax_4 = 0
local ce3_rax_4 = 0

local cycle_index = 1

function JointOffs(point, r_offs1, r_offs2, r_offs3, r_offs4, r_offs5, r_offs6, r_offs7)
    local Destrobtgt = {}
    Destrobtgt.robax = {}
    Destrobtgt.extax = {}
    Destrobtgt.robax.rax_1 = point.robax.rax_1 + r_offs1
    Destrobtgt.robax.rax_2 = point.robax.rax_2 + r_offs2
    Destrobtgt.robax.rax_3 = point.robax.rax_3 + r_offs3
    Destrobtgt.robax.rax_4 = point.robax.rax_4 + r_offs4
    Destrobtgt.robax.rax_5 = point.robax.rax_5 + r_offs5
    Destrobtgt.robax.rax_6 = point.robax.rax_6 + r_offs6
    Destrobtgt.robax.rax_7 = point.robax.rax_7 + r_offs7
    Destrobtgt.extax = point.extax
    TPWrite(Destrobtgt)
    return Destrobtgt
end

--local socketNameR = "sockR"
local retValR = false
local receivedDataR = nil

--字符串分割
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

--视觉SocketTCPIP通讯                              									
for i = 1, 5, 1 do
    retValL = SocketConnect(socketName, "192.168.105.231", 3333, 2000)
    if retValL == 1 then
        TPWrite(string.format("Socket connect successfully, server name: %s.", socketName))
        break
    else
        TPWrite(string.format("Socket connect failed, server name: %s.", socketName))
        Sleep(100)
    end
end

--左侧视觉定位
function LeftVisionPosition()
    retValL = SocketSend(socketName, "000025#0111@0009&0004,0,0;0000#", 2000) --触发拍照
    if retValL ~= 1 then
        TPWrite(string.format("Send failed: %d.", retValL))
        return --终止语句
    end

    retValL, receivedDataL = SocketReceive(socketName, 0, 30000) --机器人接收数据
    if retValL ~= 1 then
        TPWrite(string.format("Received failed: %d.", retValL))
        return
    end

    TPWrite("Received data: " .. receivedDataL)
    list_str = split(receivedDataL, ",") --di 1 ci yi yi , 分割
    if list_str[3] == "1" then
        exist_Left = 1
    else
        exist_Left = 0
        TPWrite("mei you jian ce dao") --没有检测到，跳出循环
        return
    end
end

--右侧视觉定位
function RightVisionPosition()
    retValR = SocketSend(socketName, "000025#0111@0009&0004,1,0;0000#", 2000) --触发拍照
    if retValR ~= 1 then
        TPWrite(string.format("Send failed: %d.", retValR))
        return --终止语句
    end

    retValR, receivedDataR = SocketReceive(socketName, 0, 30000) --机器人接收数据
    if retValR ~= 1 then
        TPWrite(string.format("Received failed: %d.", retValR))
        return
    end

    TPWrite("Received data: " .. receivedDataR)
    list_str = split(receivedDataR, ",") --di 1 ci yi yi , 分割
    if list_str[3] == "1" then
        exist_Right = 1
    else
        exist_Right = 0
        TPWrite("mei you jian ce dao") --没有检测到，跳出循环
        return
    end
end

--上方视觉定位
function UpVisionPosition()
    retValR = SocketSend(socketName, "000025#0111@0009&0004,3,0;0000#", 2000) --触发拍照
    if retValR ~= 1 then
        TPWrite(string.format("Send failed: %d.", retValR))
        return --终止语句
    end

    retValR, receivedDataR = SocketReceive(socketName, 0, 30000) --机器人接收数据
    if retValR ~= 1 then
        TPWrite(string.format("Received failed: %d.", retValR))
        return
    end

    TPWrite("Received data: " .. receivedDataR)
    list_str = split(receivedDataR, ",") --di 1 ci yi yi , 分割
    if tonumber(list_str[3]) == -1 or tonumber(list_str[4]) == -1 then
        TPWrite("mei you jian ce dao") --没有检测到，跳出循环
        Stop()
        return
    end
    offset_vision_2 = tonumber(list_str[4])
    TPWrite(offset_vision_2)
end

--下方视觉定位
function DownVisionPosition()
    retValR = SocketSend(socketName, "000025#0111@0009&0004,2,0;0000#", 2000) --触发拍照
    if retValR ~= 1 then
        TPWrite(string.format("Send failed: %d.", retValR))
        return --终止语句
    end

    retValR, receivedDataR = SocketReceive(socketName, 0, 30000) --机器人接收数据
    if retValR ~= 1 then
        TPWrite(string.format("Received failed: %d.", retValR))
        return
    end

    TPWrite("Received data: " .. receivedDataR)
    list_str = split(receivedDataR, ",") --di 1 ci yi yi , 分割
    if tonumber(list_str[3]) == -1 or tonumber(list_str[4]) == -1 then
        TPWrite("mei you jian ce dao") --没有检测到，跳出循环
        Stop()
        return
    end
    offset_vision_5 = tonumber(list_str[3])
    TPWrite(offset_vision_5)
end

--信号复位
function Init()
    SetDO("alarm_green", 0)
    SetDO("alarm_red", 0)
    SetDO("alarm_yellow", 0)
    SetDO("alarm_bee", 0)
    SetDO("L_baitai_xuanzhuan", 0)
    SetDO("R_deng", 0)
    --SetDO("R_zhendong",0)
    SetDO("L_deng", 0)
    --SetDO("L_zhendong",0)
    SetDO("R_baitai_jiazhua", 0)
    SetDO("L_baitai_jiazhua", 0)
    SetDO("shang_deng", 0)
    SetDO("shang_jiazhua", 0)
    SetDO("shang_tuigan", 0)
    SetDO("xia_deng", 0)
    SetDO("xia_tuigan", 0)
    SetDO("xia_jiazhua", 0)
    SetDO("zhong_qigang", 0)
    SetAO("Put_1", 2)
    SetAO("Put_2", 2)
    SetAO("screw_left_run", 0)
    SetAO("screw_right_run", 0)
    Vision_First = 0
    Vision_First_ce1 = 0
    Vision_First_ce2 = 0
    Vision_First_hou = 0
end

local function Wait_All_Ready()
    if GetDO("cur_code") == 1 then
        TPWrite("MAIN wait ready!")
        WaitDO("bg1_ready", 1)
        WaitDO("bg2_ready", 1)
        if GetDI("loader_placed") == 0 and GetDI("loader_gripper_songkai") == 0 then
            SetDO("work_ready", 1)
        end
        TPWrite("MAIN wait ready done!")
    end
end

function Gohome()
    local tmpJoint = GetJointTarget(0, tool0, wobj0)
    local P_GoHome = CopyJointTarget(tmpJoint)
    P_GoHome.robax.rax_3 = 15
    P_GoHome.robax.rax_4 = 3
    MoveAbsJ(P_GoHome, OP70_J, fine, tool0, wobj0, load0)
    local P_GoHome1 = CopyJointTarget(P_GoHome)
    P_GoHome.robax.rax_2 = 0
    P_GoHome.robax.rax_5 = 890
    MoveAbsJ(P_GoHome1, OP70_J, fine, tool0, wobj0, load0)

    MoveAbsJ(K_home, OP70_J, fine, tool0, wobj0, load0)
end

function IO_check_OFF(DO_set, Get_DI, code)
    for i = 1, 3, 1 do
        SetDO(DO_set, 0)
        WaitDI(Get_DI, 1, 6000, true)
        if GetDI(Get_DI) == 1 then
            break
        else
            Sleep(500)
            SetDO(DO_set, 1)
        end
    end
    if GetDI(Get_DI) == 0 then
        --SetAO("Error_code",code)
        --SetDO("alarm_bee",1)
        SetDO("alarm_red", 1)
        Stop()
    end
end

function IO_check_ON(DO_set, Get_DI, code)
    for i = 1, 3, 1 do
        SetDO(DO_set, 1)
        WaitDI(Get_DI, 1, 6000, true)
        if GetDI(Get_DI) == 1 then
            break
        else
            Sleep(500)
            SetDO(DO_set, 0)
        end
    end
    if GetDI(Get_DI) == 0 then
        --SetAO("Error_code",code)
        --SetDO("alarm_bee",1)
        SetDO("alarm_red", 1)
        Stop()
    end
end

function hou_yi()
    while true do
        MoveAbsJ(sync3_guodu2, v_op70, z10, tool0, wobj0, load0)
        MoveAbsJ(sync3_guodu3, v_op70, fine, tool0, wobj0, load0)
        --以下两个信号暂未添加，摆台信号在后台处理，确认摆台气缸到位

        WaitDI("L_baitai_jiajin", 1)
        Sleep(100)
        MoveAbsJ(sync3_quliao, OP70_J, fine, tool0, wobj0, load0)

        --L抓料过程气缸交互
        SetDO("xia_jiazhua", 1)
        IO_check_ON("xia_jiazhua", "xia_jiazhua_jiajin", 1)

        SetDO("L_baitai_jiazhua", 0)
        IO_check_OFF("L_baitai_jiajin", "L_jiazhua_songkai", 1)
        Sleep(200)

        --原路退出
        MoveAbsJ(sync3_guodu3, OP70_J, fine, tool0, wobj0, load0)
        SetDO("R_baitai_jiazhua", 0)
        IO_check_OFF("R_baitai_jiazhua", "R_baitai_songkai", 1)
        --检测胶圈
        SetDO("L_deng", 1)
        MoveAbsJ(work3_jiance, v_op70, fine, tool0, wobj0, load0)
        Sleep(500)
        LeftVisionPosition()
        RightVisionPosition()
        TPWrite(exist_Left)
        TPWrite(exist_Right)
        --判断若有则继续进行，若无，则重新运行
        if exist_Right == 0 then
            SetDO("xia_jiazhua", 0)
            SetDO("shang_jiazhua", 0)
            SetDO("L_baitai_xuanzhuan", 0)
            IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
            IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
            SetAO("Put_1", 2)
            SetAO("Put_2", 2)
        end
        if exist_Right == 1 then
            break
        end
    end

    MoveAbsJ(sync3_guodu4, v_op70, z10, tool0, wobj0, load0)
    SetDO("L_deng", 0)

    --抓取成功后，摆台复位
    SetDO("L_baitai_xuanzhuan", 0)
    IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
    SetAO("Put_1", 2)
    --视觉偏移值增加
    if Vision_First_hou == 0 then
        rax3_5 = rax3_5 + offset_vision_2
        Vision_First_hou = 1
    end
    --打螺丝前位置校正，螺丝放入工件
    --MoveAbsJ(sync3_jiaozheng,v_op70,fine,tool0,wobj0,load0)
    --MoveAbsJ(sync3_shangjin,v_op70,fine,tool0,wobj0,load0)
    MoveAbsJ(JointOffs(sync3_jiaozheng, rax3_1, rax3_2, 0, 0, rax3_5, rax3_6, 0), v_op70, fine, tool0, wobj0, load0)
    MoveAbsJ(JointOffs(sync3_shangjin, rax3_1, rax3_2, 0, 0, rax3_5, rax3_6, 0), OP70_J, fine, tool0, wobj0, load0)
    SetDO("xia_tuigan", 1)
    Sleep(300)
    SetDO("xia_jiazhua", 0)
    IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
    SetAO("screw_left_run", 1)
    Sleep(1000)

    while true do
        if GetAI("screw_status_front") == 1 then
            SetAO("screw_left_run", 0)
            break
        elseif GetAI("screw_status_front") == 3 then
            SetAO("screw_left_run", 0)
            Sleep(500)
            SetAO("screw_left_reset", 1)
            Sleep(500)
            SetAO("screw_left_reset", 0)
            break
        end
        Sleep(500)
    end
    --IO_check_ON("xia_tuigan","xia_tuigan_shenzhan",1)
    SetAO("screw_left_run", 0)
    SetDO("xia_tuigan", 0)
    IO_check_OFF("xia_tuigan", "xia_tuigan_shousuo", 1)

    --完成一套动作，原路返回
    --MoveAbsJ(sync3_jiaozheng,v20,fine,tool0,wobj0,load0)
    MoveAbsJ(JointOffs(sync3_jiaozheng, rax3_1, rax3_2, 0, 0, rax3_5, rax3_6, 0), v_op70, z10, tool0, wobj0, load0)
    --MoveAbsJ(sync_work,v_op70,fine,tool0,wobj0,load0)
    --到达guodu1，执行下次流程
    MoveAbsJ(sync3_guodu1, v_op70, z10, tool0, wobj0, load0)
    SetAO("luosi_num", GetAO("luosi_num") + 1)
end

--机器人当前位置在home点
function Main()
    --luosi_num=39
    while GetAO("luosi_num") < 38 do
        while true do
            MoveAbsJ(sync_guodu2, v_op70, z10, tool0, wobj0, load0)
            MoveAbsJ(sync_guodu3, v_op70, fine, tool0, wobj0, load0)
            --以下两个信号暂未添加，摆台信号在后台处理，确认摆台气缸到位

            WaitDI("L_baitai_jiajin", 1)
            Sleep(100)
            WaitDI("R_baitai_jiajin", 1)
            Sleep(100)
            MoveAbsJ(sync_quliao, OP70_J, fine, tool0, wobj0, load0)

            --L抓料过程气缸交互
            SetDO("xia_jiazhua", 1)
            IO_check_ON("xia_jiazhua", "xia_jiazhua_jiajin", 1)

            SetDO("L_baitai_jiazhua", 0)
            IO_check_OFF("L_baitai_jiajin", "L_jiazhua_songkai", 1)

            Sleep(500)
            --R抓取气缸交互
            SetDO("shang_jiazhua", 1)
            IO_check_ON("shang_jiazhua", "shang_jiazhua_jiajin", 1)

            --原路退出
            MoveAbsJ(sync_guodu3, OP70_J, fine, tool0, wobj0, load0)
            SetDO("R_baitai_jiazhua", 0)
            IO_check_OFF("R_baitai_jiazhua", "R_baitai_songkai", 1)
            --检测胶圈
            MoveAbsJ(work_jiance, v_op70, fine, tool0, wobj0, load0)
            SetDO("R_deng", 1)
            Sleep(200)
            LeftVisionPosition()
            SetDO("R_deng", 0)
            SetDO("L_deng", 1)
            RightVisionPosition()
            SetDO("L_deng", 0)
            TPWrite(exist_Left)
            TPWrite(exist_Right)
            --判断若有则继续进行，若无，则重新运行
            if exist_Left == 0 or exist_Right == 0 then
                SetDO("xia_jiazhua", 0)
                SetDO("shang_jiazhua", 0)
                SetDO("L_baitai_xuanzhuan", 0)
                IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
                IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
                SetAO("Put_1", 2)
                SetAO("Put_2", 2)
            end
            if exist_Left == 1 and exist_Right == 1 then
                break
            end
        end

        MoveAbsJ(K60, v_op70, z50, tool0, wobj0, load0)

        --抓取成功后，摆台复位
        SetDO("L_baitai_xuanzhuan", 0)
        IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
        SetAO("Put_1", 2)
        SetAO("Put_2", 2)

        --到达拍照位
        if Vision_First == 0 then
            MoveAbsJ(sync_work, v_op70, fine, tool0, wobj0, load0)
            SetDO("xia_deng", 1)
            SetDO("shang_deng", 1)
            Sleep(1000)
            --执行拍照流程
            UpVisionPosition()
            DownVisionPosition()
            --视觉偏移值增加
            rax_2 = rax_2 + offset_vision_2
            rax_5 = rax_5 + offset_vision_2
            rax2_2 = rax2_2 + offset_vision_2
            rax2_5 = rax2_5 + offset_vision_2
            TPWrite(rax_2)
            TPWrite(rax_5)
            Vision_First = 1
        end
        --MoveAbsJ(sync_jiaozheng,v_op70,fine,tool0,wobj0,load0)
        --MoveAbsJ(sync_shangjin,v_op70,fine,tool0,wobj0,load0)
        if GetAO("luosi_num") == 36 then
            --MoveAbsJ(sync2_jiaozheng,v_op70,fine,tool0,wobj0,load0)
            --MoveAbsJ(sync2_shangjin,v_op70,fine,tool0,wobj0,load0)
            MoveAbsJ(JointOffs(sync2_jiaozheng, rax2_1, rax2_2, -50, -50, rax2_5, rax2_6, 0), v_op70, fine, tool0, wobj0,
                load0)
            MoveAbsJ(JointOffs(sync2_shangjin, rax2_1, rax2_2, 0, 0, rax2_5, rax2_6, 0), OP70_J, fine, tool0, wobj0,
                load0)
        else
            MoveAbsJ(JointOffs(sync_jiaozheng, rax_1, rax_2, -50, -50, rax_5, rax_6, 0), v_op70, fine, tool0, wobj0,
                load0)
            --打螺丝，螺丝上紧
            MoveAbsJ(JointOffs(sync_shangjin, rax_1, rax_2, 0, 0, rax_5, rax_6, 0), OP70_J, fine, tool0, wobj0, load0)
        end
        SetDO("xia_deng", 0)
        SetDO("shang_deng", 0)
        --松开夹爪
        SetDO("shang_jiazhua", 0)
        IO_check_OFF("shang_jiazhua", "shang_jiazhua_songkai", 1)
        SetDO("xia_tuigan", 1)
        Sleep(800)
        SetDO("xia_jiazhua", 0)
        IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
        SetAO("screw_right_run", 1)
        SetAO("screw_left_run", 1)
        Sleep(200)
        --推杆移动,上紧螺丝
        SetDO("shang_tuigan", 1)
        Sleep(1000)

        while true do
            if GetAI("screw_status_front") == 1 and GetAI("screw_status_side") == 1 then
                SetAO("screw_right_run", 0)
                Sleep(100)
                SetAO("screw_left_run", 0)
                break
            elseif GetAI("screw_status_front") == 3 or GetAI("screw_status_side") == 3 then
                SetAO("screw_right_run", 0)
                Sleep(500)
                SetAO("screw_left_run", 0)
                Sleep(500)
                if GetAI("screw_status_front") == 3 then
                    SetAO("screw_left_reset", 1)
                    Sleep(500)
                    SetAO("screw_left_reset", 0)
                end

                if GetAI("screw_status_side") == 3 then
                    SetAO("screw_right_reset", 1)
                    Sleep(500)
                    SetAO("screw_right_reset", 0)
                end
                break
            end
            Sleep(500)
        end
        --IO_check_ON("shang_tuigan","shang_tuigan_shenzhan",1)
        --IO_check_ON("xia_tuigan","xia_tuigan_shenzhan",1)
        --推杆上紧后复位
        SetDO("xia_tuigan", 0)
        --IO_check_OFF("xia_tuigan","xia_tuigan_shousuo",1)
        SetDO("shang_tuigan", 0)
        IO_check_OFF("shang_jiazhua", "shang_tuigan_shousuo", 1)

        --完成一套动作，原路返回
        if GetAO("luosi_num") == 36 then
            MoveAbsJ(JointOffs(sync2_jiaozheng, rax2_1, rax2_2, -50, -50, rax2_5, rax2_6, 0), v_op70, z10, tool0, wobj0,
                load0)
        else
            MoveAbsJ(JointOffs(sync_jiaozheng, rax_1, rax_2, -50, -50, rax_5, rax_6, 0), v_op70, z10, tool0, wobj0, load0)
        end
        --偏置值		

        if cycle_index <= 4 then
            if cycle_index % 2 == 1 then
                offset_rear_D = offset_rear1
            else
                offset_rear_D = offset_rear2
            end
        else
            if cycle_index % 2 == 1 then
                offset_rear_D = offset_rear1
            else
                offset_rear_D = offset_rear3
            end
        end

        if cycle_index >= 14 then
            if cycle_index % 2 == 1 then
                offset_rear_U = offset_rearA
            else
                offset_rear_U = offset_rearB
            end
        else
            if cycle_index % 2 == 1 then
                offset_rear_U = offset_rearA
            else
                offset_rear_U = offset_rearC
            end
        end
        TPWrite(offset_rear_U)
        TPWrite(offset_rear_D)
        rax_2 = offset_vision_2 +  GetAO("luosi_num")/2 * offset_rear_U
        rax_5 = offset_vision_2 - GetAO("luosi_num")/2 * offset_rear_D
        rax_6 = 0 - GetAO("luosi_num")/2 * offset_rear_E
        cycle_index = 1 + GetAO("luosi_num")/2
        SetAO("luosi_num",GetAO("luosi_num") + 2)
        --MoveAbsJ(sync_work,v_op70,fine,tool0,wobj0,load0)
        --到达guodu1，执行下次流程
        --MoveAbsJ(sync_guodu1,v200,fine,tool0,wobj0,load0)
    end
    if GetAO("luosi_num") == 38 then
        hou_yi()
    end
    --侧方四颗拧紧
    if GetAO("luosi_num") >= 39 then
        for i = 1, 3, 1 do
            while true do
                MoveAbsJ(cebian_guodu1, XuanZhuan, z10, tool0, wobj0, load0)
                MoveAbsJ(cebian_guodu2, v_op70, fine, tool0, wobj0, load0)
                MoveAbsJ(cebian_quliao, OP70_J, fine, tool0, wobj0, load0)
                WaitDI("L_baitai_jiajin", 1)
                Sleep(100)
                SetDO("xia_jiazhua", 1)
                IO_check_ON("xia_jiazhua", "xia_jiazhua_jiajin", 1)
                SetDO("L_baitai_jiazhua", 0)
                IO_check_OFF("L_baitai_jiajin", "L_jiazhua_songkai", 1)
                Sleep(500)
                MoveAbsJ(cebian_guodu2, OP70_J, fine, tool0, wobj0, load0)
                SetDO("L_deng", 1)
                MoveAbsJ(cebian_jiance, v_op70, fine, tool0, wobj0, load0)
                Sleep(500)
                RightVisionPosition()
                --判断若有则继续进行，若无，则重新运行
                if exist_Right == 0 then
                    SetDO("xia_jiazhua", 0)
                    IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
                    SetDO("L_baitai_xuanzhuan", 0)
                    IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
                    SetAO("Put_1", 2)
                    SetAO("Put_2", 2)
                end
                if exist_Right == 1 then
                    break
                end
            end
            SetDO("L_deng", 0)
            MoveAbsJ(cebian_guodu1, v_op70, z10, tool0, wobj0, load0)
            SetDO("L_baitai_xuanzhuan", 0)
            IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
            SetAO("Put_1", 2)

            --MoveAbsJ(cebian1_jiejin,v_op70,fine,tool0,wobj0,load0)
            --MoveAbsJ(cebian1_ningjin,v_op70,fine,tool0,wobj0,load0)
            if Vision_First_ce1 == 0 then
                ce1_rax_4 = ce1_rax_4 - offset_vision_2
                ce3_rax_4 = ce3_rax_4 - offset_vision_2
                Vision_First_ce1 = 1
            end
            if GetAO("luosi_num") == 41 then
                --MoveAbsJ(cebian3_jiejin,v50,fine,tool0,wobj0,load0)
                --MoveAbsJ(cebian3_ningjin,v20,fine,tool0,wobj0,load0)
                MoveAbsJ(JointOffs(cebian3_jiejin, 0, 0, 0, ce3_rax_4, ce3_rax_5, ce3_rax_6, 0), v_op70, fine, tool0,
                    wobj0, load0)
                MoveAbsJ(JointOffs(cebian3_ningjin, 0, 0, 0, ce3_rax_4, ce3_rax_5, ce3_rax_6, 0), OP70_J, fine, tool0,
                    wobj0, load0)
            else
                MoveAbsJ(JointOffs(cebian1_jiejin, 0, 0, 0, ce1_rax_4 - 50, ce1_rax_5, ce1_rax_6, 0), v_op70, fine, tool0,
                    wobj0, load0)
                MoveAbsJ(JointOffs(cebian1_ningjin, 0, 0, 0, ce1_rax_4, ce1_rax_5, ce1_rax_6, 0), OP70_J, fine, tool0,
                    wobj0, load0)
            end
            SetDO("xia_tuigan", 1)
            Sleep(300)
            SetDO("xia_jiazhua", 0)
            IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
            SetAO("screw_left_run", 1)
            Sleep(1000)
            while true do
                if GetAI("screw_status_front") == 1 then
                    SetAO("screw_left_run", 0)
                    break
                elseif GetAI("screw_status_front") == 3 then
                    SetAO("screw_left_run", 0)
                    Sleep(500)
                    SetAO("screw_left_reset", 1)
                    Sleep(500)
                    SetAO("screw_left_reset", 0)
                    break
                end
                Sleep(500)
            end
            --IO_check_ON("xia_tuigan","xia_tuigan_shenzhan",1)
            SetDO("xia_tuigan", 0)
            IO_check_OFF("xia_tuigan", "xia_tuigan_shousuo", 1)
            if GetAO("luosi_num") == 41 then
                MoveAbsJ(JointOffs(cebian3_jiejin, 0, 0, 0, ce3_rax_4, ce3_rax_5, ce3_rax_6, 0), v_op70, z10, tool0,
                    wobj0, load0)
            else
                MoveAbsJ(JointOffs(cebian1_jiejin, 0, 0, 0, ce1_rax_4, ce1_rax_5, ce1_rax_6, 0), v_op70, z10, tool0,
                    wobj0, load0)
            end
            MoveAbsJ(cebian_guodu1, v_op70, fine, tool0, wobj0, load0)

            ce1_rax_6 = 0 + (GetAO("luosi_num")-38) * 17.5
            SetAO("luosi_num",GetAO("luosi_num")+1)
        end

        --Moveabsj 外轴转动
        for i = 1, 2, 1 do
            while true do
                MoveAbsJ(cebian2_guodu1, XuanZhuan, z10, tool0, wobj0, load0)
                MoveAbsJ(cebian2_guodu2, v_op70, fine, tool0, wobj0, load0)
                MoveAbsJ(cebian2_quliao, OP70_J, fine, tool0, wobj0, load0)
                WaitDI("L_baitai_jiajin", 1)
                Sleep(100)
                SetDO("xia_jiazhua", 1)
                IO_check_ON("xia_jiazhua", "xia_jiazhua_jiajin", 1)
                SetDO("L_baitai_jiazhua", 0)
                Sleep(500)
                IO_check_OFF("L_baitai_jiajin", "L_jiazhua_songkai", 1)
                MoveAbsJ(cebian2_guodu2, OP70_J, fine, tool0, wobj0, load0)
                SetDO("L_deng", 1)
                MoveAbsJ(cebian2_jiance, v_op70, fine, tool0, wobj0, load0)
                Sleep(500)
                RightVisionPosition()
                --判断若有则继续进行，若无，则重新运行
                if exist_Right == 0 then
                    SetDO("xia_jiazhua", 0)
                    IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
                    SetDO("L_baitai_xuanzhuan", 0)
                    IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
                    SetAO("Put_1", 2)
                    SetAO("Put_2", 2)
                end
                if exist_Right == 1 then
                    break
                end
            end
            SetDO("L_deng", 0)
            MoveAbsJ(cebian2_guodu1, v_op70, z10, tool0, wobj0, load0)
            SetDO("L_baitai_xuanzhuan", 0)
            IO_check_OFF("L_baitai_xuanzhuan", "L_baitai_songkai", 1)
            SetAO("Put_1", 2)
            Sleep(300)
            SetAO("Put_2", 2)

            --MoveAbsJ(hou2_work,v_op70,fine,tool0,wobj0,load0)
            if Vision_First_ce2 == 0 then
                ce2_rax_4 = ce2_rax_4 + offset_vision_2
                --ce2_rax_5 = ce2_rax_5 + offset_vision_2
                Vision_First_ce2 = 1
            end
            --MoveAbsJ(K150,v_op70,fine,tool0,wobj0,load0)
            --MoveAbsJ(K160,v_op70,fine,tool0,wobj0,load0)
            MoveAbsJ(JointOffs(K150, 0, 0, 0, ce2_rax_4, ce2_rax_5, ce2_rax_6, 0), v_op70, fine, tool0, wobj0, load0)
            MoveAbsJ(JointOffs(K160, 0, 0, 0, ce2_rax_4, ce2_rax_5, ce2_rax_6, 0), OP70_J, fine, tool0, wobj0, load0)

            SetDO("xia_tuigan", 1)
            Sleep(300)
            SetDO("xia_jiazhua", 0)
            IO_check_OFF("xia_jiazhua", "xia_jiazhua_songkai", 1)
            SetAO("screw_left_run", 1)
            Sleep(1000)
            while true do
                if GetAI("screw_status_front") == 1 then
                    SetAO("screw_left_run", 0)
                    break
                elseif GetAI("screw_status_front") == 3 then
                    SetAO("screw_left_run", 0)
                    Sleep(100)
                    SetAO("screw_left_reset", 1)
                    Sleep(500)
                    SetAO("screw_left_reset", 0)
                    break
                end
                Sleep(500)
            end
            --IO_check_ON("xia_tuigan","xia_tuigan_shenzhan",1)
            SetDO("xia_tuigan", 0)
            IO_check_OFF("xia_tuigan", "xia_tuigan_shousuo", 1)
            MoveAbsJ(JointOffs(K150, 0, 0, 0, ce2_rax_4, ce2_rax_5, ce2_rax_6, 0), v_op70, z10, tool0, wobj0, load0)
            MoveAbsJ(cebian2_guodu1, v_op70, z10, tool0, wobj0, load0)

            ce2_rax_6 = 0 + (GetAO("luosi_num")-38)* 17.5
            SetAO("luosi_num",GetAO("luosi_num")+1)
        end
    end

    if GetAO("luosi_num") == 44 then
        --回到安全位置
        --输出已完成信号
        TPWrite("DAWAN")
        MoveAbsJ(K_home, v_op70, fine, tool0, wobj0, load0)
        Sleep(1500)
        SetDO("zhong_qigang", 0)
        SetDO("work_over", 1)
        Vision_First = 0
        Vision_First_ce1 = 0
        Vision_First_ce2 = 0
        Vision_First_hou = 0
        rax_1 = 0
        rax_2 = 0
        rax_3 = 0
        rax_4 = 0
        rax_5 = 0
        rax_6 = 0

        rax2_1 = 0
        rax2_2 = 0
        rax2_3 = 0
        rax2_4 = 0
        rax2_5 = 0
        rax2_6 = 0

        rax3_1 = 0
        rax3_2 = 0
        rax3_3 = 0
        rax3_4 = 0
        rax3_5 = 0
        rax3_6 = 0
        --视觉偏移值
        offset_vision_1 = 0
        offset_vision_2 = 0
        offset_vision_5 = 0
        offset_vision_6 = 0

        --后方螺丝偏移值
        offset_rear1 = 19
        offset_rear2 = 30
        offset_rear3 = 21
        offset_rear_D = 0
        --上方螺丝偏移量
        offset_rearA = 19
        offset_rearB = 30
        offset_rearC = 21
        offset_rear_U = 0

        ce1_rax_5 = 0
        ce2_rax_5 = 0
        ce1_rax_6 = 0
        ce2_rax_6 = 0
        ce3_rax_5 = 0
        ce3_rax_6 = 0
        ce1_rax_4 = 0
        ce2_rax_4 = 0
        ce3_rax_4 = 0
        cycle_index = 1
        SetAO("luosi_num", 0)
    end
end

--Wait_All_Ready()
Init()
Gohome()
SetDO("alarm_green", 1)
while (1) do
    if GetAI("LCS_command") == 70 then
        --SetDO("work_over",0)
        WaitDI("zhong_youliao", 1)
        Sleep(100)
        SetDO("zhong_qigang", 1)
        Main()
    end
    Sleep(100)
end

local function GLOBALDATA_DEFINE()
    LOADDATA("load2", 2.00, { 0.00, 0.00, 100.00 }, { 1.000000, 0.000000, 0.000000, 0.000000 }, 0.00, 0.00, 0.00, 0.00,
        0.00, 0.01)
    SPEEDDATA("SpdUser", 200.000, 50.000, 200.000, 50.000)
    JOINTTARGET("Home1", { 89.999, -85.001, -0.001, -8.001, -2.001, -79.999, 0.000 },
        { 50.062, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K10", { 50.000, 50.000, 50.000, 50.000, 460.000, 0.000, 0.000 },
        { 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K100", { 159.886, 12.738, 60.000, 162.136, 909.901, 47.000, 0.000 },
        { -0.181, 159.147, 47.375, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K110", { 159.886, 12.738, 60.000, 162.136, 909.901, 47.000, 0.000 },
        { -0.181, 159.147, 47.375, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K120", { 143.291, 312.516, 158.997, 231.521, 550.905, 30.897, 0.000 },
        { 0.191, 142.547, 31.269, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K130", { 143.551, 312.396, 113.651, 265.339, 551.169, 32.760, 0.000 },
        { 0.191, 142.675, 31.205, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K140", { 141.883, 51.663, 16.519, 42.663, 698.009, 48.559, 0.000 },
        { -90.115, 141.118, 45.460, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K150", { 141.883, 51.663, 16.519, 89.090, 502.947, 47.508, 0.000 },
        { -90.115, 141.442, 49.157, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K160", { 141.883, 51.663, 16.519, 147.160, 502.947, 47.508, 0.000 },
        { -90.115, 141.442, 49.157, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K20", { 100.000, 100.000, 100.000, 100.000, 480.000, 0.000, 0.000 },
        { 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K200", { 141.883, 51.663, 16.519, 144.260, 908.720, 259.274, 0.000 },
        { 90.194, 141.118, 256.175, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K220", { 141.883, 51.663, 16.519, 2.771, 831.388, 110.111, 0.000 },
        { 90.194, 141.118, 107.012, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K30", { 10.000, 10.000, 10.000, 10.000, 470.000, 0.000, 0.000 },
        { 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K40", { 157.684, 14.021, 361.738, 203.703, 909.618, 257.405, 0.000 },
        { -0.180, 157.641, 257.376, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K50", { 155.031, 392.981, 16.503, 149.305, 593.726, 60.769, 0.000 },
        { 0.200, 154.682, 62.130, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K60", { 47.679, 41.609, 57.525, 149.361, 831.388, 53.716, 0.000 },
        { -0.183, 47.679, 53.716, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K70", { 155.112, 392.987, 16.516, 272.720, 549.004, 30.157, 0.000 },
        { 0.196, 154.377, 30.563, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K80", { 143.551, 312.396, 113.651, 273.961, 548.184, 33.133, 0.000 },
        { 0.191, 142.784, 30.027, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K90", { 142.444, 314.341, 156.628, 273.634, 550.004, 31.157, 0.000 },
        { 0.196, 141.707, 31.539, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("K_home", { 17.607, -0.050, 16.519, 2.771, 891.116, 110.111, 0.000 },
        { 0.000, 17.607, 110.111, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("P_GoHome", { 17.607, -0.050, 16.519, 2.771, 891.116, 110.111, 0.000 },
        { 0.000, 16.844, 110.111, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("P_GoHome1", { 17.607, -0.050, 16.519, 2.771, 891.116, 110.111, 0.000 },
        { 0.000, 16.844, 110.111, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("VisionPos", { 0.000, 1.000, 0.000, 0.000, 1.000, 0.000, 0.000 },
        { 100.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian1_jiejin", { 141.909, 51.661, 16.522, 67.301, 301.013, 47.416, 0.000 },
        { 90.186, 141.468, 49.064, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian1_ningjin", { 141.909, 51.661, 16.522, 131.352, 301.013, 47.416, 0.000 },
        { 90.186, 141.468, 49.064, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian2_guodu1", { 141.883, 51.663, 16.519, 2.771, 831.388, 110.111, 0.000 },
        { -90.115, 141.883, 110.111, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian2_guodu2", { 141.883, 51.663, 16.519, 145.000, 908.620, 262.110, 0.000 },
        { -90.115, 141.709, 262.109, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian2_jiance", { 141.883, 51.663, 16.519, 149.361, 831.388, 254.817, 0.000 },
        { -90.115, 141.883, 254.175, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian2_quliao", { 141.883, 51.663, 16.519, 202.28, 908.620, 264.580, 0.000 },
        { -90.115, 141.883, 262.110, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian3_jiejin", { 141.893, 51.649, 16.522, 61.107, 337.404, 31.274, 0.000 },
        { 90.191, 141.452, 32.923, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian3_ningjin", { 141.893, 51.649, 16.522, 132.027, 337.404, 31.274, 0.000 },
        { 90.191, 141.452, 32.923, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian_guodu1", { 141.883, 51.663, 16.519, 2.771, 831.388, 110.111, 0.000 },
        { 90.194, 141.883, 110.111, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian_guodu2", { 141.883, 51.663, 16.519, 145.000, 908.620, 262.110, 0.000 },
        { 90.194, 141.709, 262.109, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian_jiance", { 141.883, 51.663, 16.519, 149.361, 831.388, 254.817, 0.000 },
        { 90.194, 141.883, 254.817, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("cebian_quliao", { 141.883, 51.663, 16.519, 202.28, 908.620, 264.580, 0.000 },
        { 90.194, 141.883, 262.110, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("hou2_work", { 141.882, 51.663, 16.519, 6.865, 507.695, 87.000, 0.000 },
        { -90.115, 141.037, 83.879, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("hou_work", { 141.883, 51.663, 16.519, 6.865, 382.098, 87.000, 0.000 },
        { 90.194, 141.118, 83.901, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync2_jiaozheng", { 178.173, 711.288, 131.048, 231.918, 608.936, 36.814, 0.000 },
        { 0.196, 177.732, 38.463, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync2_shangjin", { 178.173, 711.288, 161.399, 273.749, 608.936, 36.814, 0.000 },
        { 0.196, 177.732, 38.463, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_guodu1", { 141.883, 51.663, 16.519, 130.468, 635.335, 60.652, 0.000 },
        { -0.183, 141.883, 60.652, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_guodu2", { 141.883, 51.663, 16.519, 162.136, 909.901, 47.000, 0.000 },
        { -0.183, 141.883, 47.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_guodu3", { 141.883, 51.663, 16.519, 145.000, 908.620, 262.110, 0.000 },
        { -0.183, 141.709, 262.109, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_guodu4", { 141.883, 51.663, 16.519, 149.361, 831.388, 53.716, 0.000 },
        { -0.183, 141.883, 53.716, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_jiaozheng", { 141.883, 51.663, 16.519, 224.727, 609.442, 88.271, 0.000 },
        { -0.173, 141.442, 89.919, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_quliao", { 141.883, 51.663, 16.519, 202.28, 908.620, 264.580, 0.000 },
        { -0.183, 141.431, 265.213, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_shangjin", { 141.883, 51.663, 16.519, 274.973, 609.442, 88.271, 0.000 },
        { -0.173, 141.442, 89.919, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync3_work", { 47.679, 41.609, 337.665, 149.361, 831.388, 254.817, 0.000 },
        { -0.183, 47.631, 257.373, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_guodu1", { 82.583, 418.509, 33.293, 130.468, 635.335, 60.652, 0.000 },
        { 0.202, 82.539, 60.622, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_guodu2", { 159.886, -3.560, 60.000, 162.136, 909.901, 47.000, 0.000 },
        { -0.181, 159.886, 47.000, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_guodu3", { 158.473, -5.239, 338.335, 145.000, 908.620, 262.110, 0.000 },
        { -0.181, 159.711, 262.109, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_jiaozheng", { 142.478, 294.986, 121.600, 225.396, 550.000, 31.360, 0.000 },
        { 0.187, 141.537, 32.408, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_quliao", { 158.474, -5.239, 365.159, 202.28, 908.620, 264.580, 0.000 },
        { -0.181, 158.028, 263.286, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_shangjin", { 142.478, 294.986, 160.691, 273.766, 550.000, 31.360, 0.000 },
        { 0.187, 141.537, 32.408, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("sync_work", { 141.881, 398.870, 16.516, 147.561, 642.938, 32.851, 0.000 },
        { 0.196, 141.881, 32.851, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("work3_jiance", { 141.883, 51.663, 16.519, 149.361, 831.388, 254.817, 0.000 },
        { -0.183, 141.883, 254.817, 0.000, 0.000, 0.000, 0.000 })
    JOINTTARGET("work_jiance", { 47.680, 20.505, 338.649, 149.361, 831.388, 254.817, 0.000 },
        { -0.183, 47.235, 256.465, 0.000, 0.000, 0.000, 0.000 })
    STRINGDATA("received", "")
    STRINGDATA("send", "")
end
print("The end!")
