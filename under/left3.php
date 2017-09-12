<?php
header("Content-Type: text/html; charset=utf-8");
echo "</br>";//换行
echo "</br>";
echo "</br>";
echo "</br>";
echo "</br>";
echo "</br>";
echo '<div style="line-height:25px;text-align:center;font-size: 22px">';//在div里设置文字样式
echo '<a href="tem.php';
echo '" style="text-decoration:none " target="right">';
echo "温度";
echo '</a>';
echo "</br>";
echo "</br>";
echo '<a href="hum.php';
echo '" style="text-decoration:none" target="right">';
echo "湿度";
echo '</a>';
echo "</br>";
echo "</br>";
echo '<a href="light.php';
echo '" style="text-decoration:none" target="right">';
echo "光强";
echo '</a>';
echo "</br>";
echo "</div>";
?>