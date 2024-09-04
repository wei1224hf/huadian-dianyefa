// name: modbus 报文拆分
// outputs: 2
// timeout: 0
// initialize: // 部署节点后，此处添加的代码将运行一次。 \n
// finalize: // 此处添加的代码，将在停止或重新部署节点时运行。 \n
// info: 
var t = msg.payload;
if(t.Value==0 && t.Address==4010){
    t.RequestID = "-";
}
var Request = global.get("Request_10");
Request.RequestID = t.RequestID;
var t2 = (new Date()).toISOString();
Request.StartTime = t2;
Request.EndTime = "";

var IO = global.get("IO_10");
IO.AI_LCS.request_ = t.Value;


if (t.Value == 12 && IO.DI.L_DOtuopanyouliao == 0) {
    msg.payload = { Code: 1, Msg: "没有托盘,不能操作" };
    node.send([, msg]);
}
else {
    msg.payload = { Code: 0, Msg: "操作成功" };
    node.send([{ payload: { value: parseInt(t.Value), 'fc': 6, 'unitid': 1, 'address': parseInt(t.Address), 'quantity': 1 } }, 
        msg]);
}