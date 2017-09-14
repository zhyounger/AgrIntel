  <?php
header("Content-Type: text/html; charset=utf-8");
require_once('db.php');
$connect = Db::getInstance()->connect();
// if($connect){
// echo "连接成功";
// }else{
// echo "连接失败";
// }
// echo "</br>";
$pageSize = 15; //每页显示数据条数
$page_size = $pageSize + 1;
$sql ="select * from data where sensor=1";//数据库查询语句
$result = mysqli_query($connect, $sql);//执行查询语句
$totalNum = mysqli_num_rows($result); //数据总条数
$totalPage = ceil($totalNum/$pageSize); //总页数
//判断当前页是哪一页
if(!isset($_GET['page'])||!ceil($_GET['page'])||$_GET['page']>$totalPage)//page可能的四种状态   
{   
    $page=1;   
}   
else   
{   
    $page=$_GET['page'];//如果不满足以上四种情况，则page的值为$_GET['page']   
}   
$startnum = ($page-1)*$pageSize;//开始条数   
//根据time倒序查询数据
$sql = "select * from data where sensor=1 order by time desc limit $startnum,$page_size ";//查询出所需要的条数   
$rs = mysqli_query($connect, $sql);   
$contents = mysqli_fetch_array($rs);
$rs = mysqli_query($connect, $sql);
echo '</br>';
//用while循环读取
while($arr = mysqli_fetch_array($rs, MYSQL_ASSOC)){
    echo '<div style="line-height:25px;text-align:center;">';
    echo '<a href="right1.php?time=';
    echo $arr['time'];
    echo '" style="text-decoration:none" target="right">';
    print_r($arr['time']);
    echo '</a>';
    echo "</div>";
}
 
while($contents = mysqli_fetch_array($rs)); 
$per = $page - 1;//上一页   
$next = $page + 1;//下一页   
echo '<br>';
echo "<center>共".$totalPage."页 ";   
echo '<br>';
if($page != 1)   
{   
echo "<a href='".$_SERVER['PHP_SELF']."' style='text-decoration:none'>首页</a>";//用$_SERVER['PHP_SELF']获取当前页面地址      
echo "<a href='".$_SERVER['PHP_SELF'].'?page='.$per."' style='text-decoration:none'> 上一页</a>";   
}   
if($page != $totalPage)   
{   
echo "<a href='".$_SERVER['PHP_SELF'].'?page='.$next."' style='text-decoration:none'> 下一页</a>";   
echo "<a href='".$_SERVER['PHP_SELF'].'?page='.$totalPage."' style='text-decoration:none'> 尾页</a></center>";   
}   
/*else//如果$total为空则输出No message   
{   
echo "<center>No message</center>";   
} */   
?>
