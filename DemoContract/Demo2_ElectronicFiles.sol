pragma solidity >=0.4.26;
import "./library.sol";
contract ElectronicFiles{
    struct ElectronicFiles_info{
        bool identify;//证书属否存在
        string filename;//证件名称
        uint CertificateNumber;//证件号
        string Issuer;//颁发单位
        uint timestamp;//颁发时间，时间戳
        address owner;
    }
    mapping(bytes32 => ElectronicFiles_info) ElectronicFile_dic;
    //   Library.user_info private _user_info_data;
    struct admin_info
    {

    string admin_name;//管理名，也可以理解为管理部门部门名
    uint admin_password;//管理员密码
    address admin_address;//管理员地址
    uint time;//timestamp   时间戳自动生成，防止伪造
    mapping(bytes32 => bool) admin_identify;
    }
     using Library for *;
    Library.user_info private _userdata;
    Library.admin_info private _admindata;
    bytes32 admin_secretkey;

    uint  _timestamp;
    event time(uint timestamp);
    //管理员注册，我们这里写死了为了方便orz
    function RegisterAdmin()public returns(bytes32){
        admin_secretkey=Library.RegisterAdmin(_admindata,"蓝天驾校",123,0xca35b7d915458ef540ade6068dfe2f44e8fa733c,block.timestamp);
       return(admin_secretkey);
    }
    //用户注册
   function RegisterUser(string name,uint password,address owner)public returns(bytes32){
       return Library.RegisterUser(_userdata,name,password,owner,block.timestamp);
       
   }
   //生成电子证书。首先要判断操作的是管理员，只有管理有权去授权电子证书
    function GetElectronicFile(string _filename,uint _CertificateNumber,string _Issuer,address _owner)public returns(bytes32 ElectronicFile_Secretkey){
       require(Library.IdentifyAdmin(_admindata,admin_secretkey)==true);
        _timestamp=block.timestamp;
        ElectronicFile_Secretkey= Library.RegisterUser(_userdata,_filename,_CertificateNumber,_owner,_timestamp);
        ElectronicFile_dic[ElectronicFile_Secretkey]=ElectronicFiles_info(true,_filename,_CertificateNumber,_Issuer,_timestamp,_owner);
        return (ElectronicFile_Secretkey);
    }
  //检查电子证书合法性和有效性函数，双重保护1.首先要判断目前拿这个证书的人的地址是否为电子证书拥有者的地址，2.该密钥对应的电子证书已经授权获得了验证。返回为true则用人单位默认这个证书是真实的
function check(bytes32 ElectronicFile_Secretkey)public returns(bool){
    require(ElectronicFile_dic[ElectronicFile_Secretkey].owner==msg.sender,"user is not owner");
    return(Library.IdentifyUser(_userdata,ElectronicFile_Secretkey));
    
}
}