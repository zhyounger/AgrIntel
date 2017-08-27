<?php
/**
 * 鍗曚緥妯″紡
 */
class Db {
	//鐢ㄤ簬淇濆瓨绫荤殑瀹炰緥鍖栫殑闈欐€佹垚鍛樺彉閲?
	static private $_instance;
	static private $_connectSource;
	private $_dbConfig = array(
		'host'     =>'127.0.0.1',
		'user'     =>'root',
		'password' =>'123456',
		'database' =>'raspberry'
		);

	/**
	 * 鏋勯€犲嚱鏁伴渶瑕佹爣璁颁负闈瀙ublic锛堥槻姝㈠閮ㄤ娇鐢╪ew鎿嶄綔绗﹀垱寤哄璞★級
	 * 鍗曚緥涓嶈兘鍦ㄥ叾浠栫被涓疄渚嬪寲锛屽彧鑳借鑷韩瀹炰緥鍖?
	 */
	private function __construct() {

	}

	/**
	 * 鎷ユ湁涓€涓闂繖涓疄渚嬬殑鍏叡鐨勯潤鎬佹柟娉?
	 * @return [type] [description]
	 */
	static public function getInstance() {
		/**
		 * 鍒ゆ柇绫绘槸鍚﹀凡缁忓疄渚嬪寲
		 */
		if (!self::$_instance instanceof self) {
			self::$_instance = new self();
		}
		return self::$_instance;
	}

	public function connect() {
		if(!self::$_connectSource) {
			self::$_connectSource = mysqli_connect($this->_dbConfig['host'], $this->_dbConfig['user'], $this->_dbConfig['password']);

			if (!self::$_connectSource) {
				//鎶涘嚭寮傚父
				throw new Exception('MySQL connect error'.mysql_error(), 1);
				//die('MySQL connect error'.mysql_error());
			}

			mysqli_select_db(self::$_connectSource, $this->_dbConfig['database']);
			mysqli_query(self::$_connectSource, "set names UTF8");
		}
		return self::$_connectSource;
	}
}

/*
$connect = Db::getInstance()->connect();
$sql = "select * from data";
$result = mysqli_query($connect, $sql);
echo mysqli_num_rows($result);
*/
