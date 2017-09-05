<?php
header ( "Content-type: text/html; charset=UTF-8" );
include("../jpgraph-4.0.2/src/jpgraph.php");
include("../jpgraph-4.0.2/src/jpgraph_line.php");
include ("../jpgraph-4.0.2/src/jpgraph_scatter.php");
//连接数据库
require_once('db.php');
$connect = Db::getInstance()->connect();
//数据库查询语句
$sql = "select * from data where sensor='1' order by time desc limit 0,24";
//执行查询
$result = mysqli_query($connect,$sql);

$data_array = [];
//foreacha遍历数组
foreach ($result as $key => $value) 
{
    $data_array[] = $value;
}
//count函数计算数组长度，for循环查询
for ($i = count($data_array) - 1; $i >= 0; $i--)
{
    $tem1[] = $data_array[$i]['tem'];
}

for ($i = count($data_array) - 1; $i >= 0; $i--) 
{
    $time[] = $data_array[$i]['time'];
}

$day = array();
for($i=0;$i<count($time);$i++)
{    
	//用substr()函数截取字符串长度
	 $day[$i]=substr($time[$i], 11, 5);
	 //用str_replace()函数替换字符串的符号
	 $str[$i] = str_replace("-",":",$day[$i]);

}

$sql = "select * from data where sensor='2' order by time desc limit 0,24";
$result = mysqli_query($connect,$sql);
$data_array = [];
foreach ($result as $key => $value) 
{
    $data_array[] = $value;
}
for ($i = count($data_array) - 1; $i >= 0; $i--)
{
    $tem2[] = $data_array[$i]['tem'];
}

$graph = new Graph(1400, 600);//创建统计图对象
$graph->SetScale('textlin');//设置刻度样式，X轴和Y轴
$graph->SetY2Scale('lin');
$graph->SetShadow();//设置背景带阴影
$graph->img->SetMargin(60, 60, 20, 70);// 设置图表灰度四周边距，顺序为左右上下
$graph->title->Set(iconv('utf-8', 'GB2312//IGNORE', 'humidity'));//设置走势图的标题　　 
$lineplot1 = new LinePlot($tem1);//创建折线图  
$lineplot2 = new LinePlot($tem2);//创建折线图  
$graph->Add($lineplot1);
$graph->AddY2($lineplot2);//设置两侧都有y轴 
$graph->xaxis->title->Set(iconv('utf-8', 'GB2312//IGNORE', "time"));//设置x轴的标题
$graph->yaxis->title->Set(iconv('utf-8', 'GB2312//IGNORE', "sensor1"));//设置y轴的标题
$graph->y2axis->title->Set(iconv('utf-8', 'GB2312//IGNORE', "sensor2"));//设置y轴的标题
//设置x轴的数值
$graph->xaxis->SetTickLabels($str);
$graph->yaxis->title->SetMargin(20);//设置右边的title到图的距离
$graph->y2axis->title->SetMargin(30);//设置右边的title到图的距离
$graph->title->SetFont(FF_SIMSUN, FS_BOLD);//设置字体
$graph->yaxis->title->SetFont(FF_SIMSUN, FS_BOLD);
$graph->y2axis->title->SetFont(FF_SIMSUN, FS_BOLD);
$graph->xaxis->title->SetFont(FF_SIMSUN, FS_BOLD);
$lineplot2->SetColor('blue');//设置颜色
$lineplot2->SetLegend('sensor2');//设置线条颜色  
$lineplot1->SetColor('red');//设置颜色
$lineplot1->SetLegend('sensor1');//设置线条颜色  
$graph->legend->SetLayout(LEGEND_HOR);
$graph->legend->Pos(0.5, 0.9, 'center', 'bottom');
//图例文字框的位置 0.4，0.95 是以右上角为基准的，0.4是距左右距离，0.95是上下距离。
$graph->Stroke();//输出
//关闭数据库
mysqli_close($connect);