<?php
header("Content-Type: text/html; charset=utf-8");
require_once('db.php');
$connect = Db::getInstance()->connect();
// if($connect){
// echo "连接成功";
// }else{
// echo "连接失败";
// }
//$_GET方式获取数据
$time = $_GET['time'];
$sql = "select * from data where sensor='1' and time='$time'";
$result = mysqli_query($connect,$sql);
$arr = mysqli_fetch_array($result);
echo '<div style="width:40%;height:100%;border:0px solid ;float:left;margin-bottom:15px; margin-top:10px;">';
echo '<img width=100% height=100% src="'.$arr['imgurl'].'"/>';//从数据了获取图片地址
echo '</div>';
echo "</br>";
echo '<div style="width:55%;height:100%;background:;float:right;clear:right;margin-bottom:15px; margin-top:10px;">';
echo "当前温度：";
print_r($arr['tem']);//从数据库获取温度
echo "℃";//温度单位
echo('&nbsp;');
echo('&nbsp;');  
echo "适宜温度范围:";
print_r($arr['mintem']);
echo "-";
print_r($arr['maxtem']);
echo "℃";
echo('&nbsp;'); 
echo('&nbsp;'); 

if($arr['tem'] > $arr['maxtem']){

    echo "当前温度过高，不适合农作物生长，请采取合理的措施";
    echo "<br>";
    echo "建议：";
    echo "<br>";
    echo "1、通风:换气将湿气排除，换入外界干燥的空气，这是最简单的降湿方法。但要防止因通风换气使温室大棚内温度降得过低。";
    echo "<br>";
    echo "2、用无滴膜覆盖:无滴膜可以克服膜内倒附着大量水滴的弊端,明显降低湿度,且透光性能好，有利于温室大棚内的增温降湿。";
    echo "<br>";
    echo "3、地膜覆盖 地膜覆盖可以大大降低地面水分蒸发，且可以减少灌水次数,从而降低温室大棚内的空气湿度。";
    echo "<br>";
    echo "4、粉尘法及烟雾法用药 温室大棚内必须施药时，若采用常规的喷雾法用药，会增加温室大棚内湿度,这对防治病害不利。采用粉尘法及烟雾法用药，则可以克服以上弊端。";

}elseif($arr['tem'] < $arr['mintem']){
   
    echo "当前温度过低，不适合农作物生长，请采取合理的措施";
    echo "<br>";
    echo "建议：";
    echo "<br>";
    echo "1、地多层覆盖 据观测，在塑料大棚内套小拱棚，可使小拱棚内的气温提高2～4℃，地温提高l～2℃；在大棚中采用塑料薄膜做成二层幕，于夜间覆盖，可使棚内气温、地温平均提高1～2℃；在大棚四周覆盖一层1米高的草苫子，亦可使棚温提高 1 ～2℃。";
    echo "<br>";
    echo "2、覆盖地膜 覆盖地膜一般可使10 厘米处地温平均提高2～3℃，地面最低气温提高l℃左右。同时，由于地膜不透气，可抑制水分蒸发，减少浇水次数，间接提高地温。";
    echo "<br>";
    echo "3、起垄栽培高垄表面积大，白天接受光照多，从空气中吸收的热量也多，因而升温快。但垄不宜过高、过宽，一般以高15～20 厘米、宽 30厘米左右为宜。";
    echo "<br>";
    echo "4、保持棚膜清洁，增加进光量 棚内的热量主要来自太阳辐射，当阳光透过棚膜进入棚内时，由于“温室效应” ，使一部分光能转化为热能。而棚膜上的水滴、尘物等对棚内光照条件影响很大。据观测，棚膜上附着一层水滴，可使透光率下降20～30% ；新薄膜使用2天、10天、15天后，因沾染尘物可使棚内光照依次减弱14% 、25%、28%。可见，保持棚膜清洁，有利于增加进光量，提高棚室温度。";

}else{

	echo "当前温度适宜";
}

echo "</br>";//换行
echo "</br>";//换行
echo "当前湿度：";
print_r($arr['hum']);//从数据库获取湿度
echo "%RH";
echo('&nbsp;');
echo('&nbsp;');  
echo "适宜湿度范围:";
print_r($arr['minhum']);
echo "-";
print_r($arr['maxhum']);
echo "%RH";
echo('&nbsp;'); 
echo('&nbsp;'); 

if($arr['hum'] > $arr['maxhum']){

    echo "当前湿度过高，不适合农作物生长，请采取合理的措施";
    echo "<br>";
    echo "建议：";
    echo "<br>";
    echo "1、地膜覆盖:蒸腾作用对于植物光合作用必不可少，无法将其停止，但可以采取相应措施降低地表水分蒸发量，最有效的措施就是大棚内部地表全面地膜覆盖，并将种植孔处用土密封，可有效降低壤土水分蒸发对空气湿度的影响。";
    echo "<br>";
    echo "2、增加通风适当通风可降低棚内湿度，同时增加棚内二氧化碳含量，为避免通风造成温度大幅度降低，已选择中午进行通风降湿。";
    echo "<br>";
    echo "3、减少喷雾：防治病虫害过程中尽量减少喷雾次数，宜采用粉剂或者烟剂。";
    echo "<br>";
    echo "4、吸水材料：可在棚内防治石灰、干草等吸水材料，有条件的话可制作宽厚的土质墙面，通过干燥墙体吸收空气中多余的水分。";


}elseif($arr['hum'] < $arr['minhum']){
   
    echo "当前湿度过低，不适合农作物生长，请采取合理的措施";
    echo "建议：";
    echo "<br>";
    echo " 1、湿帘法，湿帘不仅可以降低温室内的温度，而且对于湿度的提上也有不小的作用。";
    echo "<br>";
    echo "2、喷灌法，利用喷灌增加土壤或者空气的湿度，是常用的一种增湿办法。";
    echo "<br>";
    echo "3、保持一定的封闭性，使室内空气流通不要太快，可以保持温室内的湿度。";
    echo "<br>";
    echo "4、.使用加湿器也是一个不错的选择。";
}else{

	echo "当前湿度适宜";
}

echo "</br>";
echo "</br>";//换行
echo "当前光强：";
print_r($arr['light']);//从数据库获取光强
echo "lux";
echo('&nbsp;');
echo('&nbsp;');  
echo "适宜光强范围:";
print_r($arr['minlight']);
echo "-";
print_r($arr['maxlight']);
echo "lux";
echo('&nbsp;'); 
echo('&nbsp;'); 

if($arr['light'] > $arr['maxlight']){

    echo "当前光强过高，不适合农作物生长，请采取合理的措施";

}elseif($arr['light'] < $arr['minlight']){
   
    echo "当前光强过低，不适合农作物生长，请采取合理的措施";
    echo "建议：";
    echo "<br>";
    echo " 1、调整种植结构与密度：首先，要严格控制作物的高度，做到结构合理，并要保持南低北高，布局均匀的良好群体结构。室内群体总体高度应限制在不可超过温室高度的2/3，以免引起光照条件恶化，降低光合效能。";
    echo "<br>";
    echo "2、 适时揭盖草苫，延长见光时间。冬季日照时间短，为充分地利用光能，揭盖草苫一定要及时、适时。一般只要出太阳，就要拉开草苫，让作物叶片见阳光，进行光合作用，生产有机营养。覆盖草苫，应在日落前后进行，以便尽量延长作物的见光时间，提高光能利用率。若遇阴雨雪天或寒冷天气，也要适时拉揭草苫和覆盖草苫，一般可比晴天推迟半小时左右拉揭草苫，提前半小时左右覆盖草苫，绝不允许不拉揭草苫。";
    echo "<br>";
    echo "3、实行南北行向、宽窄行栽种：在节能日光温室内种植蔬菜，为充分利用光能，应实行南北行向、宽窄行栽植。";
}else{

	echo "当前光强适宜";
}

echo "</br>";
echo "</br>";//换行
echo '</div>';