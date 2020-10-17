# library
## 1 如何使用
下载library.sol文件
在你的solidity文件中添加。推荐使用solidity在线编辑器
[Remix-Ide](https://remix.ethereum.org/#optimize=false&evmVersion=null&version=soljson-v0.4.26+commit.4563c3fc.js&appVersion=0.7.7)
在自己的solidity中导入库文件
```bash
//导入库文件
import "./library.sol";
```
调用库文件中的结构体
引用
```bash
  Library.user_info private _user_info_daata;
  Library.admin_info private _user_info_daata;
```
引入library。关于using语法在picture中有图片说明
```bash
Using library for *
```

之后就可以调用方法了。调用时只需要
`Library.functionname(参数1，参数2...参数n）`即可

## 2包含的库函数及使用方法
首先我们大致介绍一下库函数包含的。它有一个用户的结构体和管理员的结构体定义。
用户的结构体中包含用户名，密码，用户地址，时间戳。等常规信息。由于library不允许出现全局变量，为此我们在用户结构体中设置了一个mapping变量，由用户加密后的哈希值和用户注册状态做键值对配对，用户注册后将该值改为true。用户登陆时只需要验证这个即可，注销用户将该值改为false就行了。

管理员中除了用户拥有的信息，还加了一个mapping映射，由管理员的地址映射管理员拥有的权限值。有了这个可以方便我们做权限分配和按需公开信息。

这里需要特别指出，你需要调用到结构体中的mapping变量，你需要传入自身。（类似于java中的self）主要规则是，如用户注册的时候我们在库函数中用到了mapping（bytes32=>bool），库函数中我们已经传入了自身便于外部函数调用。在调用时，在你的合约中，只要先定义一句 'Library.user_info private _userData;'.即可，user_info是库函数中用户结构体名称，后面是我们为这个的命名，这个名称可以修改。
之后我们注册调用时只需要
Library.RegisterUser(_userData,string,uint,uint)；多传一个参数即它自身即可。
管理员注册权限分配也是如此，这里就不再赘述。


1.用户注册函数 RegisterUser(self,string,uint,address,uint) returns(bytes32)
传入参数分别为用户自身，方便外部函数去调用。一个string类型的可以为用户名/其他。uint类型的可以为身份识别码，注册用户的地址，还有一个uint类型可以为时间戳。注册功能传入的为不可更改，不允许更改的信息。返回一个bytes32类型的加密哈希值。这个哈希值为用户登陆的凭证。因为solidity中library不允许使用状态变量，故这里无法使用mapping（bytes => struct）去通过这个哈希值映射去寻找结构体中的其他变量，只能用户在写函数时自己定义。
调用时只需要调用``RegisterUser(self,string,uint,address,uint)``

2.管理员注册函数
RegisterUser(slef,string,uint,adddress,uint)public  returns(bytes32 )
与用户注册一样。唯一的区别是，管理员注册的时候还会将结构体中该管理地址映射的权限值赋一个初值0；

3.用户登陆
Userlogin(self,bytes32)returns(string)
通过self调用user结构体中该密钥对应的注册状态为真
返回欢迎用户登陆的字符串
4.管理员登陆
Adminlogin（self，bytes32）returns（string）
通过self调用admin结构体中该密钥对应的注册状态为真
返回欢迎用户登陆的字符串
5.计算进行xx操作需要的权限值
Power(uint[],uint num)returns(uint)
传入用户需要进行的操作对应的操作值以及总共需要授权的操作个数即数组长度，返回一个uint类型即需要的权限值。
6.授权函数
Authorization(self,address,uint)returns(bool)
传入管理员地址以及授权的权限值
7查看xx拥有的权限值
ViewPermission(self,adddress)returns(uint)
传入管理员地址，返回该管理拥有的权限值
8.权限验证
传入两个值，1个是管理拥有的权限值，一个是进行xx操作需要的权限值，进行与运算
if（（own&2**need）==2**need）则返回true，拥有这个权限，去进行xx操作，否则返回false。
